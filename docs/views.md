# Views

All eight files use `CREATE OR REPLACE VIEW` and are run by `etl.run_views`. They were live-verified as deployed.

| View | Grain / rows audited | Sources and purpose | Caveats / BI use |
|---|---|---|---|
| `vw_orders` | One order / 99,441 | Orders inner-joined to customer identity/location | Good order fact; omits carrier date and ZIP |
| `vw_customers` | One customer record / 99,441 | Projection of customers | `customer_unique_id` repeats; not unique-customer dimension |
| `vw_products` | One product / 32,951 | Products left-joined to translations | English category nullable; good dimension |
| `vw_sellers` | One seller / 3,095 | Seller fields plus concatenated location | Good dimension |
| `vw_payments` | One payment sequence / 103,886 | Payments joined to order status | Multiple rows/order; aggregate before item joins |
| `vw_delivery` | One order / 99,441 | Lifecycle timestamps, day intervals, late/on-time flags | Null delivery produces both flags 0; `DATE_PART('day', interval)` truncates sub-day portions |
| `vw_sales` | One order item / 112,650 | Order-item fact with customer, seller, product/category | Revenue is item price; customer_unique_id and status are absent; do not join raw payments/reviews on order without preaggregation |
| `vw_rfm` | Intended customer; 95,539 rows | Unique customer/order/item aggregation | Actual grouping includes city/state: 95,420 distinct IDs, so mobile customers split. Inner joins omit customers/orders without items; `CURRENT_DATE` drifts |

Views are standard, not materialized. Complex BI refreshes repeat their joins/aggregations.
