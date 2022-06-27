{{
  config(
    materialized = 'table'
  )
}}
SELECT
  product_id
  , ROUND(SUM(add_to_cart) / count(distinct session_id),2) AS product_conversion_rate
  FROM {{ ref('int_session_events_agg') }} 
  GROUP BY 1