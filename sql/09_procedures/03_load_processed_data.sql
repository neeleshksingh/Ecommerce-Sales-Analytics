/*
===============================================================================
PROCEDURE: sp_load_processed_customer_data
===============================================================================

Question:
    Create a procedure that refreshes a processed customer-level table
    containing important customer sales metrics.

Reused Analysis:
    Customer value + customer lifetime analysis.

Metrics:
    - Customer unique ID
    - Total orders
    - Total spent
    - Average order value
    - First purchase date
    - Last purchase date

Purpose:
    Transform raw transactional data into a reusable processed dataset.

===============================================================================
*/


/*
===============================================================================
STEP 1 — CREATE PROCESSED TABLE
===============================================================================
*/

CREATE TABLE IF NOT EXISTS processed_customer_sales
(
    customer_unique_id VARCHAR,
    total_orders INTEGER,
    total_spent NUMERIC(15, 2),
    average_order_value NUMERIC(15, 2),
    first_purchase_date DATE,
    last_purchase_date DATE,
    loaded_at TIMESTAMP
);


/*
===============================================================================
STEP 2 — CREATE PROCEDURE
===============================================================================
*/

CREATE OR REPLACE PROCEDURE sp_load_processed_customer_data()
LANGUAGE SQL
AS $$

    /*
    Remove the previous processed data.
    */

    TRUNCATE TABLE processed_customer_sales;


    /*
    Recalculate customer-level metrics
    and load the processed table.
    */

    INSERT INTO processed_customer_sales
    (
        customer_unique_id,
        total_orders,
        total_spent,
        average_order_value,
        first_purchase_date,
        last_purchase_date,
        loaded_at
    )

    SELECT
        c.customer_unique_id,

        COUNT(
            DISTINCT o.order_id
        )::INTEGER AS total_orders,

        ROUND(
            SUM(oi.price)::numeric,
            2
        ) AS total_spent,

        ROUND(
            (
                SUM(oi.price)
                /
                NULLIF(
                    COUNT(DISTINCT o.order_id),
                    0
                )
            )::numeric,
            2
        ) AS average_order_value,

        MIN(
            o.order_purchase_timestamp::date
        ) AS first_purchase_date,

        MAX(
            o.order_purchase_timestamp::date
        ) AS last_purchase_date,

        CURRENT_TIMESTAMP

    FROM customers AS c

    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id

    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id

    GROUP BY
        c.customer_unique_id;

$$;


/*
===============================================================================
STEP 3 — EXECUTE PROCEDURE
===============================================================================
*/

CALL sp_load_processed_customer_data();


/*
===============================================================================
STEP 4 — CHECK RESULT
===============================================================================
*/

SELECT *
FROM processed_customer_sales
ORDER BY total_spent DESC;