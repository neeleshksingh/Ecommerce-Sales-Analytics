# Power BI readiness

## Current state

`powerbi/` contains only a zero-byte `test.ts`; there is no `.pbix`, `.pbit`, semantic-model export, DAX, screenshot, or refresh configuration. A dashboard must not be described as implemented.

## Proposed model (future)

Use base tables or carefully selected views, not a web of all eight views:

- Fact sales: `vw_sales` at order-item grain; extend in SQL or model with order status/unique customer if required.
- Order dimension/fact header: `vw_orders` at order grain.
- Dimensions: `vw_products`, `vw_sellers`, and a deduplicated unique-customer dimension derived from `customers`.
- Payment fact: `vw_payments` at payment grain, related by `order_id` without joining it into item rows for summation.
- Delivery fact: `vw_delivery` at order grain.
- Date dimension: create in Power BI or PostgreSQL; none exists in repository.
- Avoid `vw_rfm` as a unique customer table until its location grouping is corrected.

Relationships should generally be one-to-many from dimensions to facts with single-direction filtering. Geolocation requires a defined one-row-per-ZIP rule before use.

## KPI sourcing

Reliable SQL-defined candidates are item-price revenue, distinct orders, items sold, average item price, product/customer/seller/state/category cuts, and eligible-order delivery metrics. Repeat customer, RFM, and CLV require the exact caveats in [metrics.md](metrics.md). Payment value must remain separate from item-price revenue.

Prefer SQL for reusable grain-changing logic, source joins, data-quality filtering, and governed metrics. Use DAX for filter-context measures, time intelligence over a proper date table, presentation ratios, and interactive comparisons. Do not duplicate the same metric independently in both layers without reconciliation tests.

## Proposed pages

1. Executive sales: revenue, orders, customers, items, AOV, monthly trend.
2. Product/category: revenue, item volume, contribution, price.
3. Customer: repeat behavior and corrected RFM/CLV.
4. Seller/geography: seller/state performance.
5. Delivery/quality: delivery days, late %, status, review score where safely preaggregated.

This structure is a proposal, not a repository artifact.
