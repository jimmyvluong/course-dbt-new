{{
  config(
    materialized = 'table'
  )
}}

select 
    stg_greenery__users.user_id
    , stg_greenery__users.first_name
    , stg_greenery__users.last_name
    , stg_greenery__users.email
    , stg_greenery__users.phone_number
    , stg_greenery__users.user_created_at_utc
    , stg_greenery__users.user_updated_at_utc
    , stg_greenery__users.address_id
    , stg_greenery__addresses.address
    , stg_greenery__addresses.zipcode
    , stg_greenery__addresses.state
    , stg_greenery__addresses.country
from {{ ref('stg_greenery__users') }}
left join {{ ref('stg_greenery__addresses') }}
on stg_greenery__users.address_id = stg_greenery__addresses.address_id