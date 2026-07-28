/*
===============================================================================
File Name   : 07_validation_summary.sql
Description : Final validation report for the Olist dataset.
Purpose     : Provide a single health report indicating whether the dataset
              is ready for constraints, cleaning, analytics and reporting.
===============================================================================
*/

WITH validation_results AS (

    ---------------------------------------------------------------------------
    -- 1. Empty Tables
    ---------------------------------------------------------------------------
    SELECT
        'Empty Tables' AS validation_name,
        COUNT(*) AS invalid_records
    FROM (
        SELECT COUNT(*) AS cnt FROM customers
        UNION ALL
        SELECT COUNT(*) FROM orders
        UNION ALL
        SELECT COUNT(*) FROM order_items
        UNION ALL
        SELECT COUNT(*) FROM order_payments
        UNION ALL
        SELECT COUNT(*) FROM order_reviews
        UNION ALL
        SELECT COUNT(*) FROM products
        UNION ALL
        SELECT COUNT(*) FROM sellers
        UNION ALL
        SELECT COUNT(*) FROM geolocation
        UNION ALL
        SELECT COUNT(*) FROM product_category_translation
    ) t
    WHERE cnt = 0

    UNION ALL

    ---------------------------------------------------------------------------
    -- 2. Duplicate Customers
    ---------------------------------------------------------------------------
    SELECT
        'Customer Primary Key',
        COUNT(*)
    FROM (
        SELECT customer_id
        FROM customers
        GROUP BY customer_id
        HAVING COUNT(*) > 1
    ) x

    UNION ALL

    ---------------------------------------------------------------------------
    -- 3. Duplicate Orders
    ---------------------------------------------------------------------------
    SELECT
        'Order Primary Key',
        COUNT(*)
    FROM (
        SELECT order_id
        FROM orders
        GROUP BY order_id
        HAVING COUNT(*) > 1
    ) x

    UNION ALL

    ---------------------------------------------------------------------------
    -- 4. Duplicate Products
    ---------------------------------------------------------------------------
    SELECT
        'Product Primary Key',
        COUNT(*)
    FROM (
        SELECT product_id
        FROM products
        GROUP BY product_id
        HAVING COUNT(*) > 1
    ) x

    UNION ALL

    ---------------------------------------------------------------------------
    -- 5. Orders without Customers
    ---------------------------------------------------------------------------
    SELECT
        'Orders → Customers FK',
        COUNT(*)
    FROM orders o
    LEFT JOIN customers c
        ON o.customer_id = c.customer_id
    WHERE c.customer_id IS NULL

    UNION ALL

    ---------------------------------------------------------------------------
    -- 6. Order Items without Orders
    ---------------------------------------------------------------------------
    SELECT
        'Order Items → Orders FK',
        COUNT(*)
    FROM order_items oi
    LEFT JOIN orders o
        ON oi.order_id = o.order_id
    WHERE o.order_id IS NULL

    UNION ALL

    ---------------------------------------------------------------------------
    -- 7. Order Items without Products
    ---------------------------------------------------------------------------
    SELECT
        'Order Items → Products FK',
        COUNT(*)
    FROM order_items oi
    LEFT JOIN products p
        ON oi.product_id = p.product_id
    WHERE p.product_id IS NULL

    UNION ALL

    ---------------------------------------------------------------------------
    -- 8. Invalid Review Scores
    ---------------------------------------------------------------------------
    SELECT
        'Review Score Validation',
        COUNT(*)
    FROM order_reviews
    WHERE review_score NOT BETWEEN 1 AND 5

    UNION ALL

    ---------------------------------------------------------------------------
    -- 9. Negative Payment Values
    ---------------------------------------------------------------------------
        /*
    Business Rule:
    Payment values cannot be negative.

    Dataset Observation:
    The Olist dataset contains 9 records with payment_value = 0.00.
    These are valid business exceptions (voucher/not_defined payments)
    and are not considered data quality issues.
    */
    SELECT
        'Payment Value Validation',
        COUNT(*)
    FROM order_payments
    WHERE payment_value < 0

    UNION ALL

    ---------------------------------------------------------------------------
    -- 10. Negative Product Prices
    ---------------------------------------------------------------------------
    SELECT
        'Product Price Validation',
        COUNT(*)
    FROM order_items
    WHERE price <= 0

    UNION ALL

    ---------------------------------------------------------------------------
    -- 11. Negative Freight Values
    ---------------------------------------------------------------------------
    SELECT
        'Freight Validation',
        COUNT(*)
    FROM order_items
    WHERE freight_value < 0

    UNION ALL

    ---------------------------------------------------------------------------
    -- 12. Invalid Delivery Dates
    ---------------------------------------------------------------------------
    SELECT
        'Delivery Date Validation',
        COUNT(*)
    FROM orders
    WHERE order_delivered_customer_date IS NOT NULL
      AND order_delivered_customer_date < order_purchase_timestamp
)

SELECT
    validation_name,
    invalid_records,
    CASE
        WHEN invalid_records = 0 THEN 'PASS'
        ELSE 'FAIL'
    END AS status
FROM validation_results
ORDER BY validation_name;

-- SELECT *
-- FROM order_payments
-- WHERE payment_value < 0;

-- SELECT
--     op.order_id,
--     op.payment_value,
--     o.order_status
-- FROM order_payments op
-- JOIN orders o
--     ON op.order_id = o.order_id
-- WHERE op.payment_value <= 0;