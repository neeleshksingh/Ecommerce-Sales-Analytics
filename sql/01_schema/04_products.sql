/*
===============================================================================
Table        : products
Description  : Stores product metadata and physical attributes.
Source File  : olist_products_dataset.csv
Dependencies : None (Foreign key added later)
===============================================================================
*/

CREATE TABLE products
(
    product_id VARCHAR(50) NOT NULL,
    product_category_name VARCHAR(100),
    product_name_lenght INTEGER,
    product_description_lenght INTEGER,
    product_photos_qty INTEGER,
    product_weight_g INTEGER,
    product_length_cm INTEGER,
    product_height_cm INTEGER,
    product_width_cm INTEGER,

    CONSTRAINT pk_products
        PRIMARY KEY (product_id)
);

-- Constraints

-- Notes