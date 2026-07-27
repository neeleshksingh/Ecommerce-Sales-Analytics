/*
===============================================================================
File        : 02_unique_constraints.sql
Description : Defines additional UNIQUE constraints for the Ecommerce Sales
              Analytics database.
Dependencies: All tables in 01_schema must exist before executing this script.
===============================================================================
*/

-- No additional UNIQUE constraints are added at this stage.
--
-- Reason:
-- Primary keys already enforce uniqueness where required.
--
-- The 'order_reviews.order_id' column may qualify for a UNIQUE constraint
-- because the business rule allows at most one review per order.
-- However, this will be validated in the data validation phase before
-- enforcing the constraint.