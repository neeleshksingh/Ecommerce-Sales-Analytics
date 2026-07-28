SELECT
    'Orders -> Customers' AS relationship,
    COUNT(*) AS orphan_records
FROM orders o
LEFT JOIN customers c
       ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL

UNION ALL

SELECT
    'Order Items -> Orders',
    COUNT(*)
FROM order_items oi
LEFT JOIN orders o
       ON oi.order_id = o.order_id
WHERE o.order_id IS NULL

UNION ALL

SELECT
    'Order Items -> Products',
    COUNT(*)
FROM order_items oi
LEFT JOIN products p
       ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;