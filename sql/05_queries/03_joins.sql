/*
===============================================================================
Question    : Customers with No Orders
Description : Retrieves customers who have never placed an order by using a
              LEFT JOIN between customers and orders.
===============================================================================
*/

SELECT
    c.customer_id,
    c.customer_unique_id,
    c.customer_city,
    c.customer_state
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id
WHERE
    o.order_id IS NULL;

/*
===============================================================================
Question    : Sellers with Total Revenue
Description : Retrieves sellers with their total revenue by using a
              LEFT JOIN between sellers and orders.
===============================================================================
*/

SELECT
    s.seller_id,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM sellers AS s
INNER JOIN order_items AS oi
    ON s.seller_id = oi.seller_id
GROUP BY
    s.seller_id
ORDER BY
    total_revenue DESC;

/*
===============================================================================
Question    : Orders with Payment Details
Description : Retrieves each order along with its payment information,
              including payment type, installments, and payment value.
===============================================================================
*/

SELECT
    o.order_id,
    o.order_status,
    op.payment_type,
    op.payment_installments,
    op.payment_value
FROM orders AS o
INNER JOIN order_payments AS op
    ON o.order_id = op.order_id;

/*
===============================================================================
Question    : Top Customers by Spending
Description : Calculates the total amount spent by each customer and displays
              the highest spending customers.
===============================================================================
*/

SELECT
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    ROUND(SUM(oi.price),2) AS total_spent
FROM customers AS c
INNER JOIN orders AS o
    ON c.customer_id = o.customer_id
INNER JOIN order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_unique_id,
    c.customer_city,
    c.customer_state
ORDER BY
    total_spent DESC;

/*
===============================================================================
Question    : Customer Purchase Summary
Description : Provides a purchase summary for each customer, including total
              orders, total spending, and average order value.
===============================================================================
*/

SELECT
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_spent,
    ROUND(
        SUM(oi.price) /
        COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM customers AS c
INNER JOIN orders AS o
    ON c.customer_id = o.customer_id
INNER JOIN order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_unique_id,
    c.customer_city,
    c.customer_state
ORDER BY
    total_spent DESC;