
{{
  config(
    materialized = 'table'
  )
}}

select 
    dim_users_addresses.user_id
    , dim_users_addresses.first_name
    , dim_users_addresses.last_name
    , dim_users_addresses.email
    , dim_users_addresses.phone_number
    , dim_users_addresses.user_created_at_utc
    , dim_users_addresses.user_updated_at_utc
    , dim_users_addresses.address_id
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
    , dim_users_addresses.address
    , dim_users_addresses.zipcode
    , dim_users_addresses.state
    , dim_users_addresses.country
from {{ ref('dim_users_addresses') }}
left join {{ ref('int_orders_promos') }}
on dim_users_addresses.user_id = int_orders_promos.user_id