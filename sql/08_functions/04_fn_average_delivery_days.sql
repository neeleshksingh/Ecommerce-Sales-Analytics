/*
===============================================================================
FUNCTION: fn_average_delivery_days
===============================================================================

Question:
    Create a function that accepts a customer state and returns the
    average number of days taken to deliver orders in that state.

Reused Pattern:
    Delivery analysis using:

        delivered_date - approved_date

Input:
    Customer state.

Output:
    Average delivery time in days.

===============================================================================
*/

CREATE OR REPLACE FUNCTION fn_average_delivery_days(
    p_customer_state VARCHAR
)
RETURNS NUMERIC
LANGUAGE SQL
AS $$
    SELECT
        COALESCE(
            ROUND(
                AVG(
                    o.order_delivered_customer_date::date
                    -
                    o.order_approved_at::date
                )::numeric,
                2
            ),
            0
        )

    FROM customers AS c

    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id

    WHERE
        c.customer_state = p_customer_state

        AND o.order_delivered_customer_date IS NOT NULL

        AND o.order_approved_at IS NOT NULL;
$$;


/*
===============================================================================
TEST THE FUNCTION
===============================================================================
*/

SELECT fn_average_delivery_days('SP');