# Entity Relationship Diagram

## Overview

This document tracks the evolution of the Entity Relationship Diagram (ERD) throughout the project.

The ERD is built incrementally after each table is analyzed. This ensures every relationship is based on verified understanding rather than assumptions.

---

# Current Version

## Version 4

### Profiled Tables

- Customers
- Orders
- Order Items
- Products
- Sellers
- Order Payments

---

## Current Relationships

| Parent Table | Child Table    | Relationship      |
| ------------ | -------------- | ----------------- |
| Customers    | Orders         | One-to-Many (1:N) |
| Orders       | Order Items    | One-to-Many (1:N) |
| Orders       | Order Payments | One-to-Many (1:N) |
| Products     | Order Items    | One-to-Many (1:N) |
| Sellers      | Order Items    | One-to-Many (1:N) |

---

## Relationship Summary

```text
                         Customers
                              │
                            1:N
                              │
                              ▼
                           Orders
                      ┌───────┴────────┐
                    1:N               1:N
                      │                │
                      ▼                ▼
                Order Items     Order Payments
                 ▲         ▲
               N:1       N:1
                 │         │
                 │         │
             Products   Sellers
```

---

## Pending Tables

- Order Reviews
- Geolocation
- Product Category Translation

---

## ERD Versions

| Version   | Description                      |
| --------- | -------------------------------- |
| Version 1 | Customers → Orders → Order Items |
| Version 2 | Added Products                   |
| Version 3 | Added Sellers                    |
| Version 4 | Added Order Payments             |

---

## Notes

- The ERD evolves after profiling each table.
- Relationships are added only after understanding the business meaning of the dataset.
- One order can contain multiple order items.
- One order can have multiple payment transactions.
- One product can appear in multiple order items.
- One seller can fulfill multiple order items.
- The Physical ERD will be created after the PostgreSQL schema is finalized.
