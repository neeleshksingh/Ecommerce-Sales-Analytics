/*
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