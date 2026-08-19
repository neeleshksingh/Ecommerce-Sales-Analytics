/*
===============================================================================
Question    : Top 10 Customers by Revenue
Description : Identifies the ten highest-spending customers based on their
              total product spending and number of orders.
===============================================================================
*/

WITH customer_revenue AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        ROUND(
            SUM(oi.price)::numeric,
            2
        ) AS total_spent
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_unique_id
),
customer_ranking AS
(
    SELECT
        customer_unique_id,
        total_orders,
        total_spent,
        ROW_NUMBER() OVER(
            ORDER BY total_spent DESC
        ) AS customer_rank
    FROM customer_revenue
)
SELECT
    customer_unique_id,
    total_orders,
    total_spent,
    customer_rank
FROM customer_ranking
WHERE customer_rank <= 10
ORDER BY
    customer_rank;


/*
===============================================================================
Question    : Highest Customer Spending by State
Description : Identifies the highest-spending customer within each customer
              state based on their total product spending.
===============================================================================
*/

WITH customer_spending AS
(
    SELECT
        c.customer_state,
        c.customer_unique_id,
        ROUND(
            SUM(oi.price)::numeric,
            2
        ) AS total_spent
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_state,
        c.customer_unique_id
),

state_customer_ranking AS
(
    SELECT
        customer_state,
        customer_unique_id,
        total_spent,
        RANK() OVER(
            PARTITION BY customer_state
            ORDER BY total_spent DESC
        ) AS state_rank
    FROM customer_spending
)
SELECT
    customer_state,
    customer_unique_id,
    total_spent,
    state_rank
FROM state_customer_ranking
WHERE state_rank = 1
ORDER BY
    customer_state;/*
===============================================================================
Question    : Highest-Revenue Product Categories
Description : Calculates total revenue, revenue contribution percentage,
              and revenue ranking for each product category.
===============================================================================
*/

WITH category_revenue AS
(
    SELECT
        p.product_category_name AS product_category,
        ROUND(
            SUM(oi.price)::numeric,
            2
        ) AS total_revenue
    FROM products AS p
    INNER JOIN order_items AS oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_category_name
),
category_analysis AS
(
    SELECT
        product_category,
        total_revenue,
        ROUND(
            (
                total_revenue /
                NULLIF(SUM(total_revenue) OVER(), 0)
            ) * 100,
            2
        ) AS revenue_percentage,
        RANK() OVER(
            ORDER BY total_revenue DESC
        ) AS revenue_ran
    FROM category_revenue
)
SELECT
    product_category,
    total_revenue,
    revenue_percentage,
    revenue_rank
FROM category_analysis
ORDER BY
    revenue_rank;


/*
===============================================================================
Question    : Best Seller Revenue & Order Performance
Description : Calculates key sales performance metrics for each seller,
              including total orders, items sold, revenue, and average
              order value.
===============================================================================
*/

SELECT
    s.seller_id,
    s.seller_state,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(oi.product_id) AS total_items_sold,
    ROUND(
        SUM(oi.price)::numeric,
        2
    ) AS total_revenue,
    ROUND(
        (
            SUM(oi.price) /
            COUNT(DISTINCT oi.order_id)
        )::numeric,
        2
    ) AS average_order_value
FROM sellers AS s
INNER JOIN order_items AS oi
    ON s.seller_id = oi.seller_id
GROUP BY
    s.seller_id,
    s.seller_state
ORDER BY
    total_revenue DESC;


/*
===============================================================================
Question    : Repeat Customer Percentage
Description : Calculates the number and percentage of repeat and one-time
              customers based on their total number of orders.
===============================================================================
*/

WITH customer_orders AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_unique_id
),
customer_segments AS
(
    SELECT
        customer_unique_id,
        total_orders,
        CASE
            WHEN total_orders >= 2
                THEN 'Repeat Customer'
            ELSE 'One-Time Customer'
        END AS customer_type
    FROM customer_orders
),
customer_counts AS
(
    SELECT
        customer_type,
        COUNT(customer_unique_id) AS customer_count
    FROM customer_segments
    GROUP BY
        customer_type
)
SELECT
    customer_type,
    customer_count,
    ROUND(
        (
            customer_count::numeric /
            NULLIF(SUM(customer_count) OVER(), 0)
        ) * 100,
        2
    ) AS customer_percentage
FROM customer_counts
ORDER BY
    customer_count DESC;


/*
===============================================================================
Question    : Delivery Performance by State
Description : Calculates average delivery time, total orders, late orders,
              and late delivery percentage for each customer state.
===============================================================================
*/

WITH delivery_data AS
(
    SELECT
        c.customer_state,
        o.order_id,
        (
            o.order_delivered_customer_date::date -
            o.order_approved_at::date
        ) AS delivery_days,
        CASE
            WHEN o.order_delivered_customer_date >
                 o.order_estimated_delivery_date
            THEN 1
            ELSE 0
        END AS late_delivery
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    WHERE
        o.order_delivered_customer_date IS NOT NULL
        AND o.order_approved_at IS NOT NULL
),
state_delivery AS
(
    SELECT
        customer_state,
        COUNT(order_id) AS total_orders,
        ROUND(
            AVG(delivery_days)::numeric,
            2
        ) AS average_delivery_days,
        SUM(late_delivery) AS late_orders
    FROM delivery_data
    GROUP BY
        customer_state
)
SELECT
    customer_state,
    total_orders,
    average_delivery_days,
    late_orders,
    ROUND(
        (
            late_orders::numeric /
            NULLIF(total_orders, 0)
        ) * 100,
        2
    ) AS late_delivery_percentage
FROM state_delivery
ORDER BY
    average_delivery_days DESC;



/*
===============================================================================
Question    : Highest-Revenue Customer Segment
Description : Segments customers into one-time and repeat customers and
              identifies the revenue generated by each customer segment.
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
        ) AS total_spent
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_unique_id
),
customer_segments AS
(
    SELECT
        customer_unique_id,
        total_orders,
        total_spent,
        CASE
            WHEN total_orders >= 2
                THEN 'Repeat Customer'
            ELSE 'One-Time Customer'
        END AS customer_type
    FROM customer_value
),
segment_summary AS
(
    SELECT
        customer_type,
        COUNT(customer_unique_id) AS customer_count,
        ROUND(
            SUM(total_spent)::numeric,
            2
        ) AS total_revenue,
        ROUND(
            (
                SUM(total_spent) /
                COUNT(customer_unique_id)
            )::numeric,
            2
        ) AS average_customer_revenue
    FROM customer_segments
    GROUP BY
        customer_type
)
SELECT
    customer_type,
    customer_count,
    total_revenue,
    average_customer_revenue,
    ROUND(
        (
            total_revenue /
            NULLIF(SUM(total_revenue) OVER(), 0)
        ) * 100,
        2
    ) AS revenue_percentage
FROM segment_summary
ORDER BY
    total_revenue DESC;


/*
===============================================================================
Question    : Highest Revenue Growth Months
Description : Identifies the months with the highest month-over-month
              revenue growth based on monthly sales performance.
===============================================================================
*/

WITH monthly_revenue AS
(
    SELECT
        DATE_TRUNC(
            'month',
            o.order_purchase_timestamp
        ) AS month,
        ROUND(
            SUM(oi.price)::numeric,
            2
        ) AS monthly_revenue
    FROM orders AS o
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        month
),
revenue_comparison AS
(
    SELECT
        month,
        monthly_revenue,
        LAG(monthly_revenue) OVER(
            ORDER BY month
        ) AS previous_month_revenue
    FROM monthly_revenue
)
SELECT
    month,
    monthly_revenue,
    previous_month_revenue,
    ROUND(
        (
            (
                monthly_revenue - previous_month_revenue
            )
            / NULLIF(previous_month_revenue, 0)
        ) * 100,
        2
    ) AS revenue_growth_percentage
FROM revenue_comparison
WHERE previous_month_revenue IS NOT NULL
ORDER BY
    revenue_growth_percentage DESC;


/*
===============================================================================
Question    : Categories with Declining Revenue
Description : Identifies product categories whose monthly revenue decreased
              compared with the previous month.
===============================================================================
*/

WITH category_monthly_revenue AS
(
    SELECT
        DATE_TRUNC(
            'month',
            o.order_purchase_timestamp
        ) AS month,
        p.product_category_name_english AS product_category,
        ROUND(
            SUM(oi.price)::numeric,
            2
        ) AS monthly_revenue
    FROM orders AS o
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    INNER JOIN vw_products AS p
        ON oi.product_id = p.product_id
    GROUP BY
        month,
        p.product_category_name_english
),
category_revenue_comparison AS
(
    SELECT
        month,
        product_category,
        monthly_revenue,
        LAG(monthly_revenue) OVER(
            PARTITION BY product_category
            ORDER BY month
        ) AS previous_month_revenue
    FROM category_monthly_revenue
)
SELECT
    month,
    product_category,
    monthly_revenue,
    previous_month_revenue,
    ROUND(
        (monthly_revenue - previous_month_revenue)::numeric,
        2
    ) AS revenue_change
FROM category_revenue_comparison
WHERE
    previous_month_revenue IS NOT NULL
    AND monthly_revenue < previous_month_revenue
ORDER BY
    month,
    revenue_change;


/*
===============================================================================
Question    : Customer Revenue Contribution
Description : Calculates each customer's total spending, percentage
              contribution to company revenue, and revenue ranking.
===============================================================================
*/

WITH customer_revenue AS
(
    SELECT
        c.customer_unique_id,
        ROUND(
            SUM(oi.price)::numeric,
            2
        ) AS total_spent
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_unique_id
)

SELECT
    customer_unique_id,
    total_spent,
    ROUND(
        (
            total_spent /
            NULLIF(SUM(total_spent) OVER(), 0)
        ) * 100,
        2
    ) AS revenue_percentage,
    RANK() OVER(
        ORDER BY total_spent DESC
    ) AS customer_rank
FROM customer_revenue
ORDER BY
    customer_rank;