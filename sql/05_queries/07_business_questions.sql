/*
===============================================================================
Question    : Highest-Revenue Product Categories
Description : Calculates total revenue, revenue contribution percentage,
              and revenue ranking for each product category.
===============================================================================
*/

WITH category_revenue AS
(
    SELECT
        p.product_category_name AS product_category,
        ROUND(
            SUM(oi.price)::numeric,
            2
        ) AS total_revenue
    FROM products AS p
    INNER JOIN order_items AS oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_category_name
),
category_analysis AS
(
    SELECT
        product_category,
        total_revenue,
        ROUND(
            (
                total_revenue /
                NULLIF(SUM(total_revenue) OVER(), 0)
            ) * 100,
            2
        ) AS revenue_percentage,
        RANK() OVER(
            ORDER BY total_revenue DESC
        ) AS revenue_ran
    FROM category_revenue
)
SELECT
    product_category,
    total_revenue,
    revenue_percentage,
    revenue_rank
FROM category_analysis
ORDER BY
    revenue_rank;


/*
===============================================================================
Question    : Best Seller Revenue & Order Performance
Description : Calculates key sales performance metrics for each seller,
              including total orders, items sold, revenue, and average
              order value.
===============================================================================
*/

SELECT
    s.seller_id,
    s.seller_state,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(oi.product_id) AS total_items_sold,
    ROUND(
        SUM(oi.price)::numeric,
        2
    ) AS total_revenue,
    ROUND(
        (
            SUM(oi.price) /
            COUNT(DISTINCT oi.order_id)
        )::numeric,
        2
    ) AS average_order_value
FROM sellers AS s
INNER JOIN order_items AS oi
    ON s.seller_id = oi.seller_id
GROUP BY
    s.seller_id,
    s.seller_state
ORDER BY
    total_revenue DESC;
