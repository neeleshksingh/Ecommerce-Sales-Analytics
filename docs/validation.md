# Validation

`etl.run_validation` executes seven files alphabetically after load and before constraints. Every check is a SELECT: rows are printed by neither Python nor persisted, and no result causes pipeline failure unless SQL itself errors.

| File | Objective | Actual checks | Expected interpretation |
|---|---|---|---|
| `01_table_validation.sql` | Load completeness | Lists public tables, counts rows, reports empty tables | Nine expected non-empty tables; expected-vs-actual section is a placeholder |
| `02_column_validation.sql` | Column profile | Customer/order null, distinct, duplicate, length, state/status distributions | Manual review only; partial table/column coverage |
| `03_primary_key_validation.sql` | Key integrity | Duplicate groups for several PKs; two null checks | Zero returned duplicate rows/counts; omits review/category keys and some composite nulls |
| `04_foreign_key_validation.sql` | Orphans | Orders→customers; items→orders/products | Zero orphan counts; omits items→sellers, payments/reviews→orders, and category exception |
| `05_business_rule_validation.sql` | Review score | Groups scores satisfying `BETWEEN 1 AND 5` | Defect: returns valid values instead of invalid values |
| `06_data_profiling.sql` | Distribution/stats | All-table counts, customer/order/product/payment/review/seller/geo profiles, price outliers, category completeness | Informational; 3-sigma price rule is descriptive, not rejection |
| `07_validation_summary.sql` | Consolidated status | Empty tables, selected PK/FK checks, score/payment/price/freight/delivery rules | Returns PASS/FAIL rows but Python does not consume them |

Important semantic caveat: the summary labels “Negative Product Prices” but tests `price <= 0`, while the enforced constraint permits zero (`price >= 0`). Raw data currently has neither zero nor negative prices.

Source-level audit verified zero PK/composite-key duplicates and zero enforced-FK orphans. This is point-in-time evidence; it does not turn the scripts into automated tests.
