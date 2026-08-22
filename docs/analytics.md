# Analytical SQL

The `sql/05_queries` progression is manually executed; it is not part of the ETL pipeline.

| Section | Patterns and representative use cases | Audit state |
|---|---|---|
| `01_basic_queries` | View exploration; entity counts; revenue, price, freight, purchase-range measures | Executed successfully |
| `02_aggregate_functions` | Category/state/seller/month aggregation, AOV, delivery, payment/status distributions | Executed; monthly revenue query is duplicated |
| `03_joins` | Anti-joins, order/payment/review detail, customer/seller/product analysis | Executed; complete-detail join can multiply items by payments/reviews |
| `04_subqueries` | Above-average filters, maxima, premium products, multi-seller customers, never reviewed, percentiles | File exceeded audit timeout; isolated correlated “Most Expensive Product in Each Category” exceeded 8 seconds; other statements passed |
| `05_ctes` | Customer/category/seller summaries, repeat, CLV, RFM prep, acquisition, executive KPIs | Executed successfully |
| `06_window_functions` | Rank/row number, running totals, LAG/LEAD, contribution, MoM, quartiles | Executed successfully |
| `07_business_questions` | Top customers/categories/sellers, repeat %, delivery by state, segments, growth/decline | Partial: “Highest-Revenue Product Categories” fails because `revenue_ran` is selected later as `revenue_rank`; other statements passed |
| `08_advanced_analysis` | Frequency/recency, price comparison, CLV, RFM scoring, seller benchmark, trends, contribution, cohorts, at-risk | Executed successfully |
| `09_interview_questions` | One top-ten customer-spend query using CTE + `DENSE_RANK` | **Partially completed**: one uncommented solution, not a full question set |
| `10_query_summary` | Educational syntax/pattern reference | Not executable by design; contains placeholders such as `SELECT ...` and failed execution audit |

## SQL quality findings

- Item-price revenue is internally consistent across most implemented analytics, but older notes recommended `payment_value`.
- Distinct order/customer counts generally protect item-grain aggregations. Joining item, payment, and review children together can still multiply monetary values.
- Most queries include all order statuses; this must not be interpreted as delivered/recognized revenue without a business rule.
- `NULLIF` protects key percentage divisions. LAG compares adjacent observed rows, so missing months are not filled.
- Ranks use `RANK`, `DENSE_RANK`, or `ROW_NUMBER` intentionally but produce different tie behavior; top-N-with-ties can return more than N rows.
- Product/category price comparison averages product averages equally, not item transactions; that is a product-weighted category benchmark.
- Correlated category maxima repeat aggregation and are a performance concern; a window rewrite is a future implementation task, not applied here.

No approved result export exists, so the documentation defines questions and semantics rather than claiming business outcomes.
