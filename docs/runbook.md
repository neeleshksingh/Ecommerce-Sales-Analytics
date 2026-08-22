# Runbook

## Setup

Prerequisites are Python, pip/venv, PostgreSQL, and the nine existing raw CSVs. The PostgreSQL role must connect to `postgres`, create the configured database, reset `public`, and create objects.

```bash
git clone https://github.com/neeleshksingh/Ecommerce-Sales-Analytics.git
cd Ecommerce-Sales-Analytics
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
```

Set `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, and `DB_PASSWORD` in `.env`. Keep it uncommitted and use a dedicated database.

Create the configured database before the first full run. This is required because `pipeline.py` resets `DB_NAME` before reaching its create-if-absent setup code. One repository-provided bootstrap path is:

```bash
python -m etl.setup_database
```

That command creates the database and empty tables; the following full pipeline intentionally drops/recreates them. It also currently prints credentials. Alternatively, a PostgreSQL administrator can create the database named in `.env`.

## Full run

> **Warning:** this drops the configured database's entire `public` schema with `CASCADE` and currently prints credentials to stdout.

```bash
python -m etl.pipeline
```

Existing individual entry points are:

```bash
python -m etl.run_validation
python -m etl.run_cleaning
python -m etl.run_constraints
python -m etl.run_indexes
python -m etl.run_views
```

Do not run `load_data` against populated tables. Applying constraints twice fails because scripts lack `IF NOT EXISTS`.

## Manual assets

No wrapper exists for analytics, functions, or procedures. Use a PostgreSQL client, respecting dependencies:

```bash
psql -d "$DB_NAME" -f sql/08_functions/01_fn_customer_lifetime_value.sql
psql -d "$DB_NAME" -f sql/09_procedures/01_refresh_summary.sql
psql -d "$DB_NAME" -f sql/05_queries/01_basic_queries.sql
```

These examples assume standard PostgreSQL host/user/password configuration. Function `03` depends on `vw_products`. Procedure files create a target table/procedure, immediately call it, and select the refreshed results.

## Verify

```sql
SELECT table_name FROM information_schema.tables WHERE table_schema='public' ORDER BY 1;
SELECT table_name FROM information_schema.views WHERE table_schema='public' ORDER BY 1;
SELECT 'orders', COUNT(*) FROM orders UNION ALL SELECT 'order_items', COUNT(*) FROM order_items;
SELECT indexname FROM pg_indexes WHERE schemaname='public' ORDER BY 1;
```

Compare with [data_model.md](data_model.md). Manually review `sql/03_data_validation/07_validation_summary.sql`; the pipeline does not enforce it. At the audit, only two functions were deployed and no procedures/summary tables were deployed.

## Power BI and recovery

Connect Power BI Desktop using its PostgreSQL connector and the model in [powerbi.md](powerbi.md). No report is supplied.

After failure, fix the cause and rerun the full destructive pipeline for a known state. A partial run is not guaranteed usable. Back up non-project objects first because all of `public` is removed.
