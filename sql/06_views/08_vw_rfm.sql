/*
===============================================================================
View        : vw_rfm
Description : Provides RFM (Recency, Frequency, Monetary) metrics for each
              customer to support customer segmentation and analytics.
===============================================================================
*/

CREATE OR REPLACE VIEW vw_rfm AS

SELECT
    c.customer_unique_id,

    MIN(c.customer_id) AS customer_id,

    c.customer_city,

    c.customer_state,

    MAX(o.order_purchase_timestamp) AS last_purchase_date,

    CURRENT_DATE - MAX(o.order_purchase_timestamp)::date AS recency,

    COUNT(DISTINCT o.order_id) AS frequency,

    ROUND(SUM(oi.price)::numeric, 2) AS monetary

FROM customers AS c

INNER JOIN orders AS o
    ON c.customer_id = o.customer_id

INNER JOIN order_items AS oi
    ON o.order_id = oi.order_id

GROUP BY
    c.customer_unique_id,
    c.customer_city,
    c.customer_state;