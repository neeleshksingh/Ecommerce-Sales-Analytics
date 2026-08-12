/*
===============================================================================
Question    : Top 10 Customers by Revenue
Description : Identifies the ten highest-spending customers based on their
              total product spending and number of orders.
===============================================================================
*/

WITH customer_revenue AS
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
customer_ranking AS
(
    SELECT
        customer_unique_id,
        total_orders,
        total_spent,
        ROW_NUMBER() OVER(
            ORDER BY total_spent DESC
        ) AS customer_rank
    FROM customer_revenue
)
SELECT
    customer_unique_id,
    total_orders,
    total_spent,
    customer_rank
FROM customer_ranking
WHERE customer_rank <= 10
ORDER BY
    customer_rank;


/*
===============================================================================
Question    : Highest Customer Spending by State
Description : Identifies the highest-spending customer within each customer
              state based on their total product spending.
===============================================================================
*/

WITH customer_spending AS
(
    SELECT
        c.customer_state,
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
        c.customer_state,
        c.customer_unique_id
),

state_customer_ranking AS
(
    SELECT
        customer_state,
        customer_unique_id,
        total_spent,
        RANK() OVER(
            PARTITION BY customer_state
            ORDER BY total_spent DESC
        ) AS state_rank
    FROM customer_spending
)
SELECT
    customer_state,
    customer_unique_id,
    total_spent,
    state_rank
FROM state_customer_ranking
WHERE state_rank = 1
ORDER BY
    customer_state;