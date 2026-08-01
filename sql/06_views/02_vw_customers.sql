/*
===============================================================================
View        : vw_customers
Description : Provides customer information along with customer location.
===============================================================================
*/

CREATE OR REPLACE VIEW vw_customers AS

SELECT
    customer_id,
    customer_unique_id,
    customer_city,
    customer_state

FROM customers;