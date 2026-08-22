# Indexes

`etl.run_indexes` executes all five files. PostgreSQL automatically supplies unique B-tree indexes for eight primary keys; geolocation has none.

## Explicit indexes

| Category | Indexes (columns) | Intended benefit |
|---|---|---|
| Foreign-key/join | `orders(customer_id)`; `order_items(order_id)`; `order_items(product_id)`; `order_items(seller_id)`; `order_reviews(order_id)`; `order_payments(order_id)`; `products(product_category_name)` | Parent/child joins, FK checks/deletes, category lookup |
| Lookup/filter | `orders(order_status)`; `orders(order_purchase_timestamp)`; `customers(customer_city)`; `customers(customer_state)`; `sellers(seller_city)`; `sellers(seller_state)` | Status/date and geographic predicates/grouping |
| Composite | `customers(customer_city,customer_state)`; `sellers(seller_city,seller_state)`; `orders(order_status,order_purchase_timestamp)`; `order_items(order_id,product_id)` | Combined filters/joins respecting leftmost-prefix rules |

All use `CREATE INDEX IF NOT EXISTS` and were live-verified. No special index method is specified, so PostgreSQL defaults to B-tree. The summary file only lists catalog state.

These are implemented optimizations, not proven speedups. There is overlap between single-column indexes and composite leading columns, and no workload/query-plan benchmark documents selectivity or write overhead. Large aggregations/window sorts may still scan and sort substantial data.
