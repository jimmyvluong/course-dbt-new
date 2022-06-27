{{
  config(
    materialized = 'table'
  )
}}

SELECT
  stg_greenery__events.session_id
  , stg_greenery__events.user_id
  --, created_at_utc
  , stg_greenery__events.product_id
  , stg_greenery__products.product_name
  , SUM(CASE WHEN stg_greenery__events.event_type = 'add_to_cart' then 1 else 0 end) AS add_to_cart
  , SUM(CASE WHEN stg_greenery__events.event_type = 'checkout' then 1 else 0 end) AS checkout
  , SUM(CASE WHEN stg_greenery__events.event_type = 'page_view' then 1 else 0 end) AS page_view
  , SUM(CASE WHEN stg_greenery__events.event_type = 'package_shipped' then 1 else 0 end) AS package_shipped
FROM {{ ref('stg_greenery__events') }}
left join {{ ref('stg_greenery__products') }}
on stg_greenery__events.product_id = stg_greenery__products.product_id
GROUP BY 1,2,3,4
