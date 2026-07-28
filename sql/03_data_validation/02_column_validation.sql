/*
===============================================================================
Validation File : 02_column_validation.sql
Purpose         : Validate column-level completeness and quality.
===============================================================================
*/

-- ============================================================================
-- Customers
-- ============================================================================

-- customer_id
SELECT
    COUNT(*) AS total_rows,
    COUNT(customer_id) AS non_null_values,
    COUNT(*) - COUNT(customer_id) AS null_values,
    COUNT(DISTINCT customer_id) AS distinct_values,
    COUNT(*) - COUNT(DISTINCT customer_id) AS duplicate_values
FROM customers;

-- customer_unique_id
SELECT
COUNT(*) total_rows,
COUNT(customer_unique_id),
COUNT(*)-COUNT(customer_unique_id) null_values,
COUNT(DISTINCT customer_unique_id)
FROM customers;

-- customer_city
SELECT
COUNT(*) total_rows,
COUNT(customer_city),
COUNT(*)-COUNT(customer_city) null_values,
COUNT(
CASE
WHEN TRIM(customer_city)=''
THEN 1
END
) empty_strings,
COUNT(DISTINCT customer_city) distinct_cities,
MIN(LENGTH(customer_city)) shortest_city_name,
MAX(LENGTH(customer_city)) longest_city_name
FROM customers;

-- customer_state
SELECT
COUNT(DISTINCT customer_state)
FROM customers;

-- ============================================================================
-- Orders
-- ============================================================================

-- order_id
SELECT
    COUNT(*) AS total_rows,
    COUNT(order_id) AS non_null_values,
    COUNT(*) - COUNT(order_id) AS null_values,
    COUNT(DISTINCT order_id) AS distinct_values,
    COUNT(*) - COUNT(DISTINCT order_id) AS duplicate_values
FROM orders;

-- customer_id
SELECT
    COUNT(*) AS total_rows,
    COUNT(customer_id) AS non_null_values,
    COUNT(*) - COUNT(customer_id) AS null_values,
    COUNT(DISTINCT customer_id) AS distinct_values,
    COUNT(*) - COUNT(DISTINCT customer_id) AS duplicate_values
FROM orders;

-- order_status
SELECT
order_status,
COUNT(*)
FROM orders
GROUP BY order_status
ORDER BY COUNT(*) DESC;