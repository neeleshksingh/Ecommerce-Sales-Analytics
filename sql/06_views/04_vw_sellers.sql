/*
===============================================================================
View        : vw_sellers
Description : Provides seller information along with location details.
===============================================================================
*/

CREATE OR REPLACE VIEW vw_sellers AS

SELECT
    s.seller_id,
    s.seller_city,
    s.seller_state,
    CONCAT(s.seller_city, ', ', s.seller_state) AS seller_location

FROM sellers AS s;