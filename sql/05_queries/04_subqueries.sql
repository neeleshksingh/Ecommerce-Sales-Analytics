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
    order_value DESC;/*
===============================================================================
Question    : Products Priced Above Category Average
Description : Identifies products whose average selling price is higher than
              the average selling price of their respective category.
===============================================================================
*/

SELECT
    pp.product_id,
    pp.product_category,
    pp.average_product_price,
    ca.category_average_price
FROM
(
    SELECT
        p.product_id,
        p.product_category_name AS product_category,
        ROUND(AVG(oi.price), 2) AS average_product_price
    FROM products AS p
    INNER JOIN order_items AS oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_id,
        p.product_category_name
) AS pp
INNER JOIN
(
    SELECT
        p.product_category_name AS product_category,
        ROUND(AVG(oi.price), 2) AS category_average_price
    FROM products AS p
    INNER JOIN order_items AS oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_category_name
) AS ca
    ON pp.product_category = ca.product_category
WHERE
    pp.average_product_price > ca.category_average_price
ORDER BY
    pp.average_product_price DESC;


/*
===============================================================================
Question    : Sellers Earning Above Average Revenue
Description : Identifies sellers whose total revenue is greater than the
              average revenue generated across all sellers.
===============================================================================
*/

SELECT
    seller_id,
    seller_city,
    seller_state,
    total_revenue

FROM
(
    SELECT
        s.seller_id,
        s.seller_city,
        s.seller_state,
        ROUND(SUM(oi.price)::numeric, 2) AS total_revenue
    FROM sellers AS s
    INNER JOIN order_items AS oi
        ON s.seller_id = oi.seller_id
    GROUP BY
        s.seller_id,
        s.seller_city,
        s.seller_state
) AS seller_totals
WHERE
    total_revenue > (
        SELECT
            AVG(total_revenue)
        FROM
        (
            SELECT
                s.seller_id,
                SUM(oi.price) AS total_revenue
            FROM sellers AS s
            INNER JOIN order_items AS oi
                ON s.seller_id = oi.seller_id
            GROUP BY
                s.seller_id
        ) AS all_seller_totals
    )
ORDER BY
    total_revenue DESC;

    /*
===============================================================================
Question    : Customers With More Orders Than Average
Description : Identifies customers whose total number of orders is greater
              than the average number of orders placed by customers.
===============================================================================
*/

SELECT
    customer_unique_id,
    total_orders
FROM
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_unique_id
) AS customer_orders
WHERE
    total_orders > (
        SELECT
            AVG(total_orders)
        FROM
        (
            SELECT
                c.customer_unique_id,
                COUNT(DISTINCT o.order_id) AS total_orders
            FROM customers AS c
            INNER JOIN orders AS o
                ON c.customer_id = o.customer_id
            GROUP BY
                c.customer_unique_id
        ) AS all_customer_orders
    )
ORDER BY
    total_orders DESC;

    /*
===============================================================================
Question    : Most Expensive Product in Each Category
Description : Identifies the product or products with the highest average
              selling price within each product category.
===============================================================================
*/

SELECT
    product_id,
    product_category,
    average_product_price
FROM
(
    SELECT
        p.product_id,
        p.product_category_name AS product_category,
        ROUND(AVG(oi.price)::numeric, 2) AS average_product_price
    FROM products AS p
    INNER JOIN order_items AS oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_id,
        p.product_category_name
) AS product_prices
WHERE
    average_product_price = (
        SELECT
            MAX(category_product_price)
       FROM
        (
            SELECT
                p2.product_category_name,
                p2.product_id,
                AVG(oi2.price) AS category_product_price
            FROM products AS p2
            INNER JOIN order_items AS oi2
                ON p2.product_id = oi2.product_id
            WHERE
                p2.product_category_name =
                product_prices.product_category
            GROUP BY
                p2.product_category_name,
                p2.product_id
        ) AS category_products
    )
ORDER BY
    product_category,
    average_product_price DESC;


    /*
===============================================================================
Question    : Orders Containing Premium Products
Description : Identifies orders containing at least one product with a price
              greater than 500.
===============================================================================
*/

SELECT
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp
FROM orders AS o
WHERE o.order_id IN
(
    SELECT DISTINCT
        oi.order_id
    FROM order_items AS oi
    WHERE oi.price > 500
)
ORDER BY
    o.order_purchase_timestamp;


    /*
===============================================================================
Question    : Customers Who Purchased From Multiple Sellers
Description : Identifies customers who have purchased products from more than
              one distinct seller.
===============================================================================
*/

SELECT
    c.customer_unique_id,
    COUNT(DISTINCT oi.seller_id) AS distinct_sellers
FROM customers AS c
INNER JOIN orders AS o
    ON c.customer_id = o.customer_id
INNER JOIN order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_unique_id
HAVING
    COUNT(DISTINCT oi.seller_id) > 1
ORDER BY
    distinct_sellers DESC;


    /*
===============================================================================
Question    : Products Never Reviewed
Description : Identifies products that have never been associated with an
              order containing a customer review.
===============================================================================
*/

SELECT
    p.product_id,
    p.product_category_name
FROM products AS p
WHERE NOT EXISTS
(
    SELECT 1
    FROM order_items AS oi
    INNER JOIN order_reviews AS orv
        ON oi.order_id = orv.order_id
    WHERE
        oi.product_id = p.product_id
)
ORDER BY
    p.product_category_name,
    p.product_id;

    /*
===============================================================================
Question    : Top 10 Percent Customers by Spending
Description : Identifies customers whose total product spending places them
              within the top 10 percent of customers.
===============================================================================
*/

SELECT
    customer_unique_id,
    total_spent
FROM
(
    SELECT
        c.customer_unique_id,
        ROUND(SUM(oi.price)::numeric, 2) AS total_spent
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_unique_id
) AS customer_spending
WHERE
    total_spent >= (
        SELECT
            PERCENTILE_CONT(0.90)
            WITHIN GROUP (
                ORDER BY total_spent
            )
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
        ) AS all_customer_spending
    )
ORDER BY
    total_spent DESC;