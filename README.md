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


| Dataset Name              | Description                                                                                                                                                                                | Key Columns                                    |
|--------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------|
| **Customers**            | Contains customer information and location. Use `customer_id` to identify unique orders and `customer_unique_id` to identify repeat purchasers.                                            | `customer_id`, `customer_unique_id`, `customer_zip_code_prefix`, `customer_city`, `customer_state` |
| **Geolocation**          | Brazilian zip codes with latitude and longitude. Useful for mapping and distance calculations between customer and seller locations.                                                       | `geolocation_zip_code_prefix`, `geolocation_lat`, `geolocation_lng`, `geolocation_city`, `geolocation_state` |
| **Order Items**          | Data on each item within an order. Includes quantity, price, and freight for each item.                                                                                                    | `order_id`, `order_item_id`, `product_id`, `seller_id`, `shipping_limit_date`, `price`, `freight_value` |
| **Payments**             | Details payment methods used per order. Orders can have multiple payments using different methods.                                                                                         | `order_id`, `payment_sequential`, `payment_type`, `payment_installments`, `payment_value` |
| **Order Reviews**        | Customer reviews post-delivery or after the expected delivery date. Includes ratings and textual feedback.                                                                                 | `review_id`, `order_id`, `review_score`, `review_comment_title`, `review_comment_message`, `review_creation_date`, `review_answer_timestamp` |
| **Orders**               | Core dataset linking to all others. Represents individual purchases and delivery timelines.                                                                                                | `order_id`, `customer_id`, `order_status`, `order_purchase_timestamp`, `order_approved_at`, `order_delivered_carrier_date`, `order_delivered_customer_date`, `order_estimated_delivery_date` |
| **Products**             | Information about products sold. Includes name, category, and physical attributes.                                                                                                         | `product_id`, `product_category_name`, `product_name_lenght`, `product_description_lenght`, `product_photos_qty`, `product_weight_g`, `product_length_cm`, `product_height_cm`, `product_width_cm` |
| **Sellers**              | Data about sellers, including their location and identification. Used to trace product fulfilment.                                                                                         | `seller_id`, `seller_zip_code_prefix`, `seller_city`, `seller_state` |
| **Category Translation** | Translates original product categories (in Portuguese) to English.                                                                                                                          | `product_category_name`, `product_category_name_english` |

---
### Getting started
---
### Setting up the project
---
### Running the dbt model
---


## Credits
This project was inspired by this [repo](https://github.com/cnstlungu/postcard-company-datamart)
