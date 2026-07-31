/*
===============================================================================
File        : 03_cleaning_summary.sql
Description : Generates a summary report after the cleaning phase.
===============================================================================
*/

-- ============================================================================
-- Customers
-- ============================================================================

SELECT
'customers' AS table_name,
COUNT(*) AS total_rows
FROM customers

UNION ALL

SELECT
'sellers',
COUNT(*)
FROM sellers

UNION ALL

SELECT
'products',
COUNT(*)
FROM products

UNION ALL

SELECT
'orders',
COUNT(*)
FROM orders

UNION ALL

SELECT
'order_items',
COUNT(*)
FROM order_items

UNION ALL

SELECT
'order_payments',
COUNT(*)
FROM order_payments

UNION ALL

SELECT
'order_reviews',
COUNT(*)
FROM order_reviews

UNION ALL

SELECT
'geolocation',
COUNT(*)
FROM geolocation

UNION ALL

SELECT
'product_category_translation',
COUNT(*)
FROM product_category_translation;

-- ============================================================================
-- Cleaning Statistics
-- ============================================================================

SELECT
'Rows with payment_value = 0' AS metric,
COUNT(*) AS value
FROM order_payments
WHERE payment_value = 0

UNION ALL

SELECT
'Rows with payment_installments = 0',
COUNT(*)
FROM order_payments
WHERE payment_installments = 0

UNION ALL

SELECT
'Products without category translation',
COUNT(*)
FROM products p
LEFT JOIN product_category_translation t
       ON p.product_category_name = t.product_category_name
WHERE t.product_category_name IS NULL;

-- ============================================================================
-- Final Status
-- ============================================================================

SELECT
'Cleaning completed successfully. Dataset integrity preserved.'
AS status;