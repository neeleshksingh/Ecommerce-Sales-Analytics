/*
===============================================================================
File        : 03_check_constraints.sql
Description : Adds CHECK constraints to the Ecommerce Sales Analytics database.
Dependencies: All tables in 01_schema must exist before executing this script.
===============================================================================
*/

------------------------------------------------------------------------------
-- order_reviews
------------------------------------------------------------------------------

ALTER TABLE order_reviews
ADD CONSTRAINT chk_order_reviews_review_score
CHECK (review_score BETWEEN 1 AND 5);

------------------------------------------------------------------------------
-- order_payments
------------------------------------------------------------------------------

ALTER TABLE order_payments
ADD CONSTRAINT chk_order_payments_payment_value
CHECK (payment_value >= 0);

ALTER TABLE order_payments
ADD CONSTRAINT chk_order_payments_payment_installments
CHECK (payment_installments >= 1);

------------------------------------------------------------------------------
-- products
------------------------------------------------------------------------------

ALTER TABLE products
ADD CONSTRAINT chk_products_product_weight_g
CHECK (product_weight_g >= 0);

ALTER TABLE products
ADD CONSTRAINT chk_products_product_length_cm
CHECK (product_length_cm >= 0);

ALTER TABLE products
ADD CONSTRAINT chk_products_product_height_cm
CHECK (product_height_cm >= 0);

ALTER TABLE products
ADD CONSTRAINT chk_products_product_width_cm
CHECK (product_width_cm >= 0);

ALTER TABLE products
ADD CONSTRAINT chk_products_product_name_lenght
CHECK (product_name_lenght >= 0);

ALTER TABLE products
ADD CONSTRAINT chk_products_product_description_lenght
CHECK (product_description_lenght >= 0);

ALTER TABLE products
ADD CONSTRAINT chk_products_product_photos_qty
CHECK (product_photos_qty >= 0);

------------------------------------------------------------------------------
-- order_items
------------------------------------------------------------------------------

ALTER TABLE order_items
ADD CONSTRAINT chk_order_items_price
CHECK (price >= 0);

ALTER TABLE order_items
ADD CONSTRAINT chk_order_items_freight_value
CHECK (freight_value >= 0);