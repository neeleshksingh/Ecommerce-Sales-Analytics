/*
===============================================================================
FUNCTION: fn_customer_lifetime_value
===============================================================================

Question:
    Create a function that accepts a customer_unique_id and returns
    the customer's total lifetime spending.

Reused Pattern:
    Customer lifetime value / customer spending analysis.

Input:
    customer_unique_id

Output:
    Total amount spent by the customer.

===============================================================================
*/

CREATE OR REPLACE FUNCTION fn_customer_lifetime_value(
    p_customer_unique_id VARCHAR
)
RETURNS NUMERIC
LANGUAGE SQL
AS $$
    SELECT
        COALESCE(
            ROUND(SUM(oi.price)::numeric, 2),
            0
        )
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    WHERE c.customer_unique_id = p_customer_unique_id;
$$;


/*
===============================================================================
TEST THE FUNCTION
===============================================================================
*/

SELECT fn_customer_lifetime_value(
    '861eff4711a542e4b93843c6dd7febb0'
);