# Order Items Table Profiling

---

## Purpose

> Describe the purpose of this table in the business.

---

## One Row Represents

> What does one row represent?
>
> (Think carefully about the grain of this table.)

---

## Columns

| Column | Description |
|---------|-------------|
| order_id | |
| order_item_id | |
| product_id | |
| seller_id | |
| shipping_limit_date | |
| price | |
| freight_value | |

---

## Primary Key

> Identify the Primary Key.
>
> If you think it is a composite key, mention that.

---

## Foreign Keys

| Column | References |
|---------|------------|
| order_id | |
| product_id | |
| seller_id | |

---

## Expected Data Types

| Column | Data Type |
|---------|-----------|
| order_id | |
| order_item_id | |
| product_id | |
| seller_id | |
| shipping_limit_date | |
| price | |
| freight_value | |

---

## Business Importance

> Explain why this table is important for the business.

---

## Business Questions This Table Can Answer

- 
- 
- 
- 
- 
- 
- 
- 

---

## Possible KPIs

### Sales KPIs

- 
- 
- 

### Product KPIs

- 
- 
- 

### Seller KPIs

- 
- 
- 

### Shipping KPIs

- 
- 
- 

---

## Analytical Opportunities

> Think like a Data Analyst.

Examples (don't copy blindly):

- Product Performance Analysis
- Seller Performance Analysis
- Revenue Analysis
- Shipping Cost Analysis
- Basket Size Analysis

Write your own ideas below.

- 
- 
- 
- 
- 

---

## Data Validation Rules

- 
- 
- 
- 
- 
- 
- 

---

## Possible Data Quality Issues

- 
- 
- 
- 
- 
- 
- 
- 

---

## Observations

- 
- 
- 
- 

---

## Relationships

```text
Orders
     │
     │ order_id
     ▼
Order Items
     │
     ├────────► Products
     │
     └────────► Sellers
```

---

## Future SQL Analysis

This table can be used for:

- 
- 
- 
- 
- 
- 
- 