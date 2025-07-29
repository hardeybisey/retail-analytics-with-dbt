{{

    config(
        materialized='incremental',
        tags = ['sellers'],
        unique_key = 'seller_key',
        on_schema_change = 'fail',
        incremental_strategy='merge',
    )
}}
WITH
{% if not is_incremental() %}
first_order_date as (
    select
        seller_id,
        min(order_timestamp) as first_order_date
    from {{ ref('int_order_items') }}
    group by seller_id
),
{% endif %}
snapshots AS (

    SELECT *
    FROM {{ ref('snapshot_sellers') }}

),

dim AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(["s.seller_id", "s.valid_from"]) }} AS seller_key,
        s.seller_id,
        s.zip_code_prefix,
        s.city,
        s.state,
        -- We are doing this because the valid_from and valid_to provided by the snapshot are generated
        -- based on the first model run, which doesn't align with our order table's timestamps.
        -- In a real-world scenario, a seller must have existed before they fulfil their first order.
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
    {% if not is_incremental() %}
    left join  first_order_date as fod on fod.seller_id = s.seller_id
    {% endif %}

    {% if is_incremental() %}
        WHERE s.dbt_modified_date > (SELECT max(t.dbt_modified_date) FROM {{ this }} AS t)
    {% endif %}
)

SELECT * FROM dim
