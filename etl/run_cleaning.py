from etl.config import DB_NAME
from etl.sql_runner import run_sql_folder
from etl.utils import PROJECT_ROOT


def main():
    cleaning_folder = (
        PROJECT_ROOT
        / "sql"
        / "04_cleaning"
    )

    print("=" * 70)
    print("Running Data Cleaning")
    print("=" * 70)

    run_sql_folder(DB_NAME, cleaning_folder)

    print("\n✅ Data cleaning completed successfully.")


if __name__ == "__main__":
    main()