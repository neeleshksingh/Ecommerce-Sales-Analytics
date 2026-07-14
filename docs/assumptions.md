# Project Assumptions

## Customers

- customer_id is unique.
- customer_unique_id identifies the same customer across multiple orders.

## Orders

- order_id is unique.
- customer_id exists in Customers.

## Order Items

- (order_id, order_item_id) forms a composite primary key.
- Price represents the selling price at the time of purchase.

## Payments

(To be filled later)

## Reviews

(To be filled later)