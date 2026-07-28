/*
===============================================================================
File Name   : 06_data_profiling.sql
Description : Profile the Olist E-commerce dataset.
Purpose     : Understand data distribution, completeness, cardinality,
              statistics and business insights before analytics.
===============================================================================
*/

-- =============================================================================
-- 1. ROW COUNT OF EVERY TABLE
-- =============================================================================

SELECT 'customers' AS table_name, COUNT(*) AS total_rows FROM customers
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL
SELECT 'order_payments', COUNT(*) FROM order_payments
UNION ALL
SELECT 'order_reviews', COUNT(*) FROM order_reviews
UNION ALL
SELECT 'geolocation', COUNT(*) FROM geolocation
UNION ALL
SELECT 'product_category_translation', COUNT(*) FROM product_category_translation
ORDER BY table_name;


-- =============================================================================
-- 2. CUSTOMER PROFILE
-- =============================================================================

SELECT
    COUNT(*) AS total_customers,
    COUNT(DISTINCT customer_unique_id) AS unique_customers,
    COUNT(DISTINCT customer_city) AS cities,
    COUNT(DISTINCT customer_state) AS states
FROM customers;


SELECT
    customer_state,
    COUNT(*) AS customers
FROM customers
GROUP BY customer_state
ORDER BY customers DESC;


SELECT
    customer_city,
    COUNT(*) AS customers
FROM customers
GROUP BY customer_city
ORDER BY customers DESC
LIMIT 20;


-- =============================================================================
-- 3. ORDERS PROFILE
-- =============================================================================

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;


SELECT
    DATE_TRUNC('month', order_purchase_timestamp) AS purchase_month,
    COUNT(*) AS orders
FROM orders
GROUP BY purchase_month
ORDER BY purchase_month;


-- =============================================================================
-- 4. PRODUCT PROFILE
-- =============================================================================

SELECT
    COUNT(*) AS total_products,
    COUNT(product_category_name) AS categorized_products,
    COUNT(*) - COUNT(product_category_name) AS uncategorized_products
FROM products;


SELECT
    product_category_name,
    COUNT(*) AS products
FROM products
GROUP BY product_category_name
ORDER BY products DESC
LIMIT 20;


-- =============================================================================
-- 5. ORDER ITEMS PROFILE
-- =============================================================================

SELECT
    MIN(price) AS minimum_price,
    MAX(price) AS maximum_price,
    ROUND(AVG(price),2) AS average_price,
    PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY price) AS median_price
FROM order_items;


SELECT
    MIN(freight_value) AS minimum_freight,
    MAX(freight_value) AS maximum_freight,
    ROUND(AVG(freight_value),2) AS average_freight
FROM order_items;


-- =============================================================================
-- 6. PAYMENT PROFILE
-- =============================================================================

SELECT
    payment_type,
    COUNT(*) AS payments
FROM order_payments
GROUP BY payment_type
ORDER BY payments DESC;


SELECT
    payment_installments,
    COUNT(*) AS orders
FROM order_payments
GROUP BY payment_installments
ORDER BY payment_installments;


SELECT
    ROUND(AVG(payment_value),2) AS average_payment,
    MIN(payment_value) AS minimum_payment,
    MAX(payment_value) AS maximum_payment
FROM order_payments;


-- =============================================================================
-- 7. REVIEW PROFILE
-- =============================================================================

SELECT
    review_score,
    COUNT(*) AS reviews
FROM order_reviews
GROUP BY review_score
ORDER BY review_score;


SELECT
    ROUND(AVG(review_score),2) AS average_review_score
FROM order_reviews;


-- =============================================================================
-- 8. SELLER PROFILE
-- =============================================================================

SELECT
    seller_id,
    COUNT(*) AS items_sold
FROM order_items
GROUP BY seller_id
ORDER BY items_sold DESC
LIMIT 20;


-- =============================================================================
-- 9. GEOLOCATION PROFILE
-- =============================================================================

SELECT
    geolocation_state,
    COUNT(*) AS locations
FROM geolocation
GROUP BY geolocation_state
ORDER BY locations DESC;


-- =============================================================================
-- 10. OUTLIER DETECTION
-- =============================================================================

SELECT *
FROM order_items
WHERE price >
(
    SELECT AVG(price) + (3 * STDDEV(price))
    FROM order_items
);


-- =============================================================================
-- 11. DATA COMPLETENESS
-- =============================================================================

SELECT
    ROUND(
        100.0 *
        SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS missing_category_percentage
FROM products;


-- =============================================================================
-- END OF DATA PROFILING
-- =============================================================================