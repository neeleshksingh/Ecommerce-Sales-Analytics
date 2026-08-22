# PostgreSQL procedures

All three procedure files are present but no procedure or target summary table was deployed in the audited database. The Python pipeline has no procedure runner; execution is unverified.

| Procedure / target | Sources | Grain and operation | Idempotency and risks |
|---|---|---|---|
| `sp_refresh_summary` → `ecommerce_sales_summary` | customers, orders, items | One overall snapshot: distinct orders/customers, item count, item-price revenue, AOV, average item price, refresh timestamp | Creates table if absent, truncates, inserts one row. Destructive to target history; all statuses included. |
| `sp_refresh_monthly_sales_report` → `monthly_sales_report` | orders, items | One month from the second observed month onward; revenue, LAG, change, growth | Truncate/reload; first month omitted; “previous” means previous observed row, not guaranteed adjacent calendar month. |
| `sp_load_processed_customer_data` → `processed_customer_sales` | customers, orders, items | One unique customer with orders/items; counts, spend, AOV, first/last purchase | Truncate/reload; excludes customers without item-bearing orders; no PK/index on target; database table, not `data/processed/`. |

Each file creates its target table, creates/replaces a SQL-language procedure, immediately `CALL`s it, and SELECTs results. A failure after `TRUNCATE` can risk an empty/partial target depending on client transaction handling; concurrent readers also need consideration. `loaded_at`/`refreshed_at` records only the latest refresh because history is discarded.

```sql
CALL sp_refresh_summary();
CALL sp_refresh_monthly_sales_report();
CALL sp_load_processed_customer_data();
```

Unlike functions, these procedures are invoked with `CALL` and mutate persistent reporting tables. Deploy manually in numeric order only after base data exists.
