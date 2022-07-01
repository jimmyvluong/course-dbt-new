-- For any session was there an event_type of any of the 4 event_types? If yes, make a 1 flag.
SELECT
  stg_greenery__events.session_id
  ---, stg_greenery__events.event_id
  --, created_at_utc
  --, stg_greenery__events.product_id
  --, stg_greenery__products.product_name
  , MAX(CASE WHEN stg_greenery__events.event_type = 'add_to_cart' then 1 else 0 end) AS add_to_cart
  , MAX(CASE WHEN stg_greenery__events.event_type = 'checkout' then 1 else 0 end) AS checkout
  , MAX(CASE WHEN stg_greenery__events.event_type = 'page_view' then 1 else 0 end) AS page_view
  , MAX(CASE WHEN stg_greenery__events.event_type = 'package_shipped' then 1 else 0 end) AS package_shipped
FROM {{ ref('stg_greenery__events') }}
GROUP BY 1;