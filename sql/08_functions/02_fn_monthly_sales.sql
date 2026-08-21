/*
===============================================================================
FUNCTION: fn_monthly_sales
===============================================================================

Question:
    Create a function that accepts a month and returns the total sales
    revenue for that month.

Reused Pattern:
    Monthly revenue analysis.

Input:
    A date representing the month.

Output:
    Total revenue for that month.

===============================================================================
*/

CREATE OR REPLACE FUNCTION fn_monthly_sales(
    p_month DATE
)
RETURNS NUMERIC
LANGUAGE SQL
AS $$
    SELECT
        COALESCE(
            ROUND(SUM(oi.price)::numeric, 2),
            0
        )
    FROM orders AS o
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    WHERE
        o.order_purchase_timestamp >= DATE_TRUNC('month', p_month)
        AND
        o.order_purchase_timestamp < DATE_TRUNC('month', p_month)
            + INTERVAL '1 month';
$$;


/*
===============================================================================
TEST THE FUNCTION
===============================================================================
*/

SELECT fn_monthly_sales('2018-01-01');