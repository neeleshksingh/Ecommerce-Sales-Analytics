/*
===============================================================================
Lookup Indexes
===============================================================================
*/

CREATE INDEX IF NOT EXISTS idx_orders_status
ON orders(order_status);

CREATE INDEX IF NOT EXISTS idx_orders_purchase_date
ON orders(order_purchase_timestamp);

CREATE INDEX IF NOT EXISTS idx_customers_city
ON customers(customer_city);

CREATE INDEX IF NOT EXISTS idx_customers_state
ON customers(customer_state);

CREATE INDEX IF NOT EXISTS idx_sellers_city
ON sellers(seller_city);

CREATE INDEX IF NOT EXISTS idx_sellers_state
ON sellers(seller_state);