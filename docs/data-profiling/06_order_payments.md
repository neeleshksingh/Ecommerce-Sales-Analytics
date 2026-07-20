# Order Payments Table Profiling

---

## Purpose

The **Order Payments** table stores payment information for every customer order. It records the payment method, installment details, payment amount, and supports scenarios where a single order is paid using multiple payment methods. This table is essential for financial reporting, revenue analysis, and payment behavior analysis.

---

## One Row Represents

Each row represents **one payment transaction** associated with an order. A single order may contain multiple payment records.

---

## Columns

| Column               | Description                                        |
| -------------------- | -------------------------------------------------- |
| order_id             | Identifier of the order being paid.                |
| payment_sequential   | Sequence number of the payment for the same order. |
| payment_type         | Payment method used by the customer.               |
| payment_installments | Number of installments selected for the payment.   |
| payment_value        | Amount paid in this payment transaction.           |

---

## Primary Key

Composite Primary Key

- order_id
- payment_sequential

---

## Foreign Keys

| Column   | References      |
| -------- | --------------- |
| order_id | Orders.order_id |

---

## Expected Data Types

| Column               | Data Type     |
| -------------------- | ------------- |
| order_id             | VARCHAR       |
| payment_sequential   | INTEGER       |
| payment_type         | VARCHAR       |
| payment_installments | INTEGER       |
| payment_value        | DECIMAL(10,2) |

---

## Business Importance

This table records all payment transactions associated with customer orders.

It supports:

- Revenue reporting.
- Payment method analysis.
- Installment analysis.
- Financial reporting.
- Customer payment behavior analysis.

---

## Business Questions This Table Can Answer

- Which payment method is used the most?
- What is the total revenue?
- Which payment methods generate the highest revenue?
- What is the average payment amount?
- How many customers choose installment payments?
- What is the average number of installments?
- Which orders use multiple payment methods?

---

## Possible KPIs

### Revenue KPIs

- Total Revenue
- Average Order Value
- Revenue by Payment Type

### Payment KPIs

- Payment Method Distribution
- Average Installments
- Installment Usage %

### Customer KPIs

- Percentage of Credit Card Payments
- Percentage of Voucher Payments
- Percentage of Debit Card Payments

---

## Analytical Opportunities

- Revenue Analysis
- Payment Method Analysis
- Installment Analysis
- Customer Payment Behavior
- Revenue by Payment Type
- Payment Trend Analysis

---

## Data Validation Rules

- (order_id, payment_sequential) must be unique.
- payment_value must be greater than zero.
- payment_installments must be greater than zero.
- payment_type should not be NULL.
- payment_sequential should start from 1.

---

## Possible Data Quality Issues

- Duplicate payment records.
- Missing payment type.
- Missing payment amount.
- Invalid installment count.
- Negative payment values.
- Invalid payment sequence.

---

## Observations

- A single order can have multiple payment transactions.
- Multiple payment methods can be used for the same order.
- This table stores financial transaction data.
- Payment information is separated from Orders to maintain database normalization.

---

## Relationships

| Parent Table | Child Table    | Relationship |
| ------------ | -------------- | ------------ |
| Orders       | Order Payments | One-to-Many  |

---

## Future SQL Analysis

- Payment Method Analysis
- Revenue Analysis
- Installment Analysis
- Customer Payment Behavior
- Payment Trend Analysis
- Revenue by Payment Type
