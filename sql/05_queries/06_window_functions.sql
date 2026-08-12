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
    revenue_contribution_percentage DESC;/*
===============================================================================
Question    : Rank Sellers by Revenue Within State
Description : Ranks sellers by total revenue within their respective seller
              state, with the highest-revenue seller receiving rank 1.
===============================================================================
*/

WITH seller_revenue AS
(
    SELECT
        s.seller_id,
        s.seller_state,
        ROUND(
            SUM(oi.price)::numeric,
            2
        ) AS total_revenue
    FROM sellers AS s
    INNER JOIN order_items AS oi
        ON oi.seller_id = s.seller_id
    GROUP BY
        s.seller_id,
        s.seller_state
)
SELECT
    seller_id,
    seller_state,
    total_revenue,
    RANK() OVER(
        PARTITION BY seller_state
        ORDER BY total_revenue DESC
    ) AS state_rank
FROM seller_revenue
ORDER BY
    seller_state,
    state_rank;


/*
===============================================================================
Question    : Running Monthly Revenue
Description : Calculates monthly revenue and the cumulative revenue generated
              over time.
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
        ON oi.order_id = o.order_id
    GROUP BY
        month
)
SELECT
    month,
    monthly_revenue,
    ROUND(
        SUM(monthly_revenue) OVER(
            ORDER BY month
        )::numeric,
        2
    ) AS cumulative_revenue
FROM monthly_revenue
ORDER BY
    month;



/*
===============================================================================
Question    : Previous Month's Revenue
Description : Calculates monthly revenue and retrieves the revenue generated
              in the previous month using the LAG() window function.
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
        ON oi.order_id = o.order_id
    GROUP BY
        month
)
SELECT
    month,
    monthly_revenue,
    LAG(monthly_revenue) OVER(
        ORDER BY month
    ) AS previous_month_revenue
FROM monthly_revenue
ORDER BY
    month;




/*
===============================================================================
Question    : Month-over-Month Revenue Growth
Description : Calculates monthly revenue, previous month revenue, revenue
              change, and month-over-month revenue growth percentage.
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
),
revenue_comparison AS
(
    SELECT
        month,
        monthly_revenue,
        LAG(monthly_revenue) OVER(
            ORDER BY month
        ) AS previous_month_revenue
    FROM monthly_revenue
)
SELECT
    month,
    monthly_revenue,
    previous_month_revenue,
    ROUND(
        (
            monthly_revenue -
            previous_month_revenue
        )::numeric,
        2
    ) AS revenue_change,
    ROUND(
        (
            (
                monthly_revenue -
                previous_month_revenue
            )
            / NULLIF(previous_month_revenue, 0)
        ) * 100,
        2
    ) AS revenue_growth_percentage
FROM revenue_comparison
ORDER BY
    month;



/*
===============================================================================
Question    : Customer Spending Quartiles
Description : Divides customers into four spending groups based on their
              total product spending using the NTILE() window function.
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
    NTILE(4) OVER(
        ORDER BY total_spent
    ) AS spending_quartile
FROM customer_spending
ORDER BY
    spending_quartile,
    total_spent;