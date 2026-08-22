# PostgreSQL functions

Function SQL exists in `sql/08_functions`, but no Python runner deploys it. Live audit status is point-in-time.

| Function | Input → return | Logic / grain | Dependencies | Status |
|---|---|---|---|---|
| `fn_customer_lifetime_value` | customer unique ID → numeric | Sum item price across that customer's orders; zero if absent | customers, orders, items | Defined; deployed and executed (`124.99` for repository sample) |
| `fn_monthly_sales` | date → numeric | Sum item price in half-open calendar month; zero if absent | orders, items | Defined; deployed and executed (`950030.36` for 2018-01) |
| `fn_top_selling_products` | English category → table | Product revenue, `DENSE_RANK`, ranks ≤3 (ties may return >3 rows) | `vw_products`, items | Defined; deployment/execution unverified |
| `fn_average_delivery_days` | customer state → numeric | Average delivered-date minus approved-date, date precision | customers, orders | Defined; deployment/execution unverified |
| `fn_customer_order_count` | customer unique ID → integer | Distinct order count | customers, orders | Defined; deployment/execution unverified |
| `fn_state_revenue` | seller state → numeric | Sum item price for sellers in state | sellers, items | Defined; deployment/execution unverified |

Examples are embedded in every SQL file. Caution: `fn_top_selling_products` filters the English translation but its embedded example passes Portuguese `beleza_saude`, so it is expected to return no rows for that argument.

```sql
SELECT fn_customer_lifetime_value('CUSTOMER_UNIQUE_ID');
SELECT fn_monthly_sales(DATE '2018-01-01');
SELECT * FROM fn_top_selling_products('health_beauty');
SELECT fn_average_delivery_days('SP');
SELECT fn_customer_order_count('CUSTOMER_UNIQUE_ID');
SELECT fn_state_revenue('SP');
```

Functions are query expressions that return scalar/table results and do not maintain stored summary tables here. Execute files manually after base tables/views exist; doing so also runs their trailing sample SELECT.
