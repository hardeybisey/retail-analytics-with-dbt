import argparse
import logging
import os
import random
from concurrent.futures import ProcessPoolExecutor, as_completed
from datetime import date, timedelta
from itertools import product
from pathlib import Path

import pandas as pd
from faker import Faker

# --------------------------------------------------------------------------------
# Logging Configuration
# --------------------------------------------------------------------------------
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    handlers=[logging.StreamHandler()],
)
logger = logging.getLogger(name="generator")

# --------------------------------------------------------------------------------
# Configuration
# --------------------------------------------------------------------------------
N_SELLERS = 500
N_CUSTOMERS = 5_000
N_ORDERS = 10_000
LOCALE = "en_US"

fake = Faker(LOCALE)
Faker.seed(42)
random.seed(42)

ORDER_STATUS = [
    "PROCESSING",
    "APPROVED",
    "SHIPPED",
    "DELIVERED",
]

BOX_CATALOGUE = {
    "general_purpose": [
        "Boxify Classic",
        "Stow Mate",
        "Neat Nest",
        "Tidy Vault",
        "Cubix Hold",
    ],
    "premium": [
        "Luxe Fold",
        "Velari Box",
        "Monobox Signature",
        "EvoCrate",
        "Silhouette Box",
    ],
    "eco_friendly": [
        "Green Pack",
        "Eco Nest Crate",
        "ReLeaf Box",
        "Earth Fold",
        "Bio Box",
    ],
    "heavy_duty": ["Haul Pro", "Strong Stash", "Load Boxer", "Transit Max", "Grip Box"],
    "gift_decorative": [
        "Charm Crate",
        "Gifty Glow",
        "Wrap Nest",
        "Aura Box",
        "Velvet Case",
    ],
    "flatpack_stackable": [
        "Stack Right",
        "Fold Box",
        "Slim Nest",
        "Snap Crate",
        "Quick Stack",
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


# --------------------------------------------------------------------------------
# Data Generation Functions
# --------------------------------------------------------------------------------
def random_date(start=date(2020, 1, 1), end=date(2024, 12, 31)) -> date:
    """Generate a random date between `start` and `end`"""
    delta_seconds = int((end - start).total_seconds())
    return start + timedelta(seconds=random.randint(0, delta_seconds))


def generate_products() -> list[dict]:
    logger.info("Generating products")
    products = []
    product_id = 1
    for category, names in BOX_CATALOGUE.items():
        for product_name, (size_label, dimensions) in product(names, BOX_SIZES.items()):
            price = round(
                SIZE_BASE_PRICE[size_label] * CATEGORY_PRICE_MULTIPLIER[category], 2
            )
            products.append(
                {
                    "product_id": f"{product_id:08d}",
                    "product_category": category,
                    "product_name": product_name,
                    "product_size_label": size_label,
                    "product_width_cm": dimensions["width"],
                    "product_length_cm": dimensions["length"],
                    "product_height_cm": dimensions["height"],
                    "product_price": price,
                    "product_created_date": date(2020, 1, 1),
                    "product_updated_date": None,
                }
            )
            product_id += 1
    return products


def generate_customers(n_customers: int = N_CUSTOMERS) -> dict:
    logger.info("Generating customers")
    customers = {}
    states = [fake.state_abbr() for _ in range(n_customers)]
    for i in range(n_customers):
        state_abbr = states[i]
        cid = f"{i + 1:08d}"
        customers[cid] = {
            "customer_id": cid,
            "customer_address": fake.street_address(),
            "customer_state": state_abbr,
            "customer_zip_code": fake.zipcode_in_state(state_abbr),
            "customer_created_date": random_date(end=date(2023, 12, 31)),
            "customer_updated_date": None,
        }
    return customers


def generate_sellers(n_sellers: int = N_SELLERS) -> dict:
    logger.info("Generating sellers")
    sellers = {}
    states = [fake.state_abbr() for _ in range(n_sellers)]
    for i in range(n_sellers):
        sid = f"{i + 1:08d}"
        sellers[sid] = {
            "seller_id": sid,
            "seller_address": fake.street_address(),
            "seller_state": states[i],
            "seller_zip_code": fake.zipcode_in_state(states[i]),
            "seller_created_date": random_date(end=date(2023, 7, 31)),
            "seller_updated_date": None,
        }
    return sellers


def generate_order_items(
    order_id: str,
    shipping_limit_date: date,
    products_list: list[dict],
    seller_id: str,
) -> list[dict]:
    """Generate order items linked to an order."""
    return [
        {
            "order_id": order_id,
            "order_item_id": idx,
            "product_id": p["product_id"],
            "seller_id": seller_id,
            "shipping_limit_date": shipping_limit_date,
            "price": p["product_price"],
            "freight_value": round(p["product_price"] * random.uniform(0.09, 0.35), 2),
        }
        for idx, p in enumerate(products_list)
    ]


def _generate_orders(
    customers: dict[str, dict],
    sellers: pd.DataFrame,
    products: list[dict],
    order_start_id: int,
    order_end_id: int,
) -> tuple[list[dict], list[dict]]:
    logger.info(
        f"Generating orders from {order_start_id} to {order_end_id} on PID {os.getpid()}"
    )
    orders = []
    all_order_items = []
    customer_ids = list(customers.keys())

    for idx in range(order_start_id, order_end_id):
        customer_id = random.choice(customer_ids)
        status = random.choice(ORDER_STATUS)
        start_date = customers[customer_id]["customer_created_date"]

        # Ensure order date is after customer creation date
        purchase_date = random_date(start=start_date)

        # Ensure seller was created before purchase date
        valid_seller: str = (
            sellers[sellers["seller_created_date"] <= purchase_date]["seller_id"]
            .sample(1)
            .iat[0]
        )

        approved_at = estimated_delivery_date = delivered_carrier_date = (
            delivered_customer_date
        ) = None

        if status in (
            "APPROVED",
            "SHIPPED",
            "DELIVERED",
        ):
            approved_at = purchase_date + timedelta(days=random.randint(0, 1))
        if status in ("SHIPPED", "DELIVERED"):
            estimated_delivery_date = approved_at + timedelta(days=random.randint(1, 3))
        if status == "DELIVERED":
            delivered_carrier_date = estimated_delivery_date + timedelta(
                days=random.randint(1, 2)
            )
            delivered_customer_date = estimated_delivery_date + timedelta(
                days=random.randint(0, 2)
            )

        order_id = f"{idx + 1:08d}"
        orders.append(
            {
                "order_id": order_id,
                "customer_id": customer_id,
                "order_status": status,
                "order_purchase_date": purchase_date,
                "order_approved_at": approved_at,
                "order_delivered_carrier_date": delivered_carrier_date,
                "order_delivered_customer_date": delivered_customer_date,
                "order_estimated_delivery_date": estimated_delivery_date,
            }
        )

        base_date = delivered_carrier_date or approved_at or purchase_date

        order_items = generate_order_items(
            order_id=order_id,
            shipping_limit_date=base_date + timedelta(days=random.randint(-1, 3)),
            products_list=random.choices(products, k=random.randint(1, 5)),
            seller_id=valid_seller,
        )
        all_order_items.extend(order_items)

    return orders, all_order_items


def generate_orders_threaded(
    customers: dict[str, dict],
    sellers: pd.DataFrame,
    products: list[dict],
    n_orders: int = N_ORDERS,
    n_threads: int = 4,
) -> tuple[list[dict], list[dict]]:
    """Generate orders using multiple threads."""
    logger.info(f"Generating {n_orders} orders using {n_threads} threads")
    orders = []
    all_order_items = []
    futures = []
    with ProcessPoolExecutor(max_workers=n_threads) as executor:
        orders_per_thread = n_orders // n_threads
        for i in range(n_threads):
            start_id = i * orders_per_thread
            end_id = (i + 1) * orders_per_thread
            futures.append(
                executor.submit(
                    _generate_orders, customers, sellers, products, start_id, end_id
                )
            )

        for future in as_completed(futures):
            thread_orders, thread_order_items = future.result()
            orders.extend(thread_orders)
            all_order_items.extend(thread_order_items)

    return orders, all_order_items


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
    parser.add_argument(
        "--format", type=str, default="csv", help="Output file format (csv or parquet)."
    )
    args = parser.parse_args()

    path = Path(args.output_dir)
    path.mkdir(parents=True, exist_ok=True)

    logger.info("Synthetic data generation started")
    products = generate_products()
    customers = generate_customers(n_customers=args.customers)
    sellers = pd.DataFrame(generate_sellers(n_sellers=args.sellers).values())
    orders, order_items = generate_orders_threaded(
        customers, sellers, products, args.orders, n_threads=os.cpu_count() or 4
    )

    logger.info("Synthetic data generation completed")
    logger.info(f"Saving data to {path}")

    if args.format == "parquet":
        pd.DataFrame(products).to_parquet(path / "products.parquet", index=False)
        pd.DataFrame(customers.values()).to_parquet(
            path / "customers.parquet", index=False
        )
        sellers.to_parquet(path / "sellers.parquet", index=False)
        pd.DataFrame(orders).to_parquet(path / "orders.parquet", index=False)
        pd.DataFrame(order_items).to_parquet(path / "order_items.parquet", index=False)
    else:
        pd.DataFrame(products).to_csv(path / "products.csv", index=False)
        pd.DataFrame(customers.values()).to_csv(path / "customers.csv", index=False)
        sellers.to_csv(path / "sellers.csv", index=False)
        pd.DataFrame(orders).to_csv(path / "orders.csv", index=False)
        pd.DataFrame(order_items).to_csv(path / "order_items.csv", index=False)

    logger.info("Data saved successfully")
