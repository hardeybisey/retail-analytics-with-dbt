## Retail Analytics with DBT

This purpose of this project is to develop an analytics data warehouse for an E-commerce store. The model developed will be iterated over
using different tools and technology.

The field of Analytics and Data Engineering is fast moving, and often times being able to solve the same problem using different approach is a skill that has a log of benefits. The idea behing this project is to answer the same analytics questions using different approaches, tools, and technology.

This project is intended for my personal development but I will be documenting it so anyone can pick up the project and learn from it.

This same dataset is used in the following projects:
- [Retail Analytics with SQLMesh](https://github.com/cnstlungu/portable-data-stack-sqlmesh)
- [Retail Analytics with Airflow](https://github.com/cnstlungu/portable-data-stack-dagster)
- [Retail Analytics with Spark](https://github.com/cnstlungu/portable-data-stack-dagster)
- [Retail Analytics with Dataflow](https://github.com/cnstlungu/portable-data-stack-dagster)


### Project Technology Stack
* [Docker](https://docs.docker.com/engine/install/)
* [DBT](https://docs.docker.com/engine/install/)
* [DuckDB](https://docs.docker.com/engine/install/)
* [Superset](https://docs.docker.com/engine/install/)

---

**Link to full information and source of the dataset is [here](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce/code)**

---
### Data Context
The dataset contains real commercial data from Olist, the largest department store in Brazilian marketplaces. It includes information from nearly 100,000 orders placed between 2016 and 2018. The data is anonymized and covers various aspects of the e-commerce lifecycle.

### **Data Schema**
![](images/HRhd2Y0.png)

---

## **Data Dictionary**

### 1. **Customers Dataset**

This dataset contains information about the customer and their location. It can be used to identify unique customers in the orders dataset and to determine the delivery location of orders.

**Key Point:** In this system, each order is assigned a unique `customer_id`. This means the same customer will have different IDs for different orders. The `customer_unique_id` is provided to allow for the identification of customers who have made repeat purchases.

---

### 2. **Geolocation Dataset**

This dataset includes Brazilian zip codes and their corresponding latitude and longitude coordinates. It is useful for plotting maps and calculating distances between sellers and customers.

---

### 3. **Order Items Dataset**

This dataset contains data about the items purchased within each order.

**Example:**

An order with `order_id = 00143d0f86d6fbd9f9b38ab440ac16f5` contains 3 of the same product. The freight for each item is calculated based on its measurements and weight.

*   **Total Order Item Value:** `21.33 * 3 = 63.99`
*   **Total Freight Value:** `15.10 * 3 = 45.30`
*   **Total Order Value (Product + Freight):** `45.30 + 63.99 = 109.29`

---

### 4. **Payments Dataset**

This dataset includes information about the payment methods used for each order.

---

### 5. **Order Reviews Dataset**

This dataset contains information about customer reviews.

After a customer makes a purchase from the Olist Store, a seller is notified to fulfill the order. Once the customer receives the product, or the estimated delivery date has passed, the customer receives a satisfaction survey via email. In this survey, they can rate their purchase experience and provide written comments.

---

### 6. **Order Dataset**

This is the core dataset. From each order, you can find all other related information.

---

### 7. **Products Dataset**

This dataset includes data about the products sold by Olist.

---

### 8. **Sellers Dataset**

This dataset contains information about the sellers who fulfilled orders placed on Olist. It can be used to find the seller's location and to identify which seller fulfilled each product order.

---

### 9. **Category Name Translation**

This dataset translates the `product_category_name` to English.

---
### Getting started
---
### Setting up the project
---
### Running the dbt model
---


## Credits
This project was inspired by this [repo](https://github.com/cnstlungu/postcard-company-datamart)
