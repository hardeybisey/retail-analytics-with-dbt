{{ config(tags = ['products']) }}

with source as (

    select * from {{ source('csv_input', 'product_category_name_translation') }}

),

renamed as (

    select
        upper(product_category_name) as category_name,
        upper(product_category_name_english) as category_name_english

    from source

)

select * from renamed
