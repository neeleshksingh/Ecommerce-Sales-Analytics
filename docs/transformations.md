# Transformations and cleaning

Cleaning runs after constraints. It preserves source records and performs no deduplication, imputation, standardization of spelling/case, or derived-table build.

| File | Fields | Logic and effect |
|---|---|---|
| `01_trim_whitespace.sql` | Customer city/state; seller city/state; category keys/labels; product category; order status; geolocation city/state | Conditional `UPDATE ... SET col=TRIM(col)` where different. Removes boundary whitespace; key updates may be blocked by collisions/relationships if new data differs. |
| `02_standardize_nulls.sql` | Product metadata, delivery dates, review text | SELECT-only null counts. Explicitly performs no replacement to preserve unknown/not-applicable semantics. |
| `03_document_data_quality_exceptions.sql` | Zero payments/installments; missing translations | SELECT-only exception counts/categories; no rows modified. |
| `04_cleaning_summary.sql` | All tables and exceptions | SELECT-only row-count/exception/status report. |

Business implication: analytical SQL must handle nullable category/timestamps/review text and known exceptions. `CREATE` constraints already run before trimming, so cleaning cannot make invalid rows acceptable for initial constraint creation.
