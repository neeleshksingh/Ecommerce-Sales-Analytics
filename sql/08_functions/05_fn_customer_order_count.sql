/*
===============================================================================
FUNCTION: fn_customer_order_count
===============================================================================

Question:
    Create a function that accepts a customer_unique_id and returns
    the total number of distinct orders placed by that customer.

Reused Pattern:
    Customer order frequency analysis.

Input:
    customer_unique_id

Output:
    Total number of distinct orders.

===============================================================================
*/

CREATE OR REPLACE FUNCTION fn_customer_order_count(
    p_customer_unique_id VARCHAR
)
RETURNS INTEGER
LANGUAGE SQL
AS $$
    SELECT
        COUNT(DISTINCT o.order_id)::INTEGER

    FROM customers AS c

    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id

    WHERE
        c.customer_unique_id = p_customer_unique_id;
$$;


/*
===============================================================================
TEST THE FUNCTION
===============================================================================
*/

SELECT fn_customer_order_count(
    'PUT_CUSTOMER_UNIQUE_ID_HERE'
);