/*
 ===============================================================================
 View        : vw_delivery
 Description : Provides delivery timeline and delivery performance metrics.
 ===============================================================================
 */
CREATE OR REPLACE VIEW vw_delivery AS
SELECT order_id,
    order_status,
    order_purchase_timestamp AS purchase_date,
    order_approved_at AS approved_date,
    order_delivered_customer_date AS delivered_date,
    order_estimated_delivery_date AS estimated_delivery_date,
    DATE_PART(
        'day',
        order_delivered_customer_date - order_approved_at
    ) AS delivery_days,
    DATE_PART(
        'day',
        order_approved_at - order_purchase_timestamp
    ) AS approval_days,
    CASE
        WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1
        ELSE 0
    END AS late_delivery_flag,
    CASE
        WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 1
        ELSE 0
    END AS on_time_delivery_flag
FROM orders;