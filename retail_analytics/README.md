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

# Generate model yaml files for all defined sources
dbt --quiet run-operation generate_source --args '{"schema_name": "csv_input", "generate_columns": true, "include_descriptions": true}' > `your_source_file_name.yml`

# Generate sql files for base model for each defined sources
dbt --quiet run-operation generate_base_model --args '{"source_name": "csv_input", "table_name": "order_items"}' > order_items.sql

# Generate model yaml files for a list of models. Note: The models must have been materialised for this command to work.
dbt --quiet run-operation generate_model_yaml --args '{"include_data_types":true, "upstream_descriptions":true, "model_names": ["snapshot_customer","snapshot_products", "snapshot_sellers"]}' > `your_source_file_name.yml`
```
