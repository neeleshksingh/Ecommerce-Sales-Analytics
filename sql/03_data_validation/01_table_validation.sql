/*
===============================================================================
Validation File : 01_table_validation.sql
Purpose         : Validate successful table creation and data loading.
Author          : Neelesh Singh
===============================================================================
*/

-- ============================================================================
-- Validation 1 : Verify all expected tables exist
-- ============================================================================

SELECT
    table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

-- ============================================================================
-- Validation 2 : Verify row counts
-- ============================================================================

SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL
SELECT 'geolocation', COUNT(*) FROM geolocation
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'order_payments', COUNT(*) FROM order_payments
UNION ALL
SELECT 'order_reviews', COUNT(*) FROM order_reviews
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'product_category_translation', COUNT(*) FROM product_category_translation
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers
ORDER BY table_name;

-- ============================================================================
-- Validation 3 : Compare expected vs actual row counts
-- ============================================================================

-- Query...

-- ============================================================================
-- Validation 4 : Check for empty tables
-- ============================================================================

WITH table_counts AS
(
    SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
    UNION ALL
    SELECT 'orders', COUNT(*) FROM orders
    UNION ALL
    SELECT 'products', COUNT(*) FROM products
    UNION ALL
    SELECT 'sellers', COUNT(*) FROM sellers
    UNION ALL
    SELECT 'order_items', COUNT(*) FROM order_items
    UNION ALL
    SELECT 'order_payments', COUNT(*) FROM order_payments
    UNION ALL
    SELECT 'order_reviews', COUNT(*) FROM order_reviews
    UNION ALL
    SELECT 'geolocation', COUNT(*) FROM geolocation
    UNION ALL
    SELECT 'product_category_translation', COUNT(*) FROM product_category_translation
)

SELECT *
FROM table_counts
WHERE row_count = 0;