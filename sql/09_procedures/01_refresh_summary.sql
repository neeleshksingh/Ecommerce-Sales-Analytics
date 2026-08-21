/*
===============================================================================
PROCEDURE: sp_refresh_summary
===============================================================================

Question:
    Create a procedure that refreshes a summary table containing
    overall ecommerce sales metrics.

Reused Analysis:
    Executive sales summary from 05_queries.

Metrics:
    - Total orders
    - Total customers
    - Total products sold
    - Total revenue
    - Average order value
    - Average item price

===============================================================================
*/


/*
===============================================================================
STEP 1 — CREATE SUMMARY TABLE
===============================================================================
*/

CREATE TABLE IF NOT EXISTS ecommerce_sales_summary
(
    total_orders INTEGER,
    total_customers INTEGER,
    total_products_sold INTEGER,
    total_revenue NUMERIC(15, 2),
    average_order_value NUMERIC(15, 2),
    average_item_price NUMERIC(15, 2),
    refreshed_at TIMESTAMP
);


/*
===============================================================================
STEP 2 — CREATE PROCEDURE
===============================================================================
*/

CREATE OR REPLACE PROCEDURE sp_refresh_summary()
LANGUAGE SQL
AS $$
    
    /*
    Remove the previous summary.
    */

    TRUNCATE TABLE ecommerce_sales_summary;


    /*
    Recalculate the latest summary
    and insert it into the summary table.
    */

    INSERT INTO ecommerce_sales_summary
    (
        total_orders,
        total_customers,
        total_products_sold,
        total_revenue,
        average_order_value,
        average_item_price,
        refreshed_at
    )

    SELECT
        COUNT(DISTINCT o.order_id)::INTEGER,

        COUNT(
            DISTINCT c.customer_unique_id
        )::INTEGER,

        COUNT(oi.product_id)::INTEGER,

        ROUND(
            SUM(oi.price)::numeric,
            2
        ),

        ROUND(
            (
                SUM(oi.price)
                /
                NULLIF(COUNT(DISTINCT o.order_id), 0)
            )::numeric,
            2
        ),

        ROUND(
            AVG(oi.price)::numeric,
            2
        ),

        CURRENT_TIMESTAMP

    FROM customers AS c

    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id

    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id;

$$;


/*
===============================================================================
STEP 3 — EXECUTE PROCEDURE
===============================================================================
*/

CALL sp_refresh_summary();


/*
===============================================================================
STEP 4 — CHECK RESULT
===============================================================================
*/

SELECT *
FROM ecommerce_sales_summary;