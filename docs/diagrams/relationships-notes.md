# Database Relationships

| Parent Table | Child Table | Relationship      |
| ------------ | ----------- | ----------------- |
| Customers    | Orders      | One-to-Many (1:N) |
| Orders       | Order Items | One-to-Many (1:N) |
| Products     | Order Items | One-to-Many (1:N) |
| Sellers      | Order Items | One-to-Many (1:N) |

---

## Relationship Summary

- One customer can place many orders.
- One order can contain multiple order items.
- One product can appear in multiple order items.
- One seller can fulfill multiple order items.
