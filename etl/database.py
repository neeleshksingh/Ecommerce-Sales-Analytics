from sqlalchemy import create_engine, text

from etl.config import (
    DB_HOST,
    DB_PORT,
    DB_NAME,
    DB_USER,
    DB_PASSWORD,
)

DATABASE_URL = (
    f"postgresql+psycopg2://"
    f"{DB_USER}:{DB_PASSWORD}"
    f"@{DB_HOST}:{DB_PORT}/{DB_NAME}"
)

engine = create_engine(DATABASE_URL)

if __name__ == "__main__":
    try:
        with engine.connect() as connection:
            connection.execute(text("SELECT 1"))
        print("✅ Connected to PostgreSQL successfully!")
    except Exception as e:
        print(f"❌ Connection failed: {e}")