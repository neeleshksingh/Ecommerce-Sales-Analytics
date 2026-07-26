from sqlalchemy import create_engine, text

from etl.config import (
    DB_HOST,
    DB_PORT,
    DB_NAME,
    DB_USER,
    DB_PASSWORD,
)


def get_engine(database_name=DB_NAME):
    """
    Create and return a SQLAlchemy engine for the specified database.
    """

    database_url = (
        f"postgresql+psycopg2://"
        f"{DB_USER}:{DB_PASSWORD}"
        f"@{DB_HOST}:{DB_PORT}/{database_name}"
    )

    return create_engine(database_url)


if __name__ == "__main__":
    try:
        engine = get_engine()

        with engine.connect() as connection:
            connection.execute(text("SELECT 1"))

        print("✅ Connected to PostgreSQL successfully!")

    except Exception as e:
        print(f"❌ Connection failed: {e}")