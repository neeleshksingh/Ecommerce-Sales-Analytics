# Canonical metric catalog

Unless stated otherwise, “revenue” means product-price revenue and includes every order status represented in `order_items`.

| Metric | Implemented formula | Grain/source | Interpretation and caveat |
|---|---|---|---|
| Revenue | `SUM(order_items.price)` | Chosen grouping; items | Excludes freight/payment differences/cost; not profit |
| Total orders | `COUNT(DISTINCT orders.order_id)` (or `COUNT(*)` on order-grain view) | Overall/group | Distinct required after item joins |
| Total customers | `COUNT(DISTINCT customer_unique_id)` for people; basic view query uses row count | Overall/group | `customer_id`/view rows overcount repeat identities |
| Products sold | `COUNT(order_items.product_id)` | Items/group | Counts item rows, not distinct product SKUs |
| Average order value | `SUM(price) / COUNT(DISTINCT order_id)` or average order totals | Overall/group | Product-price-only; all statuses unless filtered |
| Average item price | `AVG(order_items.price)` | Item/group | Transaction-weighted item price |
| Average delivery days | `AVG(delivered_date::date-approved_at::date)` or average `vw_delivery.delivery_days` | Delivered/eligible orders | Approval-to-delivery; missing timestamps excluded; partial days truncated |
| Late delivery % | `100*SUM(delivered>estimated)/COUNT(eligible orders)` | Customer state in business query | Eligible query requires delivered and approved; approved is not needed for lateness but is used by implementation |
| Repeat customer % | `100*COUNT(unique customers with >=2 orders)/COUNT(unique customers with >=1 order)` | Customer segment/overall | Includes all order statuses |
| Recency | `CURRENT_DATE-MAX(purchase_date)` | Unique customer intended | Dynamic and historically inflated; `vw_rfm` can split locations |
| Frequency | `COUNT(DISTINCT order_id)` | Unique customer | All statuses |
| Monetary | `SUM(item price)` | Unique customer | Same exclusions as revenue |
| RFM score | `NTILE(4)` for each R/F/M, then sum | Unique customer | Implementation orders recency ascending then sums raw tiles, so more recent customers receive lower recency scores while higher totals rank higher—direction is semantically inconsistent |
| Revenue contribution | `100*group_revenue/SUM(group_revenue) OVER(...)` | Category/customer; overall or month | Null-safe denominator; grouping determines meaning |
| MoM revenue growth | `100*(monthly-current previous)/NULLIF(previous,0)` | Month | LAG previous observed month; first month null/omitted |
| Customer lifetime value | Historical `SUM(item price)`; advanced query adds AOV/lifetime days | Unique customer | Descriptive realized spend, not predicted CLV |

Payment revenue can separately be defined as `SUM(order_payments.payment_value)`, but that is not the canonical revenue used by current analytics and must be aggregated per order before joining to items.
