/*
===============================================================================
View        : vw_orders
Description : Provides a business-friendly view of customer orders by combining
              order and customer information.
===============================================================================
*/

CREATE OR REPLACE VIEW vw_orders AS

SELECT
    o.order_id,
    o.customer_id,
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date

FROM orders AS o

INNER JOIN customers AS c
    ON o.customer_id = c.customer_id;