from pathlib import Path

from etl.config import DB_NAME
from etl.sql_runner import run_sql_folder
from etl.utils import PROJECT_ROOT

def main():
    constraints_folder = (
        PROJECT_ROOT
        / "sql"
        / "02_constraints"
    )

    print("=" * 70)
    print("Applying Database Constraints")
    print("=" * 70)

    run_sql_folder(DB_NAME, constraints_folder)

    print("\n✅ Constraints applied successfully.")


if __name__ == "__main__":
    main()