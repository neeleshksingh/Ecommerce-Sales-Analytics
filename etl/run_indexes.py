from etl.config import DB_NAME
from etl.sql_runner import run_sql_folder
from etl.utils import PROJECT_ROOT


def main():
    indexes_folder = (
        PROJECT_ROOT
        / "sql"
        / "07_indexes"
    )

    print("=" * 70)
    print("Creating Database Indexes")
    print("=" * 70)

    run_sql_folder(DB_NAME, indexes_folder)

    print("\n✅ Database indexes created successfully.")


if __name__ == "__main__":
    main()