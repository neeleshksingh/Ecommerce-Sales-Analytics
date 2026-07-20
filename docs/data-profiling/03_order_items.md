# Order Items Table Profiling

## Purpose

The _Order Items_ table stores detailed information about every product included in a customer order. It records the purchased product, seller, selling price, freight cost, and shipping deadline. This table is essential for product-level, seller-level, revenue, and shipping analysis.

---

## One Row Represents

Each row represents _one product within one customer order_. If an order contains multiple products, each product is stored as a separate row.

---

## Columns

| Column              | Description                                                                  |
| ------------------- | ---------------------------------------------------------------------------- |
| order_id            | References the customer order.                                               |
| order_item_id       | Sequential number of the item within an order.                               |
| product_id          | Purchased product identifier.                                                |
| seller_id           | Seller who fulfilled the product.                                            |
| shipping_limit_date | Deadline by which the seller must hand the product to the logistics carrier. |
| price               | Selling price of the product at the time of purchase.                        |
| freight_value       | Shipping charge associated with the product.                                 |

---

## Primary Key

Composite Primary Key

(order_id, order_item_id)

---

## Foreign Keys

| Column     | References          |
| ---------- | ------------------- |
| order_id   | Orders.order_id     |
| product_id | Products.product_id |
| seller_id  | Sellers.seller_id   |

---

## Expected Data Types

| Column              | Data Type     |
| ------------------- | ------------- |
| order_id            | VARCHAR       |
| order_item_id       | INTEGER       |
| product_id          | VARCHAR       |
| seller_id           | VARCHAR       |
| shipping_limit_date | TIMESTAMP     |
| price               | DECIMAL(10,2) |
| freight_value       | DECIMAL(10,2) |

---

## Business Importance

This table enables detailed product-level analysis. It supports revenue calculation, seller performance evaluation, shipping cost analysis, product demand analysis, and basket size analysis.

---

## Business Questions This Table Can Answer

- Which products generate the highest revenue?
- Which sellers sell the most products?
- What is the average product price?
- What is the average freight cost?
- Which products have the highest shipping cost?
- Which sellers generate the highest revenue?
- Which products are most frequently purchased?
- What is the average number of products per order?

---

## Possible KPIs

### Sales KPIs

- Total Revenue
- Average Product Price
- Revenue per Product
- Revenue per Seller

### Product KPIs

- Best Selling Products
- Most Ordered Products
- Average Basket Size

### Seller KPIs

- Seller Revenue
- Products Sold per Seller
- Average Selling Price

### Shipping KPIs

- Average Freight Cost
- Freight Cost by Seller
- Freight Cost by Product

---

## Analytical Opportunities

- Product Performance Analysis
- Seller Performance Analysis
- Revenue Analysis
- Shipping Cost Analysis
- Basket Size Analysis
- Product Mix Analysis
- Revenue Contribution Analysis

---

## Data Validation Rules

- (order_id, order_item_id) must be unique.
- order_id must exist in Orders.
- product_id must exist in Products.
- seller_id must exist in Sellers.
- Price must be greater than zero.
- Freight value cannot be negative.
- Shipping limit date should not be NULL.

---

## Possible Data Quality Issues

- Duplicate composite keys.
- Missing product IDs.
- Missing seller IDs.
- Missing shipping dates.
- Negative prices.
- Negative freight values.
- Invalid foreign keys.

---

## Observations

- One order can contain multiple products.
- The same product can appear in many different orders.
- The same seller can sell multiple products.
- Revenue is stored at the product level.
- Historical product prices are preserved by storing the selling price in this table.

---

## Relationships

Orders
│
▼
Order Items
├──► Products
└──► Sellers

---

## Future SQL Analysis

- Revenue Analysis
- Product Performance
- Seller Performance
- Shipping Cost Analysis
- Basket Size Analysis
- Product Ranking
- Revenue Contribution
