# Synthetic E-commerce Data Generator

This project provides a simple data generator using Python with `Faker` and `pandas`. It creates realistic but fake data for customers, sellers, products, product categories, orders, and order items.

---

## Generated Datasets

The script generates the following CSV files in the output directory:

2. **`products.csv`** -  Detailed product catalogue with category, dimensions, size, and price.
3. **`customers.csv`** - Fake customers with addresses, states, and signup dates.
4. **`sellers.csv`** - Fake sellers with addresses and registration dates.
5. **`orders.csv`** - Orders with statuses, timestamps, and customer references.
6. **`order_items.csv`** - Items linked to orders, products, and sellers with freight costs.

---

## Usage
1. Build the Docker image
    From the project root (where the `Dockerfile` is located), Run:
    ```bash
    docker build -t ecommerce-data-generator .
    ```

2. Generate datasets:
   This comand runs the generator and store the result in a data folder in the current directory.
   ```bash
   # This runs the data-generator and stores the result in a csv format
   docker run --rm -v $(pwd)/data:/data ecommerce-data-generator

   # To customise the number of data generated and format, use
   docker run --rm -v $(pwd)/csv_data:/data ecommerce-data-generator --customers n --sellers n --orders n --format `(parquet/csv)`
   ```

### Arguments

| Argument       | Type | Default | Description                           |
| -------------- | ---- | ------- | ------------------------------------- |
| `--output_dir` | str  | `.`     | Directory to save generated CSV files |
| `--customers`  | int  | 5000    | Number of customers to generate       |
| `--sellers`    | int  | 500     | Number of sellers to generate         |
| `--orders`     | int  | 10000   | Number of orders to generate          |
| `--format`     | str  | csv     | output file format (csv, parquet)     |

---
