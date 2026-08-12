/*
===============================================================================
Question    : Rank Customers by Spending
Description : Ranks all customers based on their total product spending,
              from the highest-spending customer to the lowest-spending customer.
===============================================================================
*/

WITH customer_spending AS
(
    SELECT
        c.customer_unique_id,
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
    total_spent,
    RANK() OVER(
        ORDER BY total_spent DESC
    ) AS customer_rank
FROM customer_spending
ORDER BY
    customer_rank ASC;


/*
===============================================================================
Question    : Top 3 Products in Each Category
Description : Identifies the three highest-revenue products within each
              product category.
===============================================================================
*/

WITH product_revenue AS
(
    SELECT
        p.product_id,
        p.product_category_name AS product_category,
        ROUND(
            SUM(oi.price)::numeric,
            2
        ) AS total_revenue
    FROM products AS p
    INNER JOIN order_items AS oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_id,
        p.product_category_name
),
product_ranking AS
(
    SELECT
        product_id,
        product_category,
        total_revenue,
        ROW_NUMBER() OVER(
            PARTITION BY product_category
            ORDER BY total_revenue DESC
        ) AS product_rank
    FROM product_revenue
)
SELECT
    product_id,
    product_category,
    total_revenue,
    product_rank
FROM product_ranking
WHERE product_rank <= 3
ORDER BY
    product_category,
    product_rank;



/*
===============================================================================
Question    : Running Customer Spending
Description : Calculates each customer's order value and cumulative spending
              across their order history.
===============================================================================
*/

WITH customer_orders AS
(
    SELECT
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp::date AS order_date,
        ROUND(
            SUM(oi.price)::numeric,
            2
        ) AS order_value
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp
)
SELECT
    customer_unique_id,
    order_id,
    order_date,
    order_value,
    ROUND(
        SUM(order_value) OVER(
            PARTITION BY customer_unique_id
            ORDER BY order_date, order_id
        )::numeric,
        2
    ) AS cumulative_spending
FROM customer_orders
ORDER BY
    customer_unique_id,
    order_date,
    order_id;


/*
===============================================================================
Question    : Next Month's Revenue
Description : Calculates monthly revenue and retrieves the revenue generated
              in the following month using the LEAD() window function.
===============================================================================
*/

WITH monthly_revenue AS
(
    SELECT
        DATE_TRUNC(
            'month',
            o.order_purchase_timestamp
        ) AS month,
        ROUND(
            SUM(oi.price)::numeric,
            2
        ) AS monthly_revenue
    FROM orders AS o
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        month
)

SELECT
    month,
    monthly_revenue,
    LEAD(monthly_revenue) OVER(
        ORDER BY month
    ) AS next_month_revenue
FROM monthly_revenue
ORDER BY
    month;


/*
===============================================================================
Question    : Revenue Contribution Percentage
Description : Calculates each product category's revenue and its percentage
              contribution to the overall company revenue.
===============================================================================
*/

WITH category_revenue AS
(
    SELECT
        p.product_category_name AS product_category,
        ROUND(
            SUM(oi.price)::numeric,
            2
        ) AS category_revenue
    FROM products AS p
    INNER JOIN order_items AS oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_category_name
)
SELECT
    product_category,
    category_revenue,
    ROUND(
        (
            category_revenue /
            NULLIF(SUM(category_revenue) OVER(), 0)
        ) * 100,
        2
    ) AS revenue_contribution_percentage
FROM category_revenue
ORDER BY
    revenue_contribution_percentage DESC;