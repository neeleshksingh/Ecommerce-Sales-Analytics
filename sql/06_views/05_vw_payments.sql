/*
===============================================================================
View        : vw_payments
Description : Provides payment information along with order status.
===============================================================================
*/

CREATE OR REPLACE VIEW vw_payments AS

SELECT
    o.order_id,
    op.payment_sequential,
    op.payment_type,
    op.payment_installments,
    op.payment_value,
    o.order_status

FROM order_payments AS op

INNER JOIN orders AS o
    ON op.order_id = o.order_id;