/*
===============================================================================
Question    : Customer Purchase Frequency
Description : Calculates customer order frequency using total orders,
              first and last purchase dates, customer lifetime, and average
              days between purchases.
===============================================================================
*/

WITH customer_purchase_history AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        MIN(o.order_purchase_timestamp::date) AS first_purchase_date,
        MAX(o.order_purchase_timestamp::date) AS last_purchase_date
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_unique_id
)
SELECT
    customer_unique_id,
    total_orders,
    first_purchase_date,
    last_purchase_date,
    (last_purchase_date - first_purchase_date) AS customer_lifetime_days,
    CASE
        WHEN total_orders > 1
        THEN
            ROUND((last_purchase_date - first_purchase_date)::numeric / (total_orders - 1), 2)
    END AS average_days_between_orders
FROM customer_purchase_history
ORDER BY
    total_orders DESC;

/*
===============================================================================
Question    : Customer Recency Analysis
Description : Calculates the number of days since each customer's most recent
              purchase and classifies customers based on their recency.
===============================================================================
*/

WITH customer_last_purchase AS
(
    SELECT
        c.customer_unique_id,
        MAX(o.order_purchase_timestamp::date) AS last_purchase_date
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_unique_id
),
customer_recency AS
(
    SELECT
        customer_unique_id,
        last_purchase_date,
        (CURRENT_DATE - last_purchase_date) AS recency_days
    FROM customer_last_purchase
)
SELECT
    customer_unique_id,
    last_purchase_date,
    recency_days,
    CASE
        WHEN recency_days <= 30
            THEN 'Recent Customer'
        WHEN recency_days <= 90
            THEN 'Active Customer'
        ELSE 'Inactive Customer'
    END AS customer_status
FROM customer_recency
ORDER BY
    recency_days ASC;


/*
===============================================================================
Question    : Product Price vs Category Average
Description : Identifies products whose average selling price is higher than
              the average selling price of their product category.
===============================================================================
*/

WITH product_prices AS
(
    SELECT
        p.product_id,
        p.product_category_name_english AS product_category,
        ROUND(AVG(oi.price)::numeric, 2) AS average_product_price
    FROM vw_products AS p
    INNER JOIN order_items AS oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_id,
        p.product_category_name_english
),

category_prices AS
(
    SELECT
        product_category,
        ROUND(AVG(average_product_price)::numeric, 2) AS category_average_price
    FROM product_prices
    GROUP BY
        product_category
)

SELECT
    p.product_id,
    p.product_category,
    p.average_product_price,
    c.category_average_price,
    ROUND((p.average_product_price - c.category_average_price)::numeric, 2) AS price_difference
FROM product_prices AS p
INNER JOIN category_prices AS c
    ON p.product_category = c.product_category
WHERE
    p.average_product_price > c.category_average_price
ORDER BY
    price_difference DESC;