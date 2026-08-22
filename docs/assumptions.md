# Assumptions and interpretation rules

These rules are derived from implemented SQL, not desired future behavior.

| Topic | Implemented interpretation | Caveat |
|---|---|---|
| Customer identity | Use `customer_unique_id` across purchases; `customer_id` joins an order to its customer record | `vw_customers` remains customer-record grain, not unique-person grain |
| Revenue / spending | `SUM(order_items.price)` | Product-price revenue excludes freight and is not payment cash flow/profit; no order-status filter is normally applied |
| Payment value | Amount on one payment transaction | Do not join payments directly to items before separate aggregation; implemented revenue analytics do not use it |
| Products sold | Count order-item rows/product IDs | Quantity column does not exist; repeated units appear as separate item rows |
| AOV | Product-price revenue / distinct orders, or average of order-level price sums | Excludes freight and includes all statuses unless a query filters |
| Delivery time | Delivered-customer date minus approval date | Requires both timestamps; date-casting in some queries discards partial days |
| Late delivery | Delivered timestamp greater than estimated timestamp | Missing delivery yields flag 0 in `vw_delivery`; state analysis excludes missing delivered/approved timestamps |
| Repeat customer | Unique customer with at least two distinct orders | Only customers having orders are in denominator |
| RFM | Recency since latest purchase, distinct-order frequency, product-price monetary | `CURRENT_DATE` reference is dynamic; no status filter |
| CLV | Historical product-price spend, with supporting order/lifetime fields | This is realized historical value, not predictive lifetime value |
| Category translation | Left join Portuguese category to English lookup | Null/unmapped categories remain null; physical FK intentionally omitted |
| Geolocation | Descriptive source observations | No direct physical FK; reduce duplicate ZIP observations before fact joins |
| Nulls | Unknown/not available is preserved | No imputation is implemented |

No implemented metric represents profit because cost/margin data is absent.
