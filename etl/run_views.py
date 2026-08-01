from etl.config import DB_NAME
from etl.sql_runner import run_sql_folder
from etl.utils import PROJECT_ROOT


def main():
    views_folder = (
        PROJECT_ROOT
        / "sql"
        / "06_views"
    )

    print("=" * 70)
    print("Creating Database Views")
    print("=" * 70)

    run_sql_folder(DB_NAME, views_folder)

    print("\n✅ Database views created successfully.")


if __name__ == "__main__":
    main()