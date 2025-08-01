{{

    config(
        materialized='incremental',
        tags = ['customers'],
        unique_key = 'customer_key',
        on_schema_change = 'fail',
        incremental_strategy='merge',

    )
}}
WITH
{% if not is_incremental() %}
first_order_date as (
    select
        customer_id,
        min(order_timestamp) as first_order_date
    from {{ ref('stg_orders') }}
    group by customer_id
),
{% endif %}
snapshots AS (

    SELECT *
    FROM {{ ref('snapshot_customers') }} s
    {% if is_incremental() %}
        WHERE s.dbt_modified_date > (SELECT max(t.dbt_modified_date) FROM {{ this }} AS t)
    {% endif %}

),

dim AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(["s.customer_id", "s.valid_from"]) }} AS customer_key,
        s.customer_id,
        s.customer_unique_id,
        r.region_key,
        -- We are doing this because the valid_from and valid_to provided by the snapshot are generated
        -- based on the first model run, which doesn't align with our order table's timestamps.
        -- In a real-world scenario, a customer must have existed before they placed their first order.
        {% if is_incremental() %}
            s.valid_from,
            s.valid_to,

        {% else %}
        fod.first_order_date as valid_from,
        null::timestamp as valid_to,
        {% endif %}

        (s.valid_to IS null) AS is_current,
        s.dbt_modified_date

    FROM snapshots AS s
    LEFT JOIN {{ ref('dim_region') }} AS r ON s.zip_code_prefix = r.zip_code_prefix
    {% if not is_incremental() %}
    left join  first_order_date as fod on fod.customer_id = s.customer_id
    {% endif %}

)

SELECT * FROM dim
