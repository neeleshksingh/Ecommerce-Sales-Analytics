/*
===============================================================================
Table        : orders
Description  : Stores order lifecycle information, including purchase,
               approval, shipping, and delivery timestamps.
Source File  : olist_orders_dataset.csv
Dependencies : customers (Foreign key added later)
===============================================================================
*/

CREATE TABLE orders
(
    order_id VARCHAR(50) NOT NULL,
    customer_id VARCHAR(50) NOT NULL,
    order_status VARCHAR(20) NOT NULL,
    order_purchase_timestamp TIMESTAMP NOT NULL,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP NOT NULL,

    CONSTRAINT pk_orders
        PRIMARY KEY (order_id)
);

-- Constraints

-- Notes