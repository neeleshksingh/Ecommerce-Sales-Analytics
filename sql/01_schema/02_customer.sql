/*
 ===============================================================================
 Table        : customers
 Description  : Stores customer demographic and location information.
 Source File  : olist_customers_dataset.csv
 Dependencies : None
 ===============================================================================
 */
CREATE TABLE customers
(
    customer_id VARCHAR(50) NOT NULL,
    customer_unique_id VARCHAR(50) NOT NULL,
    customer_zip_code_prefix INTEGER NOT NULL,
    customer_city VARCHAR(100) NOT NULL,
    customer_state CHAR(2) NOT NULL,

    CONSTRAINT pk_customers
     PRIMARY KEY (customer_id)
);
-- Constraints
-- Notes







