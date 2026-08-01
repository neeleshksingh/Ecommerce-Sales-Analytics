/*
===============================================================================
Composite Indexes
===============================================================================
*/

CREATE INDEX IF NOT EXISTS idx_customer_city_state
ON customers(customer_city, customer_state);

CREATE INDEX IF NOT EXISTS idx_seller_city_state
ON sellers(seller_city, seller_state);

CREATE INDEX IF NOT EXISTS idx_orders_status_purchase
ON orders(order_status, order_purchase_timestamp);

CREATE INDEX IF NOT EXISTS idx_order_items_order_product
ON order_items(order_id, product_id);