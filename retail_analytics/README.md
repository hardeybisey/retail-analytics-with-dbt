Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices


### Generating source (Note:This doesn't work with duckdb)
```bash
# generating source yaml fine from the current target. more info at https://hub.getdbt.com/dbt-labs/codegen/latest/
dbt --quiet run-operation generate_source --args '{"schema_name": "name", "generate_columns": true, "include_descriptions": true}' > models/_sources.yml

# generating base model from the current sources.
dbt --quiet run-operation generate_base_model --args '{"source_name": "csv_input", "table_name": "table_name"}' > <path-to-save/file-name>.sql

# generqte model yaml.
dbt run-operation generate_model_yaml --args '{"include_data_types":true, "upstream_descriptions":true, "model_names": ["raw_customers","raw_geolocation", "raw_order_items","raw_order_payments","raw_order_reviews","raw_orders","raw_products","raw_sellers", "raw_product_category_name_translation"]}'

# dbt run-operation codegen.create_base_models --args '{source_name: my-source, tables: ["olist_customers","olist_geolocation", "olist_order_items","olist_order_payments","olist_order_reviews","olist_orders","olist_products","olist_sellers", "product_category_name_translation"]}'

# source dbt_packages/codegen/bash_scripts/base_model_creation.sh "csv_input"["olist_customers","olist_geolocation", "olist_order_items","olist_order_payments","olist_order_reviews","olist_orders","olist_products","olist_sellers", "product_category_name_translation"]
```
