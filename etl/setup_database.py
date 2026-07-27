from pathlib import Path

from sqlalchemy import text

from etl.config import DB_NAME
from etl.database import get_engine
from etl.sql_runner import run_sql_folder


def create_database():
    engine = get_engine("postgres")

    with engine.connect() as connection:
        connection = connection.execution_options(
            isolation_level="AUTOCOMMIT"
        )

        result = connection.execute(
            text(
                "SELECT 1 FROM pg_database WHERE datname = :database_name"
            ),
            {"database_name": DB_NAME},
        )

        if result.scalar():
            print(f"✅ Database '{DB_NAME}' already exists.")
        else:
            connection.execute(
                text(f'CREATE DATABASE "{DB_NAME}"')
            )
            print(f"✅ Database '{DB_NAME}' created successfully.")


if __name__ == "__main__":
    create_database()

    project_root = Path(__file__).resolve().parent.parent

    schema_folder = project_root / "sql" / "01_schema"

    run_sql_folder(DB_NAME, schema_folder)

    print("\n✅ Database setup completed successfully!")