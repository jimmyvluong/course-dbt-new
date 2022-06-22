
{{
  config(
    materialized = 'table'
  )
}}

select 
    dim_users.user_id
    , dim_users.first_name
    , dim_users.last_name
    , dim_users.email
    , dim_users.phone_number
    , dim_users.user_created_at_utc
    , dim_users.user_updated_at_utc
    , dim_users.address_id
    , int_orders_promos.order_id
    , int_orders_promos.order_created_at_utc
    , int_orders_promos.order_cost
    , int_orders_promos.shipping_cost
    , int_orders_promos.order_total
    , int_orders_promos.tracking_id
    , int_orders_promos.shipping_service
    , int_orders_promos.order_estimated_delivery_at_utc
    , int_orders_promos.order_delivered_at_utc
    , int_orders_promos.order_status
    , int_orders_promos.has_promo_applied
    , int_orders_promos.promo_active_status
    , dim_users.address
    , dim_users.zipcode
    , dim_users.state
    , dim_users.country
from {{ ref('dim_users') }}
left join {{ ref('int_orders_promos') }}
on dim_users.user_id = int_orders_promos.user_id