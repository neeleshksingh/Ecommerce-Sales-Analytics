from pathlib import Path

from etl.config import DB_NAME
from etl.csv_loader import load_csv_to_table

CSV_TO_TABLE = {
    "olist_customers_dataset.csv": "customers",
    "olist_geolocation_dataset.csv": "geolocation",
    "olist_order_items_dataset.csv": "order_items",
    "olist_order_payments_dataset.csv": "order_payments",
    "olist_order_reviews_dataset.csv": "order_reviews",
    "olist_orders_dataset.csv": "orders",
    "olist_products_dataset.csv": "products",
    "olist_sellers_dataset.csv": "sellers",
    "product_category_name_translation.csv": "product_category_translation",
}

project_root = Path(__file__).resolve().parent.parent

data_folder = project_root / "data" / "raw"


def load_all_data():
    for csv_name, table_name in CSV_TO_TABLE.items():

        csv_path = data_folder / csv_name

        load_csv_to_table(
            database_name=DB_NAME,
            csv_path=csv_path,
            table_name=table_name,
        )


if __name__ == "__main__":
    print("========== Loading Data ==========")

    load_all_data()

    print("\n✅ All datasets loaded successfully!")