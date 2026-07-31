/*
===============================================================================
File        : 02_standardize_nulls.sql
Description : Reviews NULL values that may require business decisions before
              replacement. No automatic NULL replacements are performed because
              replacing NULLs without domain knowledge can alter the meaning of
              the original dataset.
===============================================================================
*/

-- ============================================================================
-- Products
-- ============================================================================

SELECT
    COUNT(*) AS null_product_name_length
FROM products
WHERE product_name_lenght IS NULL;

SELECT
    COUNT(*) AS null_product_description_length
FROM products
WHERE product_description_lenght IS NULL;

SELECT
    COUNT(*) AS null_product_photos_qty
FROM products
WHERE product_photos_qty IS NULL;

SELECT
    COUNT(*) AS null_product_weight
FROM products
WHERE product_weight_g IS NULL;

SELECT
    COUNT(*) AS null_product_length
FROM products
WHERE product_length_cm IS NULL;

SELECT
    COUNT(*) AS null_product_height
FROM products
WHERE product_height_cm IS NULL;

SELECT
    COUNT(*) AS null_product_width
FROM products
WHERE product_width_cm IS NULL;

-- ============================================================================
-- Orders
-- ============================================================================

SELECT
    COUNT(*) AS null_delivered_customer_date
FROM orders
WHERE order_delivered_customer_date IS NULL;

SELECT
    COUNT(*) AS null_estimated_delivery_date
FROM orders
WHERE order_estimated_delivery_date IS NULL;

-- ============================================================================
-- Reviews
-- ============================================================================

SELECT
    COUNT(*) AS null_review_comment_title
FROM order_reviews
WHERE review_comment_title IS NULL;

SELECT
    COUNT(*) AS null_review_comment_message
FROM order_reviews
WHERE review_comment_message IS NULL;

SELECT 'No NULL values were automatically standardized.';