/*
===============================================================================
View        : vw_sales
Description : Provides sales information at the order-item level.
===============================================================================
*/

CREATE OR REPLACE VIEW vw_sales AS

SELECT

    o.order_id,

    o.order_purchase_timestamp,

    c.customer_id,
    c.customer_city,
    c.customer_state,

    s.seller_id,

    oi.product_id,

    p.product_category_name,

    pct.product_category_name_english,

    oi.price,

    oi.freight_value

FROM orders AS o

INNER JOIN order_items AS oi
    ON o.order_id = oi.order_id

INNER JOIN customers AS c
    ON o.customer_id = c.customer_id

INNER JOIN sellers AS s
    ON oi.seller_id = s.seller_id

INNER JOIN products AS p
    ON oi.product_id = p.product_id

LEFT JOIN product_category_translation AS pct
    ON p.product_category_name = pct.product_category_name;