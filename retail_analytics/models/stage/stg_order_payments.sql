{{ config(tags = ['orders']) }}
with source as (

    select * from {{ source('csv_input', 'olist_order_payments') }}

),

renamed as (

    select
        order_id,
        payment_sequential::integer as sequence_id,
        payment_installments::integer as num_of_installments,
        payment_value::float as amount,
        upper(payment_type) as payment_type

    from source

)

select * from renamed
