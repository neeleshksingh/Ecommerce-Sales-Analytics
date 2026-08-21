/*
===============================================================================
PROCEDURE: sp_refresh_monthly_sales_report
===============================================================================

Question:
    Create a procedure that refreshes a monthly sales report containing:

    - Monthly revenue
    - Previous month revenue
    - Revenue change
    - Revenue growth percentage

Reused Analysis:
    Monthly revenue + LAG() + Month-over-Month growth analysis.

===============================================================================
*/


/*
===============================================================================
STEP 1 — CREATE REPORT TABLE
===============================================================================
*/

CREATE TABLE IF NOT EXISTS monthly_sales_report
(
    month DATE,
    monthly_revenue NUMERIC(15, 2),
    previous_month_revenue NUMERIC(15, 2),
    revenue_change NUMERIC(15, 2),
    revenue_growth_percentage NUMERIC(10, 2),
    refreshed_at TIMESTAMP
);


/*
===============================================================================
STEP 2 — CREATE PROCEDURE
===============================================================================
*/

CREATE OR REPLACE PROCEDURE sp_refresh_monthly_sales_report()
LANGUAGE SQL
AS $$
    
    /*
    Remove the previous report.
    */

    TRUNCATE TABLE monthly_sales_report;


    /*
    Recalculate monthly revenue and
    month-over-month performance.
    */

    INSERT INTO monthly_sales_report
    (
        month,
        monthly_revenue,
        previous_month_revenue,
        revenue_change,
        revenue_growth_percentage,
        refreshed_at
    )

    WITH monthly_revenue AS
    (
        SELECT
            DATE_TRUNC(
                'month',
                o.order_purchase_timestamp
            )::date AS month,

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

    monthly_comparison AS
    (
        SELECT
            month,
            monthly_revenue,

            LAG(monthly_revenue)
                OVER (
                    ORDER BY month
                ) AS previous_month_revenue

        FROM monthly_revenue
    )

    SELECT
        month,

        monthly_revenue,

        ROUND(
            previous_month_revenue::numeric,
            2
        ) AS previous_month_revenue,

        ROUND(
            (
                monthly_revenue
                -
                previous_month_revenue
            )::numeric,
            2
        ) AS revenue_change,

        ROUND(
            (
                (
                    monthly_revenue
                    -
                    previous_month_revenue
                )
                /
                NULLIF(previous_month_revenue, 0)
            ) * 100
        ::numeric, 2) AS revenue_growth_percentage,

        CURRENT_TIMESTAMP

    FROM monthly_comparison

    WHERE previous_month_revenue IS NOT NULL;

$$;


/*
===============================================================================
STEP 3 — EXECUTE PROCEDURE
===============================================================================
*/

CALL sp_refresh_monthly_sales_report();


/*
===============================================================================
STEP 4 — CHECK RESULT
===============================================================================
*/

SELECT *
FROM monthly_sales_report
ORDER BY month;