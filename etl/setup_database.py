import os

from sqlalchemy import text

from etl.config import DB_NAME
from etl.database import get_engine


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
            
if __name__ == "__main__":
    create_database()