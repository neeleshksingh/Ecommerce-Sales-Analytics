from pathlib import Path

from etl.config import DB_NAME
from etl.sql_runner import run_sql_folder
from etl.utils import PROJECT_ROOT

def main():
    validation_folder = (
        PROJECT_ROOT
        / "sql"
        / "03_data_validation"
    )

    print("=" * 70)
    print("Running Data Validation")
    print("=" * 70)

    run_sql_folder(DB_NAME, validation_folder)

    print("\n✅ Data validation completed successfully.")


if __name__ == "__main__":
    main()