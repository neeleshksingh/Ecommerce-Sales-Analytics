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

# Sellers

## Assumptions

- seller_id uniquely identifies each seller.
- A seller can fulfill multiple order items.
- Seller revenue is calculated by joining with Order Items.
- Seller location is used for logistics and regional analysis.
- Seller information is descriptive and does not contain transaction data.

# Order Payments

## Assumptions

- An order may have multiple payment transactions.
- One payment transaction belongs to only one order.
- Payment amount represents the amount paid in that payment record.
- Payment installments are applicable only for eligible payment methods.
- Revenue calculations should use the payment_value column.
- Payment information is stored separately to normalize transaction data.

## Order Reviews

- Each review is associated with one order.
- An order may or may not receive a review.
- Review scores are expected to range from 1 to 5.
- Review comments are optional.
- Review creation occurs after order delivery.
- The answer timestamp should not be earlier than the review creation date.
