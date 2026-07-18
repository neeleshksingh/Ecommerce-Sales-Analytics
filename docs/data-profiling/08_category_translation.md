# Product Category Translation Table Profiling

---

## Purpose

The **Product Category Translation** table stores the English translation of product category names originally recorded in Portuguese. It enables reports and dashboards to present category names in English, making the data easier to understand for an international audience.

---

## One Row Represents

Each row represents **one Portuguese product category and its corresponding English translation**.

---

## Columns

| Column                        | Description                                  |
| ----------------------------- | -------------------------------------------- |
| product_category_name         | Product category name in Portuguese.         |
| product_category_name_english | English translation of the product category. |

---

## Primary Key

- product_category_name

---

## Foreign Keys

None

> This table acts as a lookup (reference) table.

---

## Expected Data Types

| Column                        | Data Type |
| ----------------------------- | --------- |
| product_category_name         | VARCHAR   |
| product_category_name_english | VARCHAR   |

---

## Business Importance

This table standardizes product category names for reporting and analytics.

It supports:

- English dashboards
- International reporting
- Product category analysis
- Better readability of business reports

---

## Business Questions This Table Can Answer

- What is the English name of each product category?
- Which product categories generate the highest sales?
- Which product categories receive the highest ratings?
- Which product categories contribute the most revenue?
- Which product categories are most frequently purchased?

---

## Possible KPIs

- Total Product Categories
- Products per Category
- Revenue by Category
- Orders by Category
- Average Rating by Category

---

## Analytical Opportunities

- Category-wise Revenue Analysis
- Category-wise Sales Analysis
- Category-wise Customer Satisfaction
- Category Performance Ranking
- Top Performing Categories
- Least Performing Categories

---

## Data Validation Rules

- `product_category_name` must be unique.
- `product_category_name` must not be NULL.
- `product_category_name_english` should not be NULL.
- Each Portuguese category should map to only one English category.

---

## Possible Data Quality Issues

- Missing English translations.
- Duplicate Portuguese category names.
- Inconsistent English translations.
- Spelling mistakes in category names.
- Products referencing categories that do not exist in this table.

---

## Observations

- This is a lookup (dimension) table.
- It contains no transactional data.
- Multiple products can belong to the same category.
- The table improves report readability without duplicating category names in the Products table.

---

## Relationships

| Parent Table                 | Child Table | Relationship      |
| ---------------------------- | ----------- | ----------------- |
| Product Category Translation | Products    | One-to-Many (1:N) |

---

## Future SQL Analysis

- Revenue by Product Category
- Orders by Product Category
- Top Selling Categories
- Lowest Selling Categories
- Average Review Score by Category
- Category-wise Delivery Performance
