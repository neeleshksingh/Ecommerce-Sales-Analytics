# Data quality

## Observed issues (source-profiled)

| Observation | Verified scope | Treatment |
|---|---:|---|
| Optional review title/message nulls | 87,656 / 58,247 | Preserved |
| Missing approval/carrier/customer-delivery timestamps | 160 / 1,783 / 2,965 orders | Preserved; delivery metrics exclude or return null |
| Missing product category/catalog lengths/photos | 610 products | Preserved |
| Missing product weight/dimensions | 2 products per affected field | Preserved |
| Non-null categories missing translation | 2 categories, 13 products | FK omitted; English label becomes null |
| Zero payment value | 9 payments (6 voucher, 3 `not_defined`) | Allowed and documented |
| Zero installments | 2 payments | Check intentionally omitted |
| Fully duplicated geolocation rows | 261,831 | Preserved; no PK |
| Repeated review/order identities | 814 repeated review IDs; 551 repeated order IDs | Composite (`review_id`,`order_id`) is unique |

No invalid review scores, non-positive item prices, negative freight, enforced-FK orphans, or customer deliveries before purchase were found in the source audit.

## Potential risks

- Raw CSVs are committed but not checksummed; loader does not reconcile expected counts.
- `read_csv` type inference can change with new input; PostgreSQL casts are relied upon.
- Geolocation joins can multiply facts unless reduced to one row per ZIP prefix.
- Category, review, payment, and order-item tables have different grains; naive joins multiply price/payment/review measures.
- Validation output is transient and non-enforcing.
- Current-date recency makes results non-reproducible for a historical dataset.

## Future improvements

Add manifest/checksums, staging tables, explicit dtypes, assertion-based tests, persisted quality results, reject/quarantine handling, deterministic geolocation reduction, and a fixed/configurable analysis date.
