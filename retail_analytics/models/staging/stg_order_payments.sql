{{ config(tags = ['orders']) }}
WITH source AS (

    SELECT * FROM {{ source('csv_input', 'olist_order_payments') }}

),

renamed AS (

    SELECT
        order_id,
        payment_sequential::integer AS sequence_id,
        payment_installments::integer AS num_of_installments,
        payment_value::float AS amount,
        upper(payment_type) AS payment_type

    FROM source

)

SELECT * FROM renamed
