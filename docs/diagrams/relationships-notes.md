# Database Relationships

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
