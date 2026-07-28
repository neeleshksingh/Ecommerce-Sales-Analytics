-- Customer Table Primary Key Validation
SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Order Table Primary Key Validation
SELECT
    order_id,
    COUNT(*)
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Product Table Primary Key Validation
SELECT
    product_id,
    COUNT(*)
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

-- Seller Table Primary Key Validation
SELECT
    seller_id,
    COUNT(*)
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;

-- Order Items Table Primary Key Validation
SELECT
    order_id,
    order_item_id,
    COUNT(*)
FROM order_items
GROUP BY
    order_id,
    order_item_id
HAVING COUNT(*) > 1;

-- Order Payments Table Primary Key Validation
SELECT
    order_id,
    payment_sequential,
    COUNT(*)
FROM order_payments
GROUP BY
    order_id,
    payment_sequential
HAVING COUNT(*) > 1;

--NULL Validation
SELECT
    COUNT(*) AS null_customer_ids
FROM customers
WHERE customer_id IS NULL;

SELECT
    COUNT(*) AS invalid_rows
FROM order_items
WHERE order_id IS NULL
   OR order_item_id IS NULL;