-- For any session was there an event_type of any of the 4 event_types? If yes, make a 1 flag.

{{
  config(
    materialized = 'table'
  )
}}
SELECT
  stg_greenery__events.session_id
  , stg_greenery__events.user_id
  , dim_users_addresses.zipcode
  , dim_users_addresses.state
  , dim_users_addresses.country
  , MAX(CASE WHEN stg_greenery__events.event_type = 'add_to_cart' then 1 else 0 end) AS add_to_cart
  , MAX(CASE WHEN stg_greenery__events.event_type = 'checkout' then 1 else 0 end) AS checkout
  , MAX(CASE WHEN stg_greenery__events.event_type = 'page_view' then 1 else 0 end) AS page_view
  , MAX(CASE WHEN stg_greenery__events.event_type = 'package_shipped' then 1 else 0 end) AS package_shipped
FROM {{ ref('stg_greenery__events') }}
LEFT JOIN {{ ref('dim_users_addresses') }}
ON stg_greenery__events.user_id = dim_users_addresses.user_id
GROUP BY 1,2,3,4,5