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
    total_spent DESC;/*
===============================================================================
Question    : Total Revenue by Month
Description : Provides the total number of orders and total spending for
              each customer.
===============================================================================
*/

WITH month_revenue AS
(
    SELECT
        DATE_TRUNC('month', order_purchase_timestamp) AS month,
        ROUND(SUM(oi.price)::numeric, 2) AS total_revenue
    FROM orders o
    JOIN order_items oi
        ON oi.order_id = o.order_id
    GROUP BY month
)
SELECT
    month,
    total_revenue
FROM month_revenue
ORDER BY total_revenue DESC;

/*
===============================================================================
Question    : Seller Performance Summary
Description : Calculates key sales performance metrics for each seller,
              including total orders, total items sold, total revenue,
              and average item price.
===============================================================================
*/

WITH seller_performance AS
(
    SELECT
        s.seller_id,
        s.seller_city,
        s.seller_state,
     COUNT(DISTINCT oi.order_id) AS total_orders,
        COUNT(oi.product_id) AS total_items_sold,
        ROUND(
            SUM(oi.price)::numeric,
            2
        ) AS total_revenue,
        ROUND(
            AVG(oi.price)::numeric,
            2
        ) AS average_item_price
    FROM sellers AS s
    INNER JOIN order_items AS oi
        ON oi.seller_id = s.seller_id
    GROUP BY
        s.seller_id,
        s.seller_city,
        s.seller_state
)
SELECT
    seller_id,
    seller_city,
    seller_state,
    total_orders,
    total_items_sold,
    total_revenue,
    average_item_price
FROM seller_performance
ORDER BY
    total_revenue DESC;

/*
===============================================================================
Question    : Customer RFM Preparation
Description : Calculates Recency, Frequency, and Monetary metrics for each
              customer to support customer segmentation and RFM analysis.
===============================================================================
*/

WITH customer_rfm AS
(
    SELECT
        c.customer_unique_id,
        MAX(o.order_purchase_timestamp)::date AS last_purchase_date,
        (
            CURRENT_DATE -
            MAX(o.order_purchase_timestamp)::date
        ) AS recency,
        COUNT(DISTINCT o.order_id) AS frequency,
        ROUND(
            SUM(oi.price)::numeric,
            2
        ) AS monetary
    FROM customers AS c
    INNER JOIN orders AS o
        ON o.customer_id = c.customer_id
    INNER JOIN order_items AS oi
        ON oi.order_id = o.order_id
    GROUP BY
        c.customer_unique_id
)
SELECT
    customer_unique_id,
    last_purchase_date,
    recency,
    frequency,
    monetary
FROM customer_rfm
ORDER BY
    monetary DESC;

/*
===============================================================================
Question    : Monthly Customer Growth
Description : Calculates the number of new customers acquired in each month
              based on the month of their first purchase.
===============================================================================
*/

WITH customer_first_purchase AS
(
    SELECT
        c.customer_unique_id,
        MIN(o.order_purchase_timestamp) AS first_purchase_date
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_unique_id
),
monthly_new_customers AS
(
    SELECT
        DATE_TRUNC('month', first_purchase_date) AS month,
        COUNT(customer_unique_id) AS new_customers
    FROM customer_first_purchase
    GROUP BY
        month
)
SELECT
    month,
    new_customers
FROM monthly_new_customers
ORDER BY
    month ASC;

/*
===============================================================================
Question    : Executive Sales Summary
Description : Provides an executive-level summary of key sales KPIs,
              including orders, customers, products sold, revenue,
              average order value, and average item price.
===============================================================================
*/

WITH sales_summary AS
(
    SELECT
        COUNT(DISTINCT o.order_id) AS total_orders,
        COUNT(DISTINCT c.customer_unique_id) AS total_customers,
        COUNT(oi.product_id) AS total_products_sold,
        ROUND(
            SUM(oi.price)::numeric,
            2
        ) AS total_revenue,
        ROUND(
            AVG(oi.price)::numeric,
            2
        ) AS average_item_price
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
),
executive_summary AS
(
    SELECT
        total_orders,
        total_customers,
        total_products_sold,
        total_revenue,
        ROUND(
            (total_revenue / total_orders)::numeric,
            2
        ) AS average_order_value,
        average_item_price
    FROM sales_summary
)

SELECT
    total_orders,
    total_customers,
    total_products_sold,
    total_revenue,
    average_order_value,
    average_item_price
FROM executive_summary;