{{ config(tags = ['orders']) }}
WITH source AS (

    SELECT * FROM {{ source('csv_input', 'olist_order_payments') }}

),

deduplicated_order_payments AS (

    SELECT
        order_id,
        payment_sequential::integer AS sequence_id,
        payment_installments::integer AS num_of_installments,
        payment_value::float AS amount,
        row_number() OVER (PARTITION BY order_id, payment_sequential) AS row_num,
        upper(payment_type) AS payment_type

    FROM source

)

SELECT * FROM deduplicated_order_payments
WHERE row_num = 1
