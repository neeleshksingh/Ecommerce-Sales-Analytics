/*
===============================================================================
Question    : Customers Who Spent Above Average
Description : Identifies customers whose total spending is greater than the
              average spending across all customers.
===============================================================================
*/

SELECT
    customer_unique_id,
    customer_city,
    customer_state,
    total_spent
FROM
(
    SELECT
        c.customer_unique_id,
        c.customer_city,
        c.customer_state,
        SUM(oi.price) AS total_spent
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_unique_id,
        c.customer_city,
        c.customer_state
) AS customer_totals
WHERE total_spent > (
    SELECT
        AVG(total_spent)
    FROM
    (
        SELECT
            c.customer_unique_id,
            SUM(oi.price) AS total_spent
        FROM customers AS c
        INNER JOIN orders AS o
            ON c.customer_id = o.customer_id
        INNER JOIN order_items AS oi
            ON o.order_id = oi.order_id
        GROUP BY
            c.customer_unique_id
    ) AS average_customer_totals
)
ORDER BY
    total_spent DESC;


/*
===============================================================================
Question    : Orders with the Highest Value
Description : Identifies the order or orders with the highest total product
              value.
===============================================================================
*/

SELECT
    order_id,
    order_value
FROM
(
    SELECT
        o.order_id,
        SUM(oi.price) AS order_value
    FROM orders AS o
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        o.order_id
) AS order_totals
WHERE
    order_value = (
        SELECT
            MAX(order_value)
        FROM
        (
            SELECT
                o.order_id,
                SUM(oi.price) AS order_value
            FROM orders AS o
            INNER JOIN order_items AS oi
                ON o.order_id = oi.order_id
            GROUP BY
                o.order_id
        ) AS all_order_totals
    )
ORDER BY
    order_value DESC;