/*
===============================================================================
View        : vw_products
Description : Provides product information along with English category names.
===============================================================================
*/

CREATE OR REPLACE VIEW vw_products AS

SELECT
    p.product_id,
    p.product_category_name,
    pct.product_category_name_english,
    p.product_name_lenght,
    p.product_description_lenght,
    p.product_photos_qty,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm

FROM products AS p

LEFT JOIN product_category_translation AS pct
    ON p.product_category_name = pct.product_category_name;