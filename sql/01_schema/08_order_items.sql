/*
===============================================================================
Table        : order_items
Description  : Stores individual products within each order, including seller,
               price, freight, and shipping information.
Source File  : olist_order_items_dataset.csv
Dependencies : orders, products, sellers (Foreign key added later)
===============================================================================
*/

CREATE TABLE order_items
(
    order_id VARCHAR(50) NOT NULL,
    order_item_id INTEGER NOT NULL,
    product_id VARCHAR(50) NOT NULL,
    seller_id VARCHAR(50) NOT NULL,
    shipping_limit_date TIMESTAMP NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    freight_value DECIMAL(10,2) NOT NULL,

    CONSTRAINT pk_order_items
        PRIMARY KEY (order_id, order_item_id)
);

-- Constraints

-- Notes