
{{
  config(
    materialized = 'table'
  )
}}

SELECT
    SUM(checkout) as checkout_count
  , SUM(add_to_cart) as add_to_cart_count
  , SUM(page_view) as page_view_count
  , ROUND((SUM(add_to_cart::numeric)/SUM(page_view::numeric)),2) as add_to_cart_rate
  , ROUND((SUM(checkout::numeric)/SUM(add_to_cart::numeric)),2) as checkout_rate
  FROM {{ ref('int_session_events_agg_user') }}