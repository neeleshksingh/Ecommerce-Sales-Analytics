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
