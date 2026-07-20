# Orders Table Profiling

## Purpose

The **Orders** table is the central transactional table of the e-commerce database. It stores the complete lifecycle of every customer order, including its current status and important timestamps from purchase to delivery. This table acts as the primary link between customers, order items, payments, reviews, and other business entities.

---

## One Row Represents

Each row represents **one unique customer order** and tracks its complete journey from the time it is placed until it is delivered or cancelled.

---

## Columns

| Column                        | Description                                                                    |
| ----------------------------- | ------------------------------------------------------------------------------ |
| order_id                      | Unique identifier for each order.                                              |
| customer_id                   | Customer who placed the order. References the Customers table.                 |
| order_status                  | Current status of the order (Delivered, Shipped, Processing, Cancelled, etc.). |
| order_purchase_timestamp      | Date and time when the customer placed the order.                              |
| order_approved_at             | Date and time when the order/payment was approved.                             |
| order_delivered_carrier_date  | Date and time when the seller handed the package to the logistics carrier.     |
| order_delivered_customer_date | Date and time when the customer received the order.                            |
| order_estimated_delivery_date | Estimated delivery date promised to the customer.                              |

---

## Primary Key

`order_id`

---

## Foreign Keys

| Column      | References            |
| ----------- | --------------------- |
| customer_id | Customers.customer_id |

---

## Expected Data Types

| Column                        | Data Type |
| ----------------------------- | --------- |
| order_id                      | VARCHAR   |
| customer_id                   | VARCHAR   |
| order_status                  | VARCHAR   |
| order_purchase_timestamp      | TIMESTAMP |
| order_approved_at             | TIMESTAMP |
| order_delivered_carrier_date  | TIMESTAMP |
| order_delivered_customer_date | TIMESTAMP |
| order_estimated_delivery_date | TIMESTAMP |

---

## Business Importance

This is one of the most important tables in the database because it records every customer order and its complete lifecycle.

It is used to:

- Track order volume over time.
- Monitor order statuses.
- Measure operational performance.
- Analyze delivery efficiency.
- Calculate order processing time.
- Measure customer purchasing trends.
- Support sales reporting.
- Evaluate business growth over time.

---

## Business Questions This Table Can Answer

- How many orders are placed daily, monthly, and yearly?
- What percentage of orders are successfully delivered?
- What is the cancellation rate?
- How long does it take to approve an order?
- What is the average delivery time?
- Which months have the highest order volume?
- Which days receive the highest number of orders?
- How many orders are currently in processing?
- How many orders are delivered before the estimated delivery date?
- How many orders are delayed?

---

## Possible KPIs

### Sales KPIs

- Total Orders
- Daily Orders
- Monthly Orders
- Quarterly Orders
- Yearly Orders

### Operational KPIs

- Delivered Orders
- Cancelled Orders
- Pending Orders
- Approval Rate
- Delivery Success Rate

### Delivery KPIs

- Average Delivery Time
- Average Approval Time
- On-Time Delivery Rate
- Delayed Delivery Rate
- Early Delivery Rate

### Customer KPIs

- Active Customers (via Orders)
- Average Orders per Customer
- Returning Customers (after joining with Customers)

---

## Data Validation Rules

- `order_id` must be unique.
- `customer_id` must exist in the Customers table.
- `order_purchase_timestamp` should never be NULL.
- `order_approved_at` should not be earlier than `order_purchase_timestamp`.
- `order_delivered_carrier_date` should not be earlier than `order_approved_at`.
- `order_delivered_customer_date` should not be earlier than `order_delivered_carrier_date`.
- `order_estimated_delivery_date` should not be earlier than `order_purchase_timestamp`.
- Delivered orders must have a delivery timestamp.
- Cancelled orders should not have a customer delivery timestamp.
- Orders with status "Delivered" should have `order_delivered_customer_date` populated.

---

## Possible Data Quality Issues

- Duplicate `order_id` values.
- Missing `customer_id`.
- Missing purchase timestamps.
- Missing approval timestamps for approved orders.
- Missing delivery timestamps for delivered orders.
- Invalid order status values.
- Incorrect timestamp sequence.
- Future timestamps (if present).
- Orders marked as delivered but without delivery dates.
- Cancelled orders containing delivery timestamps.

---

## Observations

- This table contains **one row per order**, not one row per product.
- Product information is **not** stored in this table.
- Seller information is **not** stored in this table.
- Payment details are stored separately in the Payments table.
- Review information is stored separately in the Reviews table.
- Multiple timestamps allow separate analysis of purchase, approval, shipping, and delivery durations.
- Delivery performance can be measured by comparing the actual delivery date with the estimated delivery date.
- This table acts as the **central hub** of the entire e-commerce database and connects with multiple tables during analysis.

---

## Relationships

```
Customers
      │
      │ customer_id
      ▼
Orders
      │
      ├────────► Order Items
      ├────────► Payments
      ├────────► Reviews
      └────────► Sellers (through Order Items)
```

---

## Future SQL Analysis

This table will be used to perform analyses such as:

- Monthly Sales Trend
- Daily Order Trend
- Order Status Distribution
- Cancellation Analysis
- Delivery Performance Analysis
- Order Processing Time
- Delivery Delay Analysis
- Customer Purchase Frequency
- Seasonal Order Analysis
- Peak Ordering Hours
