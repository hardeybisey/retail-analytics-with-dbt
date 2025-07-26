{{ config(tags = ['orders']) }}
with source as (

    select * from {{ source('csv_input', 'olist_order_payments') }}

),

renamed as (

    select
        order_id,
        payment_sequential::integer as payment_sequential_id,
        payment_installments::integer as installments,
        payment_value::float as payment_value,
        upper(payment_type) as payment_type

    from source

)

select * from renamed
