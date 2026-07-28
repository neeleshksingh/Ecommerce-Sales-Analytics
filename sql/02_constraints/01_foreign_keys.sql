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

/*
NOTE:
The foreign key between products.product_category_name and
product_category_translation.product_category_name is intentionally omitted.

Reason:
The Olist dataset contains category values
('pc_gamer' and 'portateis_cozinha_e_preparadores_de_alimentos')
that are not present in the translation table.

Enforcing the constraint would reject valid source data.
*/

-- ALTER TABLE products
-- ADD CONSTRAINT fk_products_product_category_translation
-- FOREIGN KEY (product_category_name)
-- REFERENCES product_category_translation(product_category_name);

ALTER TABLE order_reviews
ADD CONSTRAINT fk_order_reviews_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

ALTER TABLE order_payments
ADD CONSTRAINT fk_order_payments_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_products
FOREIGN KEY (product_id)
REFERENCES products(product_id);

ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_sellers
FOREIGN KEY (seller_id)
REFERENCES sellers(seller_id);