/*
===============================================================================
FUNCTION: fn_top_selling_products
===============================================================================

Question:
    Create a function that accepts a product category and returns the
    top-selling products in that category based on total revenue.

Reused Pattern:
    Product revenue + DENSE_RANK() + PARTITION BY category.

Input:
    Product category.

Output:
    Top 3 products by revenue within the selected category.

===============================================================================
*/

CREATE OR REPLACE FUNCTION fn_top_selling_products(
    p_product_category VARCHAR
)
RETURNS TABLE
(
    product_id VARCHAR,
    product_category VARCHAR,
    total_revenue NUMERIC,
    product_rank BIGINT
)
LANGUAGE SQL
AS $$
    WITH product_revenue AS
    (
        SELECT
            p.product_id,
            p.product_category_name_english AS product_category,

            ROUND(
                SUM(oi.price)::numeric,
                2
            ) AS total_revenue

        FROM vw_products AS p

        INNER JOIN order_items AS oi
            ON p.product_id = oi.product_id

        WHERE
            p.product_category_name_english = p_product_category

        GROUP BY
            p.product_id,
            p.product_category_name_english
    ),

    ranked_products AS
    (
        SELECT
            product_id,
            product_category,
            total_revenue,

            DENSE_RANK() OVER(
                ORDER BY total_revenue DESC
            ) AS product_rank

        FROM product_revenue
    )

    SELECT
        product_id,
        product_category,
        total_revenue,
        product_rank

    FROM ranked_products

    WHERE product_rank <= 3

    ORDER BY product_rank;
$$;


/*
===============================================================================
TEST THE FUNCTION
===============================================================================
*/

SELECT *
FROM fn_top_selling_products(
    'beleza_saude'
);