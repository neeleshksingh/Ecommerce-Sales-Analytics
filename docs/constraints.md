# Constraints

Schema files create `NOT NULL` and primary-key constraints; `etl.run_constraints` later adds foreign keys and checks. The audited database matches these definitions.

## Keys and foreign keys

| Child | Constraint | Parent | Purpose |
|---|---|---|---|
| orders.customer_id | `fk_orders_customers` | customers.customer_id | Every order has a loaded customer record |
| order_reviews.order_id | `fk_order_reviews_orders` | orders.order_id | Every review pair references an order |
| order_payments.order_id | `fk_order_payments_orders` | orders.order_id | Every payment references an order |
| order_items.order_id | `fk_order_items_orders` | orders.order_id | Every item references an order |
| order_items.product_id | `fk_order_items_products` | products.product_id | Every item references a product |
| order_items.seller_id | `fk_order_items_sellers` | sellers.seller_id | Every item references a seller |

Primary keys are listed in [data_model.md](data_model.md). No additional UNIQUE constraint is implemented. `order_reviews.order_id` is intentionally not unique; source data contains repeated orders. The physical composite review key preserves repeated `review_id` values across orders.

## Checks

- Review score is 1–5.
- Payment value, item price, and freight are non-negative.
- Nullable product weight, dimensions, name/description lengths, and photo quantity must be non-negative when present. Explicit `IS NULL` appears only in the weight check, but PostgreSQL CHECK constraints also accept unknown/null for the others.

## Intentionally absent

- `products.product_category_name` → translation is not enforced because `pc_gamer` and `portateis_cozinha_e_preparadores_de_alimentos` are absent from the lookup.
- `payment_installments >= 1` is omitted because two preserved source rows contain zero.
- Geolocation FKs are omitted because ZIP prefixes are non-unique.
- No order-status enumeration, timestamp-sequence, or review timestamp check is implemented.

Constraint scripts are not idempotent. They run after validation, but validation does not block execution; invalid data instead causes the subsequent `ALTER TABLE` to fail where a physical constraint covers it.
