{{
    config(tags = ['payment'])
}}
WITH base AS (
    SELECT
        *,
        {{ dbt_utils.generate_surrogate_key(['order_id', 'sequence_id']) }} AS payment_key
    FROM {{ ref('stg_order_payments') }}
)

SELECT
    b.payment_key,
    o.order_key,
    b.sequence_id,
    b.payment_type,
    b.num_of_installments,
    b.amount
FROM base AS b
LEFT JOIN {{ ref('fact_orders') }} AS o ON b.order_id = o.order_id
