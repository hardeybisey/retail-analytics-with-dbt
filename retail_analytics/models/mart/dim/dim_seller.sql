{{

    config(
        tags = ['seller'],
    )
}}
SELECT
    {{ dbt_utils.generate_surrogate_key(["s.seller_id", "s.dbt_valid_from"]) }} AS seller_key,
    s.seller_id,
    s.address,
    s.state,
    s.zip_code_prefix,
    s.dbt_valid_from::date AS valid_from_date,
    s.dbt_valid_to::date AS valid_to_date,
    (s.dbt_valid_to IS null) AS is_current
FROM {{ ref('snapshot_sellers') }} AS s
