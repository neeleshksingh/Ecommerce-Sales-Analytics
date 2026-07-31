from sqlalchemy import text

from etl.config import DB_NAME
from etl.database import get_engine


def main():
    engine = get_engine(DB_NAME)

    with engine.connect() as connection:
        connection = connection.execution_options(
            isolation_level="AUTOCOMMIT"
        )

        connection.execute(
            text(
                """
                DROP SCHEMA public CASCADE;
                CREATE SCHEMA public;
                """
            )
        )

        print("✅ Database schema reset successfully.")


if __name__ == "__main__":
    main()