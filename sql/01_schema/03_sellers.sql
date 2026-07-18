/*
===============================================================================
Table        : sellers
Description  : Stores seller demographic and location information.
Source File  : olist_sellers_dataset.csv
Dependencies : None
===============================================================================
*/

CREATE TABLE sellers
(
    seller_id VARCHAR(50) NOT NULL,
    seller_zip_code_prefix INTEGER NOT NULL,
    seller_city VARCHAR(100) NOT NULL,
    seller_state CHAR(2) NOT NULL,

    CONSTRAINT pk_sellers
        PRIMARY KEY (seller_id)
);

-- Constraints

-- Notes