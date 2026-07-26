from pathlib import Path

import pandas as pd

from etl.database import get_engine


def load_csv_to_table(
    database_name: str,
    csv_path: Path,
    table_name: str,
):
    """
    Load a CSV file into a PostgreSQL table.
    """

    print(f"\n📄 Reading {csv_path.name}")

    if not csv_path.exists():
        print("❌ File not found")
        print(f"Path: {csv_path}")
        return

    try:
        dataframe = pd.read_csv(csv_path)

        print(f"Rows: {len(dataframe):,}")

        engine = get_engine(database_name)

        dataframe.to_sql(
            name=table_name,
            con=engine,
            if_exists="append",
            index=False,
            # method="multi",   # Temporarily removed for easier debugging
        )

        print(f"✅ Loaded into '{table_name}'")

    except Exception as e:
        print(f"\n❌ Failed while loading '{table_name}'")
        print(type(e))
        print(e)
        raise