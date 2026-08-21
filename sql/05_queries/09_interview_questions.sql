WITH CTE AS (
    SELECT 
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        ROUND(SUM(oi.price)::numeric, 2) AS total_spent
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id
),

ranked_customers AS (
    SELECT
        customer_unique_id,
        total_orders,
        total_spent,
        DENSE_RANK() OVER(ORDER BY total_spent DESC) AS customer_rank
    FROM CTE
)

SELECT
    customer_unique_id,
    total_orders,
    total_spent,
    customer_rank
FROM ranked_customers
WHERE customer_rank <= 10
ORDER BY customer_rank;