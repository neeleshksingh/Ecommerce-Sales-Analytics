/*
===============================================================================
File        : 01_foreign_keys.sql
Description : Adds foreign key constraints to the Ecommerce Sales Analytics database.
Dependencies: All tables in 01_schema must exist before executing this script.
===============================================================================
*/


ALTER TABLE orders
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);



ALTER TABLE products
ADD CONSTRAINT fk_products_product_category_translation
FOREIGN KEY (product_category_name)
REFERENCES product_category_translation(product_category_name);


ALTER TABLE order_reviews
ADD CONSTRAINT fk_order_reviews_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

ALTER TABLE order_payments
ADD CONSTRAINT fk_order_payments_orders
FOREIGN KEY  (order_id)
REFERENCES orders(order_id);