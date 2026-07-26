from pathlib import Path

from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError

from etl.database import get_engine


def run_sql_folder(database_name: str, folder_path: Path):
    """
    Execute all SQL files in a folder
    in alphabetical order.
    """

    engine = get_engine(database_name)

    sql_files = sorted(folder_path.glob("*.sql"))

    if not sql_files:
        print(f"⚠️ No SQL files found in: {folder_path}")
        return

    with engine.connect() as connection:
        connection = connection.execution_options(
            isolation_level="AUTOCOMMIT"
        )

        for file in sql_files:
            print(f"\n▶ Running {file.name}")

            try:
                sql = file.read_text(encoding="utf-8")

                connection.execute(text(sql))

                print(f"✅ {file.name} completed successfully")

            except SQLAlchemyError as e:
                print(f"❌ Failed to execute {file.name}")

                # Print only the database error
                if hasattr(e, "orig"):
                    print(f"Reason: {e.orig}")
                else:
                    print(f"Reason: {e}")

                raise