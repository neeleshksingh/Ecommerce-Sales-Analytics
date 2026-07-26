import os

from sqlalchemy import text

from etl.config import DB_NAME
from etl.database import get_engine
from pathlib import Path

def create_database():
    engine = get_engine("postgres")

    with engine.connect() as connection:
        connection = connection.execution_options(isolation_level="AUTOCOMMIT")

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

def get_schema_files():
    project_root = Path(__file__).resolve().parent.parent

    schema_folder = project_root / "sql" / "01_schema"

    return sorted(schema_folder.glob("*.sql"))
            
if __name__ == "__main__":
    create_database()

    print("\nSchema files:")

    for file in get_schema_files():
        print(file.name)