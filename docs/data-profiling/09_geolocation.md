# Geolocation Table Profiling

---

## Purpose

The **Geolocation** table stores the geographical information associated with Brazilian ZIP code prefixes. It maps ZIP code prefixes to latitude, longitude, city, and state, enabling location-based analysis such as delivery performance, regional sales, logistics optimization, and customer distribution.

---

## One Row Represents

Each row represents **one geographical location associated with a ZIP code prefix**.

> **Note:** A ZIP code prefix may appear multiple times in the dataset due to multiple latitude and longitude coordinates being associated with the same region.

---

## Columns

| Column                      | Description                                         |
| --------------------------- | --------------------------------------------------- |
| geolocation_zip_code_prefix | ZIP code prefix representing a geographical region. |
| geolocation_lat             | Latitude coordinate of the location.                |
| geolocation_lng             | Longitude coordinate of the location.               |
| geolocation_city            | City corresponding to the ZIP code prefix.          |
| geolocation_state           | State corresponding to the ZIP code prefix.         |

---

## Primary Key

**No Primary Key**

> The dataset contains duplicate ZIP code prefixes with different latitude and longitude values. Therefore, no single column uniquely identifies each record.

---

## Foreign Keys

None (Physical Database)

### Conceptual Relationships

| Parent Table | Child Table | Relationship      |
| ------------ | ----------- | ----------------- |
| Geolocation  | Customers   | One-to-Many (1:N) |
| Geolocation  | Sellers     | One-to-Many (1:N) |

---

## Expected Data Types

| Column                      | Data Type     |
| --------------------------- | ------------- |
| geolocation_zip_code_prefix | INTEGER       |
| geolocation_lat             | DECIMAL(10,8) |
| geolocation_lng             | DECIMAL(11,8) |
| geolocation_city            | VARCHAR       |
| geolocation_state           | CHAR(2)       |

---

## Business Importance

This table provides geographical context for customers and sellers.

It supports:

- Delivery region analysis
- Customer distribution analysis
- Seller distribution analysis
- Logistics optimization
- Regional sales reporting
- Distance-based business analysis

---

## Business Questions This Table Can Answer

- Which states have the highest number of customers?
- Which cities have the highest number of sellers?
- Which regions generate the highest sales?
- Which regions experience the longest delivery times?
- Which states have the highest customer satisfaction?
- Which geographical regions contribute the most revenue?
- Where are sellers concentrated?
- Where are customers concentrated?

---

## Possible KPIs

### Geographic KPIs

- Total States
- Total Cities
- Total ZIP Code Prefixes
- Customer Distribution by State
- Seller Distribution by State
- Revenue by State
- Revenue by City
- Orders by Region

### Logistics KPIs

- Average Delivery Time by State
- Average Freight Cost by State
- Average Review Score by State
- Customer Density
- Seller Density
