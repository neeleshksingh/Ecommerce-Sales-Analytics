/*
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