{{
  config(
    materialized = 'table'
  )
}}
SELECT ROUND(SUM(checkout)/COUNT(distinct session_id),2) AS conversion_rate
FROM {{ ref('int_session_events_agg') }} 