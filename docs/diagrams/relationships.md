# Entity Relationship Diagram

## Overview

This document tracks the evolution of the Entity Relationship Diagram (ERD) throughout the project.

Instead of designing the complete database upfront, the ERD is built incrementally as each table is analyzed and understood. This approach ensures that every relationship is based on verified understanding of the dataset rather than assumptions.

---

# Current Version

## Version 2

### Profiled Tables

- Customers
- Orders
- Order Items
- Products

---

## Current Relationships

| Parent Table | Child Table | Relationship |
|--------------|-------------|--------------|
| Customers | Orders | One-to-Many (1:N) |
| Orders | Order Items | One-to-Many (1:N) |
| Products | Order Items | One-to-Many (1:N) |

---

## Relationship Summary

```text
Customers
    │
    │ 1:N
    ▼
Orders
    │
    │ 1:N
    ▼
Order Items
    ▲
    │ N:1
Products
```

---

## Pending Tables

The following tables are yet to be analyzed and will be added to the ERD in future versions.

- Sellers
- Payments
- Reviews
- Geolocation
- Product Category Translation

---

## ERD Versions

| Version | Description |
|----------|-------------|
| Version 1 | Customers → Orders → Order Items |
| Version 2 | Added Products and its relationship with Order Items |

---

## Notes

- The ER diagram is intentionally developed incrementally.
- Relationships are added only after the corresponding table has been fully profiled.
- The Physical ERD will be created after the PostgreSQL schema is designed.