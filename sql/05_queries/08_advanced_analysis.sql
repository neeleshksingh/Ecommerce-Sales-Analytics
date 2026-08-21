/*
===============================================================================
Question    : Customer Purchase Frequency
Description : Calculates customer order frequency using total orders,
              first and last purchase dates, customer lifetime, and average
              days between purchases.
===============================================================================
*/

WITH customer_purchase_history AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        MIN(o.order_purchase_timestamp::date) AS first_purchase_date,
        MAX(o.order_purchase_timestamp::date) AS last_purchase_date
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_unique_id
)
SELECT
    customer_unique_id,
    total_orders,
    first_purchase_date,
    last_purchase_date,
    (last_purchase_date - first_purchase_date) AS customer_lifetime_days,
    CASE
        WHEN total_orders > 1
        THEN
            ROUND((last_purchase_date - first_purchase_date)::numeric / (total_orders - 1), 2)
    END AS average_days_between_orders
FROM customer_purchase_history
ORDER BY
    total_orders DESC;

/*
===============================================================================
Question    : Customer Recency Analysis
Description : Calculates the number of days since each customer's most recent
              purchase and classifies customers based on their recency.
===============================================================================
*/

WITH customer_last_purchase AS
(
    SELECT
        c.customer_unique_id,
        MAX(o.order_purchase_timestamp::date) AS last_purchase_date
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_unique_id
),
customer_recency AS
(
    SELECT
        customer_unique_id,
        last_purchase_date,
        (CURRENT_DATE - last_purchase_date) AS recency_days
    FROM customer_last_purchase
)
SELECT
    customer_unique_id,
    last_purchase_date,
    recency_days,
    CASE
        WHEN recency_days <= 30
            THEN 'Recent Customer'
        WHEN recency_days <= 90
            THEN 'Active Customer'
        ELSE 'Inactive Customer'
    END AS customer_status
FROM customer_recency
ORDER BY
    recency_days ASC;


/*
===============================================================================
Question    : Product Price vs Category Average
Description : Identifies products whose average selling price is higher than
              the average selling price of their product category.
===============================================================================
*/

WITH product_prices AS
(
    SELECT
        p.product_id,
        p.product_category_name_english AS product_category,
        ROUND(AVG(oi.price)::numeric, 2) AS average_product_price
    FROM vw_products AS p
    INNER JOIN order_items AS oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_id,
        p.product_category_name_english
),

category_prices AS
(
    SELECT
        product_category,
        ROUND(AVG(average_product_price)::numeric, 2) AS category_average_price
    FROM product_prices
    GROUP BY
        product_category
)

SELECT
    p.product_id,
    p.product_category,
    p.average_product_price,
    c.category_average_price,
    ROUND((p.average_product_price - c.category_average_price)::numeric, 2) AS price_difference
FROM product_prices AS p
INNER JOIN category_prices AS c
    ON p.product_category = c.product_category
WHERE
    p.average_product_price > c.category_average_price
ORDER BY
    price_difference DESC;/*
===============================================================================
Question    : Customer Lifetime Value
Description : Calculates customer lifetime value metrics including total
              spending, average order value, customer lifetime, and average
              revenue generated per lifetime day.
===============================================================================
*/

WITH customer_value AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        ROUND(
            SUM(oi.price)::numeric,
            2
        ) AS total_spent,
        MIN(
            o.order_purchase_timestamp::date
        ) AS first_purchase_date,
        MAX(
            o.order_purchase_timestamp::date
        ) AS last_purchase_date
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_unique_id
),
customer_lifetime AS
(
    SELECT
        customer_unique_id,
        total_orders,
        total_spent,
        ROUND(
            (
                total_spent /
                total_orders
            )::numeric,
            2
        ) AS average_order_value,
        (
            last_purchase_date -
            first_purchase_date
        ) AS customer_lifetime_days
    FROM customer_value
)
SELECT
    customer_unique_id,
    total_orders,
    total_spent,
    average_order_value,
    customer_lifetime_days,
    CASE
        WHEN customer_lifetime_days > 0
        THEN
            ROUND(
                (
                    total_spent /
                    customer_lifetime_days
                )::numeric,
                2
            )
        ELSE NULL
    END AS revenue_per_lifetime_day
FROM customer_lifetime
ORDER BY
    total_spent DESC;



   /*
===============================================================================
Question    : RFM Customer Segmentation
Description : Calculates Recency, Frequency, and Monetary metrics for each
              customer and assigns a score from 1 to 4 for each metric.
===============================================================================
*/

WITH customer_rfm AS
(
    SELECT
        c.customer_unique_id,
        (
            CURRENT_DATE -
            MAX(o.order_purchase_timestamp::date)
        ) AS recency,
        COUNT(DISTINCT o.order_id) AS frequency,
        ROUND(
            SUM(oi.price)::numeric,
            2
        ) AS monetary
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_unique_id
),
rfm_scores AS
(
    SELECT
        customer_unique_id,
        recency,
        frequency,
        monetary,
        NTILE(4) OVER(
            ORDER BY recency ASC
        ) AS recency_score,
        NTILE(4) OVER(
            ORDER BY frequency ASC
        ) AS frequency_score,
        NTILE(4) OVER(
            ORDER BY monetary ASC
        ) AS monetary_score
    FROM customer_rfm
)
SELECT
    customer_unique_id,
    recency,
    frequency,
    monetary,
    recency_score,
    frequency_score,
    monetary_score,
    (
        recency_score +
        frequency_score +
        monetary_score
    ) AS rfm_score
FROM rfm_scores
ORDER BY
    rfm_score DESC;


/*
===============================================================================
Question    : Seller Performance vs State Average
Description : Identifies sellers whose total revenue is higher than the
              average seller revenue within their respective state.
===============================================================================
*/

WITH seller_revenue AS
(
    SELECT
        s.seller_id,
        s.seller_state,
        ROUND(
            SUM(oi.price)::numeric,
            2
        ) AS total_revenue
    FROM sellers AS s
    INNER JOIN order_items AS oi
        ON s.seller_id = oi.seller_id
    GROUP BY
        s.seller_id,
        s.seller_state
),
state_average AS
(
    SELECT
        seller_state,
        ROUND(
            AVG(total_revenue)::numeric,
            2
        ) AS state_average_revenue
    FROM seller_revenue
    GROUP BY
        seller_state
)
SELECT
    sr.seller_id,
    sr.seller_state,
    sr.total_revenue,
    sa.state_average_revenue,
    ROUND(
        (
            sr.total_revenue -
            sa.state_average_revenue
        )::numeric,
        2
    ) AS revenue_difference
FROM seller_revenue AS sr
INNER JOIN state_average AS sa
    ON sr.seller_state = sa.seller_state
WHERE
    sr.total_revenue > sa.state_average_revenue
ORDER BY
    revenue_difference DESC;




/*
===============================================================================
Question    : Customer Cohort Analysis
Description : Groups customers into cohorts based on the month of their
              first purchase and calculates the number of customers in
              each cohort.
===============================================================================
*/

WITH customer_first_purchase AS
(
    SELECT
        c.customer_unique_id,
        MIN(
            o.order_purchase_timestamp
        ) AS first_purchase_date
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_unique_id
),
customer_cohorts AS
(
    SELECT
        customer_unique_id,
        DATE_TRUNC(
            'month',
            first_purchase_date
        ) AS cohort_month
    FROM customer_first_purchase
)
SELECT
    cohort_month,
    COUNT(customer_unique_id) AS customer_count
FROM customer_cohorts
GROUP BY
    cohort_month
ORDER BY
    cohort_month;



/*
===============================================================================
Question    : High-Value At-Risk Customers
Description : Identifies customers who have spent more than the average
              customer but have not purchased within the last 90 days.
===============================================================================
*/

WITH customer_metrics AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        ROUND(
            SUM(oi.price)::numeric,
            2
        ) AS total_spent,
        MAX(
            o.order_purchase_timestamp::date
        ) AS last_purchase_date
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_unique_id
),
customer_recency AS
(
    SELECT
        customer_unique_id,
        total_orders,
        total_spent,
        last_purchase_date,
        CURRENT_DATE - last_purchase_date AS recency_days
    FROM customer_metrics
),
customer_average AS
(
    SELECT
        *,
        AVG(total_spent) OVER() AS average_customer_spending
    FROM customer_recency
)
SELECT
    customer_unique_id,
    total_orders,
    total_spent,
    last_purchase_date,
    recency_days,
    'High-Value At-Risk' AS customer_status
FROM customer_average
WHERE
    total_spent > average_customer_spending
    AND recency_days > 90
ORDER BY
    total_spent DESC;

