# ETL and pipeline

## Actual order

Run `python -m etl.pipeline` from the repository root. `PIPELINE` calls:

1. `reset_database` — AUTOCOMMIT `DROP SCHEMA public CASCADE; CREATE SCHEMA public;`.
2. `setup_database` — creates `DB_NAME` if absent, then runs `sql/01_schema/*.sql` alphabetically.
3. `load_data` — loads the nine fixed CSV/table mappings.
4. `run_validation` — executes `sql/03_data_validation`.
5. `run_constraints` — executes `sql/02_constraints`.
6. `run_cleaning` — executes `sql/04_cleaning`.
7. `run_indexes` — executes `sql/07_indexes`.
8. `run_views` — executes `sql/06_views`.

Thus runtime order differs from numeric folder order: validation precedes constraints; constraints precede cleaning.

There is a bootstrap defect: reset connects to `DB_NAME` before `setup_database.create_database` runs. On a truly new environment the full pipeline therefore fails unless the database is created first. Running `python -m etl.setup_database` can create it, but also creates tables, which the subsequent full pipeline immediately drops and recreates.

## Connection and discovery

`config.py` calls `load_dotenv()` and reads five `DB_*` values. `database.py` interpolates them into a `postgresql+psycopg2` URL and builds a future-mode SQLAlchemy engine with `pool_pre_ping=True`. Variables are not validated or URL-escaped.

`utils.py` derives `PROJECT_ROOT` from the package path. `run_sql_folder` sorts `*.sql`, reads each as UTF-8, and sends the complete file through `connection.execute(text(sql))` on an AUTOCOMMIT connection.

## CSV ingestion

Each CSV is read fully by `pandas.read_csv`; a fresh engine is created per file; `DataFrame.to_sql(if_exists="append", index=False)` inserts rows. There is no chunksize, COPY, staging, explicit dtype map, checksum, or row reconciliation. A missing file is printed and skipped.

## Failure, transactions, and observability

- Successful earlier files/stages remain after a later failure; no pipeline-wide transaction exists.
- SQLAlchemy/load exceptions are re-raised and stop execution.
- Validation results are neither fetched nor asserted; successful execution is not a quality pass.
- Output is stdout only. There are no run IDs, audit tables, retries, or alerts.
- `config.py` prints the password and `database.py` prints the full URL: a high-priority security defect.

## Reruns and idempotency

The full pipeline is repeatable only as a destructive rebuild. Running `load_data` alone duplicates data or violates keys. Schema and constraint scripts are generally non-idempotent; indexes use `IF NOT EXISTS`, views use `CREATE OR REPLACE`, and procedures use truncate/reload but are not orchestrated.

`sql/00_setup`, analytics, functions, procedures, and documentation have no runner.
