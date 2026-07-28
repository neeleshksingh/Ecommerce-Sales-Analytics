SELECT

COUNT(*) total_rows,

COUNT(customer_id) non_null,

COUNT(DISTINCT customer_id) unique_values,

COUNT(*)-COUNT(customer_id) null_values

FROM customers;

SELECT

MAX(LENGTH(customer_city)),
MIN(LENGTH(customer_city))

FROM customers;