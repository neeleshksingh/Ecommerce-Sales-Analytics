import os
from pathlib import Path

import pandas as pd
from sqlalchemy import create_engine, inspect
from dotenv import load_dotenv


load_dotenv()


# --------------------------------------------------
# OneDrive Power BI folder
# --------------------------------------------------

POWERBI_DATA_DIR = Path(
    "/Users/neeleshkumarsingh/Library/CloudStorage/"
    "OneDrive-PyxisBluSolutionsPrivateLimited/"
    "Ecommerce-Sales-Analytics/"
    "powerbi-data"
)


# --------------------------------------------------
# Database configuration
# --------------------------------------------------

DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT", "5432")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")


DATABASE_URL = (
    f"postgresql+psycopg2://"
    f"{DB_USER}:{DB_PASSWORD}@"
    f"{DB_HOST}:{DB_PORT}/{DB_NAME}"
)


# --------------------------------------------------
# Export all tables
# --------------------------------------------------

def main():

    POWERBI_DATA_DIR.mkdir(parents=True, exist_ok=True)

    engine = create_engine(DATABASE_URL)

    inspector = inspect(engine)

    tables = inspector.get_table_names(schema="public")

    print("=" * 80)
    print("Exporting PostgreSQL tables for Power BI")
    print("=" * 80)

    print(f"Found {len(tables)} tables")

    for table in tables:

        print(f"\n📦 Exporting: {table}")

        query = f'SELECT * FROM public."{table}"'

        df = pd.read_sql(query, engine)

        output_file = POWERBI_DATA_DIR / f"{table}.csv"

        df.to_csv(
            output_file,
            index=False
        )

        print(f"   Rows: {len(df):,}")
        print(f"   File: {output_file}")

    engine.dispose()

    print("\n" + "=" * 80)
    print("✅ Power BI CSV export completed")
    print("=" * 80)


if __name__ == "__main__":
    main()