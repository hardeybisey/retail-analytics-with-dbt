{{ config(tags = ['products']) }}
with product_base as (

    select
        product_id,
        photos_qty,
        weight_g,
        length_cm,
        height_cm,
        width_cm,
        category_name,
        {{ dbt_utils.generate_surrogate_key(["product_id"]) }} as product_key
    from {{ ref('stg_products') }}
),

category_translation as (

    select
        category_name,
        category_name_english
    from {{ ref('stg_product_category_name_translation') }}
)

select
    pb.product_key,
    pb.product_id,
    pb.photos_qty,
    pb.weight_g,
    pb.length_cm,
    pb.height_cm,
    pb.width_cm,
    pb.category_name,
    ct.category_name_english
from product_base as pb
left join category_translation as ct on pb.category_name = ct.category_name
