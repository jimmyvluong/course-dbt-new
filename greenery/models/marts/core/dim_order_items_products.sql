-- not sure if this model is useful right now
{{
  config(
    materialized = 'table'
  )
}}

select 
    stg_greenery__products.product_id
    , stg_greenery__products.product_name
    , stg_greenery__products.price
    , stg_greenery__products.inventory
    , stg_greenery__order_items.order_id
    , stg_greenery__order_items.order_quantity
from {{ ref('stg_greenery__order_items') }}
left join {{ ref('stg_greenery__products') }}
on stg_greenery__order_items.product_id = stg_greenery__products.product_id