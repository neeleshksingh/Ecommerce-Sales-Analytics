# Customers Table Profiling

## Purpose

Stores customer identification and geographical information. This table is used to identify customers and perform regional analysis based on city, state, and ZIP code.

## One Row Represents

Each row represents a customer record associated with an order. The table contains customer identifiers and location details.

## Columns

| Column                   | Description                                                      |
| ------------------------ | ---------------------------------------------------------------- |
| customer_id              | Unique customer identifier used in orders                        |
| customer_unique_id       | Identifier representing the same customer across multiple orders |
| customer_zip_code_prefix | Customer ZIP code prefix                                         |
| customer_city            | Customer city                                                    |
| customer_state           | Customer state                                                   |

## Primary Key

customer_id

## Business Key

customer_unique_id

## Foreign Keys

None.

This table is referenced by the Orders table using customer_id.

## Expected Data Types

| Column                   | Data Type |
| ------------------------ | --------- |
| customer_id              | VARCHAR   |
| customer_unique_id       | VARCHAR   |
| customer_zip_code_prefix | INTEGER   |
| customer_city            | VARCHAR   |
| customer_state           | CHAR(2)   |

## Business Importance

- Supports customer distribution analysis.
- Enables city-wise and state-wise reporting.
- Helps identify high-performing regions.
- Used with the Orders table to analyze customer purchasing behavior.

## Possible KPIs

- Total Customers
- Customers by State
- Customers by City
- Top 10 Cities by Customer Count
- Top 10 States by Customer Count
- Customer Distribution by Region

## Possible Data Quality Issues

- Duplicate customer_id
- Duplicate customer_unique_id
- Missing city or state values
- Invalid ZIP codes
- Inconsistent city names
- Leading or trailing spaces
- Invalid state codes

## Questions / Observations

- The dataset contains both a technical identifier (customer_id) and a business identifier (customer_unique_id).
- Customer personal information such as name, email, and phone number is intentionally not included.
- The same customer may have multiple customer_id values but a single customer_unique_id.
