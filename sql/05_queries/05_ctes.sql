/*
===============================================================================
Question    : Customer Spending Summary
Description : Provides the total number of orders and total spending for
              each customer.
===============================================================================
*/

WITH customer_summary AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        ROUND(
            SUM(oi.price)::numeric,
            2
        ) AS total_spent
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_unique_id
)
SELECT
    customer_unique_id,
    total_orders,
    total_spent
FROM customer_summary
ORDER BY
    total_spent DESC;


/*
===============================================================================
Question    : Top Customers by State
Description : Identifies the highest-spending customer or customers within
              each customer state based on their total product spending.
===============================================================================
*/

WITH customer_spending AS
(
    SELECT
        c.customer_unique_id,
        c.customer_state,
        SUM(oi.price) AS total_spent
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_unique_id,
        c.customer_state
),
customer_rank_state_wise AS
(
    SELECT
        customer_unique_id,
        customer_state,
        total_spent,
        DENSE_RANK() OVER(
            PARTITION BY customer_state
            ORDER BY total_spent DESC
        ) AS state_rank
    FROM customer_spending
)
SELECT
    customer_unique_id,
    customer_state,
    total_spent
FROM customer_rank_state_wise
WHERE state_rank = 1;


/*
===============================================================================
Question    : Category Performance
Description : Calculates key sales performance metrics for each product
              category, including products sold, orders, revenue, and
              average selling price.
===============================================================================
*/

WITH category_performance AS
(
    SELECT
        p.product_category_name AS product_category,
        COUNT(oi.product_id) AS total_products_sold,
        COUNT(DISTINCT oi.order_id) AS total_orders,
        ROUND(
            SUM(oi.price)::numeric,
            2
        ) AS total_revenue,
        ROUND(
            AVG(oi.price)::numeric,
            2
        ) AS average_item_price
    FROM products AS p
    INNER JOIN order_items AS oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_category_name
)
SELECT
    product_category,
    total_products_sold,
    total_orders,
    total_revenue,
    average_item_price
FROM category_performance
ORDER BY
    total_revenue DESC;


/*
===============================================================================
Question    : Repeat Customers
Description : Identifies repeat customers based on their number of distinct
              orders and classifies customers as repeat or one-time customers.
===============================================================================
*/

WITH customer_orders AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_unique_id
)

SELECT
    customer_unique_id,
    total_orders,
    CASE
        WHEN total_orders >= 2
            THEN 'Repeat Customer'
        ELSE 'One-Time Customer'
    END AS customer_type
FROM customer_orders
ORDER BY
    total_orders DESC;


/*
===============================================================================
Question    : Customer Lifetime Value
Description : Calculates customer lifetime value metrics including total
              orders, total spending, and average order value for each customer.
===============================================================================
*/

WITH customer_value AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        ROUND(
            SUM(oi.price)::numeric,
            2
        ) AS total_spent
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_unique_id
),
customer_lifetime_value AS
(
    SELECT
        customer_unique_id,
        total_orders,
        total_spent,
        ROUND(
            (total_spent / total_orders)::numeric,
            2
        ) AS average_order_value
    FROM customer_value
)
SELECT
    customer_unique_id,
    total_orders,
    total_spent,
    average_order_value
FROM customer_lifetime_value
ORDER BY
    total_spent DESC;