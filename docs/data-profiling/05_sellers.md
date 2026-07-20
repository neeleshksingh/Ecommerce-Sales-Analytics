# Sellers Table Profiling

---

## Purpose

The **Sellers** table stores information about every seller registered on the e-commerce platform, including their unique identifier and geographical location. This table enables seller-level reporting, regional analysis, logistics planning, and marketplace performance evaluation when combined with transactional tables.

---

## One Row Represents

Each row represents **one unique seller** registered on the e-commerce platform along with the seller's geographical location.

---

## Columns

| Column                 | Description                               |
| ---------------------- | ----------------------------------------- |
| seller_id              | Unique identifier of the seller.          |
| seller_zip_code_prefix | ZIP code prefix of the seller's location. |
| seller_city            | City where the seller operates.           |
| seller_state           | State where the seller operates.          |

---

## Primary Key

`seller_id`

---

## Foreign Keys

None.

This table is referenced by the **Order Items** table through the `seller_id` column.

---

## Expected Data Types

| Column                 | Data Type |
| ---------------------- | --------- |
| seller_id              | VARCHAR   |
| seller_zip_code_prefix | INTEGER   |
| seller_city            | VARCHAR   |
| seller_state           | CHAR(2)   |

---

## Business Importance

This table provides seller information required for logistics, marketplace operations, and regional business analysis.

It supports:

- Seller performance analysis.
- Regional seller distribution analysis.
- Marketplace expansion planning.
- Logistics and delivery planning.
- Revenue analysis by seller (after joining with Order Items).
- Operational reporting.

---

## Business Questions This Table Can Answer

- How many sellers are registered on the platform?
- Which states have the highest number of sellers?
- Which cities have the highest number of sellers?
- Which sellers generate the highest revenue? _(After joining with Order Items)_
- Which sellers sell the highest number of products? _(After joining with Order Items)_
- Which sellers receive the highest customer ratings? _(After joining with Reviews)_
- Which sellers contribute the most revenue?
- Which regions have the highest seller concentration?

---

## Possible KPIs

### Seller KPIs

- Total Sellers
- Active Sellers
- Revenue per Seller
- Products Sold per Seller
- Average Revenue per Seller

### Geographic KPIs

- Sellers by State
- Sellers by City
- Top Seller States
- Top Seller Cities

### Performance KPIs

- Seller Revenue Contribution
- Seller Performance Ranking
- Average Delivery Performance
- Average Review Score (after joining Reviews)

---

## Analytical Opportunities

- Seller Performance Analysis
- Geographic Distribution Analysis
- Seller Revenue Analysis
- Seller Ranking
- Delivery Performance Analysis
- Regional Marketplace Analysis
- Seller Contribution Analysis
- Revenue Distribution by State

---

## Data Validation Rules

- `seller_id` must be unique.
- `seller_zip_code_prefix` should contain a valid ZIP code prefix.
- `seller_city` should not be NULL.
- `seller_state` should not be NULL.
- `seller_state` should contain a valid two-letter state code.

---

## Possible Data Quality Issues

- Duplicate seller IDs.
- Missing city.
- Missing state.
- Missing ZIP code.
- Invalid ZIP code format.
- Invalid state codes.
- Inconsistent city names.
- Leading or trailing spaces in location fields.
- Incorrect capitalization of city names.

---

## Observations

- Sellers and Customers store similar geographical information.
- Seller location is essential for logistics and delivery planning.
- One seller can fulfill multiple order items.
- One seller can sell multiple different products.
- Revenue is not stored in this table and must be calculated by joining with the Order Items table.
- This table stores descriptive seller information rather than transactional sales data.

---

## Relationships

| Parent Table | Child Table | Relationship |
| ------------ | ----------- | ------------ |
| Sellers      | Order Items | One-to-Many  |

---

## Future SQL Analysis

This table can be used for:

- Seller Performance Analysis
- Seller Revenue Analysis
- Seller Distribution Analysis
- Top Sellers Ranking
- Revenue by State
- Revenue by City
- Seller Contribution Analysis
- Marketplace Coverage Analysis

---
