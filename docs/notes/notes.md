This is where most portfolio projects become weak.

People dump all SQL files into one folder like this:

```text
sql/
    query1.sql
    query2.sql
    query3.sql
```

It becomes impossible to understand.

I want your repository to look like something maintained by a **Data Analyst/Data Engineer with 2–3 years of experience**.

---

# 📂 SQL Folder Structure

> **Historical planning note:** several filenames and folder layouts below were proposals and do not match the implemented repository. Use [`../README.md`](../README.md) for the canonical documentation index.

```text
sql/
│
├── 01_schema/
│
├── 02_constraints/
│
├── 03_data_validation/
│
├── 04_cleaning/
│
├── 05_analysis/
│
├── 06_views/
│
├── 07_indexes/
│
├── 08_functions/
│
└── 09_procedures/
```

Now let's see what belongs in each folder.

---

# 1️⃣ 01_schema

This folder creates the database.

### Files

```text
01_create_database.sql

02_create_customers_table.sql

03_create_orders_table.sql

04_create_order_items_table.sql

05_create_products_table.sql

06_create_sellers_table.sql

07_create_payments_table.sql

08_create_reviews_table.sql

09_create_category_translation_table.sql

10_create_geolocation_table.sql
```

Contents:

```sql
CREATE DATABASE ecommerce_sales;

CREATE TABLE customers
(
    customer_id VARCHAR(50),
    ...
);
```

---

# 2️⃣ 02_constraints

After tables exist, define relationships.

Files

```text
01_primary_keys.sql

02_foreign_keys.sql

03_unique_constraints.sql

04_check_constraints.sql

05_not_null_constraints.sql
```

Examples

```sql
ALTER TABLE customers

ADD PRIMARY KEY(customer_id);
```

---

# 3️⃣ 03_data_validation

One of the most underrated folders.

Here you'll check data quality.

Files

```text
01_duplicate_checks.sql

02_null_checks.sql

03_invalid_dates.sql

04_invalid_zip_codes.sql

05_negative_values.sql

06_orphan_records.sql
```

Example

```sql
SELECT

customer_id,

COUNT(*)

FROM customers

GROUP BY customer_id

HAVING COUNT(*)>1;
```

This is exactly what analysts do before analysis.

---

# 4️⃣ 04_cleaning

Data cleaning.

Files

```text
01_remove_duplicates.sql

02_trim_spaces.sql

03_standardize_city_names.sql

04_handle_null_values.sql

05_fix_invalid_dates.sql
```

Example

```sql
UPDATE sellers

SET seller_city=INITCAP(TRIM(seller_city));
```

---

# 5️⃣ 05_analysis ⭐⭐⭐⭐⭐

This will become the biggest folder.

I recommend dividing it.

```text
05_analysis/

01_basic/

02_intermediate/

03_advanced/

04_window_functions/

05_ctes/

06_case_studies/
```

---

### 01_basic

```text
01_total_orders.sql

02_total_customers.sql

03_total_products.sql

04_total_revenue.sql
```

---

### 02_intermediate

```text
01_monthly_sales.sql

02_state_wise_sales.sql

03_category_analysis.sql

04_customer_analysis.sql
```

---

### 03_advanced

```text
01_customer_segmentation.sql

02_repeat_customers.sql

03_seller_performance.sql

04_delivery_analysis.sql
```

---

### 04_window_functions

```text
01_dense_rank.sql

02_row_number.sql

03_running_total.sql

04_lag.sql

05_lead.sql
```

---

### 05_ctes

```text
01_top_customers.sql

02_sales_growth.sql

03_category_ranking.sql
```

---

### 06_case_studies

This is my favorite.

Remember your 21 business questions?

Each becomes one SQL file.

Example

```text
01_highest_revenue_month.sql

02_best_seller.sql

03_delivery_delay.sql

04_payment_analysis.sql

05_state_performance.sql

...
```

This makes your project very easy to navigate.

---

# 6️⃣ 06_views

Create reusable views.

Files

```text
01_customer_orders_view.sql

02_sales_summary_view.sql

03_product_performance_view.sql

04_seller_summary_view.sql
```

Example

```sql
CREATE VIEW sales_summary AS
...
```

---

# 7️⃣ 07_indexes

Performance optimization.

Files

```text
01_customer_indexes.sql

02_orders_indexes.sql

03_analysis_indexes.sql
```

Example

```sql
CREATE INDEX

idx_customer

ON customers(customer_id);
```

---

# 8️⃣ 08_functions

PostgreSQL functions.

Example

```text
01_calculate_delivery_days.sql

02_customer_lifetime_value.sql

03_total_sales.sql
```

Example

```sql
CREATE FUNCTION

calculate_delivery_days(...)
```

---

# 9️⃣ 09_procedures

Stored Procedures.

Files

```text
01_refresh_summary.sql

02_monthly_sales_report.sql

03_load_processed_data.sql
```

Example

```sql
CALL

refresh_sales();
```

---

# ⭐ One Folder I'd Add

This is something most people don't include.

```text
10_exploration/
```

Before writing analysis queries, analysts explore the data.

Files

```text
01_customers_exploration.sql

02_orders_exploration.sql

03_products_exploration.sql

04_sellers_exploration.sql

05_payments_exploration.sql
```

Example

```sql
SELECT *

FROM customers

LIMIT 10;

-------------------

SELECT DISTINCT order_status

FROM orders;

-------------------

SELECT COUNT(*)

FROM products;
```

This documents your initial exploration and shows your analytical process.

---

# ⭐ Final SQL Structure (Recommended)

```text
sql/
│
├── 01_schema/
│   ├── 01_create_database.sql
│   ├── 02_create_customers_table.sql
│   ├── ...
│
├── 02_constraints/
│   ├── 01_primary_keys.sql
│   ├── 02_foreign_keys.sql
│   ├── ...
│
├── 03_data_validation/
│   ├── 01_duplicate_checks.sql
│   ├── 02_null_checks.sql
│   ├── ...
│
├── 04_cleaning/
│   ├── 01_remove_duplicates.sql
│   ├── ...
│
├── 05_analysis/
│   ├── 01_basic/
│   ├── 02_intermediate/
│   ├── 03_advanced/
│   ├── 04_window_functions/
│   ├── 05_ctes/
│   └── 06_case_studies/
│
├── 06_views/
│
├── 07_indexes/
│
├── 08_functions/
│
├── 09_procedures/
│
└── 10_exploration/
```

---

# 💡 My Recommendation (Based on Your Goal)

Since your target is a **Data Analyst role (with Data Engineer as a future goal)**, I would make one small change:

```text
sql/
│
├── 00_setup/
│   ├── 01_create_database.sql
│   ├── 02_create_schema.sql
│   └── 03_import_notes.md
│
├── 01_schema/
├── 02_constraints/
├── 03_data_validation/
├── 04_cleaning/
├── 05_exploration/      ⭐
├── 06_analysis/         ⭐
├── 07_views/
├── 08_indexes/
├── 09_functions/
└── 10_procedures/
```

The addition of a dedicated **Exploration** stage reflects a real analytics workflow:

> **Raw Data → Exploration → Validation → Cleaning → Analysis**

That's much closer to how professional analysts work, and it makes the progression of your project clear to anyone reviewing your repository.
