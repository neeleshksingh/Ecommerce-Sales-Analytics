/*
===============================================================================
Table      : product_category_translation
Description: Stores English translations of Portuguese product category names.
===============================================================================
*/

CREATE TABLE product_category_translation (
   product_category_name VARCHAR(100) NOT NULL,
   product_category_name_english VARCHAR(100) NOT NULL,

   CONSTRAINT pk_product_category_name
   PRIMARY KEY (product_category_name)

);