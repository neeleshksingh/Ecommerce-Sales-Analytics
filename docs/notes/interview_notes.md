# Ecommerce Sales Analytics - Interview Notes

This document contains interview questions and explanations derived from the project. Every question is based on the database design, business understanding, and analytical decisions made during the project.

---

# Customers

## Q1. Why are both `customer_id` and `customer_unique_id` present?

**Answer**

`customer_id` uniquely identifies each customer record in the Orders dataset.

`customer_unique_id` identifies the actual customer across multiple purchases. A customer may receive different `customer_id`s in different transactions while retaining the same `customer_unique_id`.

This helps identify returning customers.

---

## Q2. Which key should be used to count unique customers?

**Answer**

Use `customer_unique_id`.

Using `customer_id` may overcount customers.

---

## Q3. Why is customer location stored?

**Answer**

Customer location helps:

- Delivery planning
- Regional sales analysis
- Customer distribution analysis
- State-wise revenue analysis
- Delivery performance analysis

---

## Q4. Which table stores customer purchase history?

**Answer**

Orders table.

Customers table only stores customer information.

---

## Q5. Is Customers a transaction table?

**Answer**

No.

It is a master (dimension) table.

---

# Orders

## Q1. What does one row represent?

**Answer**

One customer order.

---

## Q2. Why are there multiple timestamps?

**Answer**

Each timestamp represents a different stage of the order lifecycle.

- Purchase
- Approval
- Carrier Pickup
- Customer Delivery
- Estimated Delivery

This enables operational performance analysis.

---

## Q3. Which table is considered the central transaction table?

**Answer**

Orders.

Almost every business analysis starts from this table.

---

## Q4. How is delivery performance calculated?

**Answer**

Compare

`order_delivered_customer_date`

with

`order_estimated_delivery_date`

---

## Q5. Why are customer details not stored in Orders?

**Answer**

To avoid data duplication.

Customer information is normalized into the Customers table.

---

## Q6. Why is order status stored?

**Answer**

To monitor the order lifecycle.

Examples:

- Delivered
- Shipped
- Processing
- Cancelled

---

# Order Items

## Q1. What does one row represent?

**Answer**

One product within one customer order.

If an order contains three products, it will have three rows.

---

## Q2. Why does `order_id` repeat?

**Answer**

One order can contain multiple products.

This is a One-to-Many relationship.

---

## Q3. Why is the primary key composite?

**Answer**

Because `order_item_id` repeats across different orders.

Only the combination

(order_id, order_item_id)

uniquely identifies each row.

---

## Q4. Why is price stored in Order Items instead of Products?

**Answer**

Product prices change over time.

Order Items stores the historical selling price at the time of purchase.

This preserves transaction history.

---

## Q5. What happens if you count `order_id` directly in this table?

**Answer**

Orders will be overcounted because one order can have multiple products.

Always use

COUNT(DISTINCT order_id)

when counting orders.

---

## Q6. What does `freight_value` represent?

**Answer**

Shipping cost associated with that product.

It is **not** the product price.

---

## Q7. Can one seller sell multiple products?

**Answer**

Yes.

One seller can fulfill many order items.

---

## Q8. Can one product appear in multiple orders?

**Answer**

Yes.

One product can appear in many order items.

---

# Products

## Q1. Why doesn't the Products table store price?

**Answer**

Prices change over time.

Keeping the current price in Products would overwrite historical sales prices.

Order Items stores the selling price at the time of purchase.

---

## Q2. Why are product dimensions stored?

**Answer**

For:

- Logistics
- Packaging
- Warehouse planning
- Shipping cost estimation

---

## Q3. Why is product weight stored?

**Answer**

Weight directly impacts:

- Shipping charges
- Carrier selection
- Warehouse management

---

## Q4. Is Products a transaction table?

**Answer**

No.

It is a master (dimension) table.

---

## Q5. Can a product exist without being sold?

**Answer**

Yes.

Products can exist even if they never appear in Order Items.

---

## Q6. Why is `product_category_name_translation` a separate table?

**Answer**

To separate category translation from product data.

This avoids duplication and simplifies maintenance.

---

## Q7. Which table should be joined to calculate product revenue?

**Answer**

Order Items.

Revenue is stored there.

---

# Sellers

## Q1. Why doesn't the Sellers table store revenue?

**Answer**

Revenue depends on sales transactions.

It is calculated by joining with Order Items.

---

## Q2. Why are seller location columns stored?

**Answer**

Seller location supports:

- Logistics planning
- Freight calculation
- Regional seller analysis
- Marketplace expansion

---

## Q3. Can one seller sell multiple products?

**Answer**

Yes.

One seller can fulfill many order items.

---

## Q4. Can one product be sold by multiple sellers?

**Answer**

Yes.

The same product can be sold by different sellers.

---

## Q5. Which table should be joined to calculate seller revenue?

**Answer**

Order Items.

---

## Q6. Why do Customers and Sellers have similar location columns?

**Answer**

Because logistics depends on both ends.

Seller Location

↓

Customer Location

↓

Distance

↓

Freight Cost

↓

Delivery Time

Both locations are essential for e-commerce operations.

---

# Order Payments

## Q1. Why is there a separate Payments table?

Payment information is separated from Orders to normalize financial transaction data and support multiple payment transactions for a single order.

---

## Q2. Why isn't order_id the primary key?

Because one order can have multiple payment transactions.

The unique identifier is:

(order_id, payment_sequential)

---

## Q3. What does payment_sequential mean?

It represents the sequence of payment transactions for the same order.

Example:

Payment 1

↓

Payment 2

↓

Payment 3

---

## Q4. Why are installments stored?

To analyze customer payment behavior and installment usage.

---

## Q5. Can one order have multiple payment methods?

Yes.

Example:

Credit Card + Voucher

---

## Q6. Which table should be used to calculate revenue?

Revenue can be calculated using:

Order Payments.payment_value

or

Order Items.price

depending on the business requirement.

---

## Q7. Is Order Payments a master table?

No.

It is a transaction table.

---

## Q8. Why is payment information separated from Orders?

To support:

- Multiple payments
- Multiple payment methods
- Better database normalization

# Database Design

## Q1. Why is the database normalized?

**Answer**

To:

- Reduce redundancy
- Maintain data consistency
- Improve storage efficiency
- Simplify maintenance

---

## Q2. What is a One-to-Many relationship?

**Answer**

One parent record can have many child records.

Example:

Customer

↓

Many Orders

---

## Q3. What is the grain of a table?

**Answer**

The grain defines what one row represents.

Examples:

Customers → One Customer

Orders → One Order

Order Items → One Product inside One Order

Products → One Product

Sellers → One Seller

---

## Q4. Why should we identify the grain before writing SQL?

**Answer**

Understanding the grain helps prevent incorrect aggregations, duplicate counting, and improper joins.

---

## Q5. Which table would you start with when writing business queries?

**Answer**

Usually the Orders table because it acts as the central transaction table.

The starting table may vary depending on the business question.

---

## Q6. Difference between Master Tables and Transaction Tables?

**Master Tables**

Store descriptive information.

Examples:

- Customers
- Products
- Sellers

**Transaction Tables**

Store business events.

Examples:

- Orders
- Order Items

---

# Common SQL Interview Mistakes

## Mistake 1

Counting rows in Order Items to calculate total orders.

Correct:

COUNT(DISTINCT order_id)

---

## Mistake 2

Calculating revenue from Products.

Correct:

Revenue comes from Order Items.

---

## Mistake 3

Joining tables without understanding relationship cardinality.

Always understand

1:1

1:N

N:N

before writing joins.

---

## Mistake 4

Using customer_id to count unique customers.

Correct:

Use customer_unique_id.

---

## Mistake 5

Assuming Products contains inventory or stock.

It only contains descriptive metadata.
