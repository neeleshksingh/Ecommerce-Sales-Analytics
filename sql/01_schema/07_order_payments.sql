/*
===============================================================================
Table        : order_payments
Description  : Stores payment details associated with customer orders.
Source File  : olist_order_payments_dataset.csv
Dependencies : orders (Foreign key added later)
===============================================================================
*/

CREATE TABLE order_payments
(
    order_id VARCHAR(50) NOT NULL,
    payment_sequential INTEGER NOT NULL,
    payment_type VARCHAR(50) NOT NULL,
    payment_installments INTEGER NOT NULL,
    payment_value DECIMAL(10,2) NOT NULL,

    CONSTRAINT pk_order_payments
        PRIMARY KEY (order_id, payment_sequential)
);

-- Constraints

-- Notes