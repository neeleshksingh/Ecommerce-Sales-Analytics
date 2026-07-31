UPDATE customers
SET customer_city = TRIM(customer_city)
WHERE customer_city <> TRIM(customer_city);


UPDATE customers
SET customer_state = TRIM(customer_state)
WHERE customer_state <> TRIM(customer_state);


UPDATE product_category_translation
SET product_category_name = TRIM(product_category_name)
WHERE product_category_name <> TRIM(product_category_name);


UPDATE product_category_translation
SET product_category_name_english = TRIM(product_category_name_english)
WHERE product_category_name_english <> TRIM(product_category_name_english);


UPDATE sellers
SET seller_city = TRIM(seller_city)
WHERE seller_city <> TRIM(seller_city);

UPDATE sellers
SET seller_state = TRIM(seller_state)
WHERE seller_state <> TRIM(seller_state);


UPDATE products
SET product_category_name = TRIM(product_category_name)
WHERE product_category_name <> TRIM(product_category_name);


UPDATE orders
SET order_status = TRIM(order_status)
WHERE order_status <> TRIM(order_status);


UPDATE geolocation
SET geolocation_city = TRIM(geolocation_city)
WHERE geolocation_city <> TRIM(geolocation_city);

UPDATE geolocation
SET geolocation_state = TRIM(geolocation_state)
WHERE geolocation_state <> TRIM(geolocation_state);

