import argparse
import logging
import os
import random
from datetime import date, datetime, timedelta
from itertools import product
from pathlib import Path
from random import randint
from typing import Optional

import pandas as pd
from faker import Faker

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    handlers=[logging.StreamHandler()],
)
logger = logging.getLogger(name="generator")

# -------------------------------------------------------------------------------
# Configuration
# --------------------------------------------------------------------------------

N_SELLERS = 500
N_CUSTOMERS = 5_000
N_ORDERS = 10_000
LOCALE = "en_US"

fake = Faker(LOCALE)

ORDER_STATUS = [
    "shipped",
    "unavailable",
    "created",
    "delivered",
    "invoiced",
    "cancelled",
    "processing",
    "approved",
]

BOX_CATALOGUE = {
    "general_purpose": [
        "Boxify Classic",
        "StowMate",
        "NeatNest",
        "TidyVault",
        "Cubix Hold",
    ],
    "premium": [
        "LuxeFold",
        "Velari Box",
        "Monobox Signature",
        "EvoCrate",
        "Silhouette Box",
    ],
    "eco_friendly": ["GreenPack", "EcoNest Crate", "ReLeaf Box", "EarthFold", "Biobox"],
    "heavy_duty": ["HaulPro", "StrongStash", "LoadBoxer", "TransitMax", "GripBox"],
    "gift_decorative": ["CharmCrate", "GiftyGlow", "WrapNest", "AuraBox", "VelvetCase"],
    "flatpack_stackable": [
        "StackRight",
        "FoldaBox",
        "SlimNest",
        "SnapCrate",
        "QuickStack",
    ],
}

BOX_SIZES = {
    "Small": {"width": 20.5, "length": 25.5, "height": 15.5},
    "Medium": {"width": 30.5, "length": 35.5, "height": 20.5},
    "Large": {"width": 40.5, "length": 50.5, "height": 30.5},
    "Extra Large": {"width": 50.5, "length": 60.5, "height": 40.5},
}

CATEGORY_PRICE_MULTIPLIER = {
    "general_purpose": 1.1,
    "premium": 1.5,
    "eco_friendly": 1.2,
    "heavy_duty": 1.3,
    "gift_decorative": 1.4,
    "flatpack_stackable": 1.15,
}


SIZE_BASE_PRICE = {
    "Small": 32.00,
    "Medium": 55.00,
    "Large": 78.00,
    "Extra Large": 92.00,
}


# -------------------------------------------------------------------------------
# Utility Functions
# --------------------------------------------------------------------------------
def random_date(start=datetime(2020, 1, 1), end=datetime(2024, 12, 31)):
    """Generate a random datetime between `start` and `end`"""
    result = start + timedelta(seconds=randint(0, int((end - start).total_seconds())))
    return result.date()


def generate_product_category() -> list[dict]:
    """Generate product catalogue with prices based on category and size."""
    logger.info("Generating products categories")
    categories = []
    category_id = 1
    for category, sub_categories in BOX_CATALOGUE.items():
        sub_cats = []
        for sub_cat in sub_categories:
            sub_cats.append(
                {
                    "product_category_id": f"{category_id:08d}",
                    "product_category": category,
                    "product_sub_category": sub_cat,
                }
            )
            category_id += 1
        categories.extend(sub_cats)
    return categories


def generate_products(categories: list[dict]) -> list[dict]:
    """Generate product catalogue with prices based on category and size."""
    logger.info("Generating products")
    category_lookup = {
        (cat["product_category"], cat["product_sub_category"]): cat[
            "product_category_id"
        ]
        for cat in categories
    }
    products = []
    product_id = 1
    for category, names in BOX_CATALOGUE.items():
        for name, (size_label, dimensions) in product(names, BOX_SIZES.items()):
            price = round(
                SIZE_BASE_PRICE[size_label] * CATEGORY_PRICE_MULTIPLIER[category], 2
            )
            products.append(
                {
                    "product_id": f"{product_id:08d}",
                    "product_category": category,
                    "product_category_id": category_lookup.get((category, name)),
                    "product_name": name,
                    "product_size_label": size_label,
                    "product_width_cm": dimensions["width"],
                    "product_length_cm": dimensions["length"],
                    "product_height_cm": dimensions["height"],
                    "product_price": price,
                }
            )
            product_id += 1
    return products


def generate_customers(n_customers: int = N_CUSTOMERS) -> list[dict]:
    """Generate random customer data."""
    logger.info("Generating customers")
    customers = []
    for i in range(n_customers):
        state_abbr = fake.state_abbr()
        customers.append(
            {
                "customer_id": f"{i+1:08d}",
                "customer_address": fake.unique.street_address(),
                "customer_state": state_abbr,
                "customer_zip_code": fake.zipcode_in_state(state_abbr),
                "customer_created_date": random_date(end=datetime(2023, 12, 31)),
                "customer_updated_date": None,
            }
        )
    return customers


def generate_sellers(n_sellers: int = N_SELLERS) -> list[dict]:
    """Generate random seller data."""
    logger.info("Generating sellers")
    sellers = []
    for i in range(n_sellers):
        state_abbr = fake.state_abbr()
        sellers.append(
            {
                "seller_id": f"{i+1:08d}",
                "seller_address": fake.unique.street_address(),
                "seller_state": state_abbr,
                "seller_zip_code": fake.zipcode_in_state(state_abbr),
                "seller_created_date": random_date(end=datetime(2023, 7, 31)),
                "seller_updated_date": None,
            }
        )
    return sellers


def generate_order_items(
    order_id: str,
    delivered_carrier_date: Optional[date],
    products_list: list[dict],
    n_sellers: int = N_SELLERS,
) -> list[dict]:
    """Generate order items linked to an order."""
    # logger.info("Generating order_items")
    order_items = []
    seller_id = random.randint(1, n_sellers)
    shipping_limit_date = (
        delivered_carrier_date + timedelta(days=random.randint(-1, 3))
        if delivered_carrier_date
        else None
    )
    for idx, product in enumerate(products_list):
        multiplier = random.uniform(0.09, 0.35)
        order_items.append(
            {
                "order_id": order_id,
                "order_item_id": idx,
                "product_id": product["product_id"],
                "seller_id": f"{seller_id:08d}",
                "shipping_limit_date": shipping_limit_date,
                "price": product["product_price"],
                "freight_value": round(product["product_price"] * multiplier, 2),
            }
        )
    return order_items


def generate_orders(
    products: list[dict], n_customers: int = N_CUSTOMERS, n_orders: int = N_ORDERS
) -> tuple[list[dict], list[dict]]:
    logger.info("Generating orders")
    orders = []
    all_order_items = []
    for index in range(n_orders):
        random_customer = random.randint(1, n_customers)
        status = random.choice(ORDER_STATUS)
        purchase_date = random_date()
        approved_at = delivered_carrier_date = estimated_delivery_date = (
            delivered_customer_date
        ) = None

        if status in [
            "created",
            "approved",
            "processing",
            "invoiced",
            "shipped",
            "delivered",
        ]:
            approved_at = purchase_date + timedelta(days=random.randint(0, 3))
        if status in ["shipped", "delivered"]:
            delivered_carrier_date = approved_at + timedelta(days=random.randint(1, 5))
        if status == "delivered":
            estimated_delivery_date = delivered_carrier_date + timedelta(
                days=random.randint(1, 3)
            )
            delivered_customer_date = estimated_delivery_date + timedelta(
                days=random.randint(0, 2)
            )
        if status in ["cancelled", "unavailable"]:
            approved_at = None
            delivered_carrier_date = None
            estimated_delivery_date = None

        order = {
            "order_id": f"{index+1:08d}",
            "customer_id": f"{random_customer:08d}",
            "order_status": status,
            "order_purchase_date": purchase_date,
            "order_approved_at": approved_at,
            "order_delivered_carrier_date": delivered_carrier_date,
            "order_delivered_customer_date": delivered_customer_date,
            "order_estimated_delivery_date": estimated_delivery_date,
        }
        orders.append(order)
        order_items = generate_order_items(
            order_id=f"{index+1:08d}",
            delivered_carrier_date=delivered_carrier_date,
            products_list=random.choices(products, k=random.randint(1, 5)),
        )
        all_order_items.extend(order_items)

    return orders, all_order_items


# --------------------------------------------------------------------------------
# Main Execution
# --------------------------------------------------------------------------------
if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Generate synthetic e-commerce datasets."
    )
    parser.add_argument(
        "--output_dir",
        type=str,
        default="/data",
        help="Directory where CSV files will be saved.",
    )
    parser.add_argument(
        "--customers",
        type=int,
        default=N_CUSTOMERS,
        help="Number of customers to generate.",
    )
    parser.add_argument(
        "--sellers", type=int, default=N_SELLERS, help="Number of sellers to generate."
    )
    parser.add_argument(
        "--orders", type=int, default=N_ORDERS, help="Number of orders to generate."
    )
    args = parser.parse_args()
    os.makedirs(args.output_dir, exist_ok=True)

    path = Path(args.output_dir)

    logger.info("Synthetic data generating started")

    product_category = generate_product_category()
    products = generate_products(product_category)
    customers = generate_customers(n_customers=args.customers)
    sellers = generate_sellers(n_sellers=args.sellers)
    orders, order_items = generate_orders(
        products, n_customers=args.customers, n_orders=args.orders
    )
    logger.info("Synthetic data generating completed")

    logger.info(f"Saving data to disk at {path} directory")
    pd.DataFrame(product_category).to_csv(path / "product_category.csv", index=False)
    pd.DataFrame(products).to_csv(path / "products.csv", index=False)
    pd.DataFrame(customers).to_csv(path / "customers.csv", index=False)
    pd.DataFrame(sellers).to_csv(path / "sellers.csv", index=False)
    pd.DataFrame(orders).to_csv(path / "orders.csv", index=False)
    pd.DataFrame(order_items).to_csv(path / "order_items.csv", index=False)
    logger.info(f"Saving data to disk completed")
