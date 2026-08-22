# Database Relationships

> **Audit note (2026-08-21):** these are conceptual discovery notes. The authoritative implemented relationships and exceptions are in [`../data_model.md`](../data_model.md) and [`../constraints.md`](../constraints.md).

| Parent Table | Child Table    | Relationship      |
| ------------ | -------------- | ----------------- |
| Customers    | Orders         | One-to-Many (1:N) |
| Orders       | Order Items    | One-to-Many (1:N) |
| Orders       | Order Payments | One-to-Many (1:N) |
| Products     | Order Items    | One-to-Many (1:N) |
| Sellers      | Order Items    | One-to-Many (1:N) |

---

## Relationship Summary

- One customer can place multiple orders.
- One order can contain multiple order items.
- One order can have multiple payment transactions.
- One product can appear in multiple order items.
- One seller can fulfill multiple order items.

## Orders ↔ Order Reviews

### Relationship

Orders (1) → Order Reviews (0..1)

### Why?

- An order can have zero or one review.
- Customers submit reviews after receiving an order.
- Some completed orders may never receive a review.

### Foreign Key

OrderReviews.order_id → Orders.order_id

### Business Meaning

This relationship enables customer satisfaction analysis by connecting order information with customer feedback.

### Future Analysis

- Average review score
- Review score by seller
- Review score by product category
- Review score by delivery performance
- Positive vs negative reviews

## Product Category Translation ↔ Products

### Relationship

Product Category Translation (1) → Products (N)

### Why?

- Each Portuguese product category has one English translation.
- Many products can belong to the same category.
- The translation table acts as a lookup table for reporting and analytics.

### Foreign Key

Products.product_category_name → ProductCategoryTranslation.product_category_name

### Business Meaning

This relationship enables dashboards and reports to display category names in English while maintaining a normalized database design.

### Future Analysis

- Revenue by Category
- Orders by Category
- Average Rating by Category
- Best Selling Categories
- Category Performance

## Geolocation ↔ Customers

### Relationship

Geolocation (1) → Customers (N)

### Why?

Each customer belongs to a geographical region identified by a ZIP code prefix. Multiple customers can share the same ZIP code prefix.

### Logical Join

# Customers.customer_zip_code_prefix

Geolocation.geolocation_zip_code_prefix

### Business Meaning

This relationship enables customer distribution, regional sales, and delivery performance analysis.

### Future Analysis

- Customers by State
- Customers by City
- Revenue by State
- Delivery Performance by Region

---

## Geolocation ↔ Sellers

### Relationship

Geolocation (1) → Sellers (N)

### Why?

Each seller belongs to a geographical region identified by a ZIP code prefix. Multiple sellers can operate within the same ZIP code prefix.

### Logical Join

# Sellers.seller_zip_code_prefix

Geolocation.geolocation_zip_code_prefix

### Business Meaning

This relationship enables seller distribution and logistics analysis.

### Future Analysis

- Sellers by State
- Sellers by City
- Regional Seller Density
- Regional Logistics Analysis
