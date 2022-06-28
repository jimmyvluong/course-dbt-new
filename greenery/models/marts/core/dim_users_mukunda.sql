{{
    config(materialized='table',
			post_hook="{{create_index(this, ['user_id','country'], ['first_name','last_name'])}}")
    }}

select
	su.user_id ,
	su.first_name ,
	su.last_name ,
	sa.state ,
	sa.country ,
	sa.zipcode
from
	{{ref("stg_greenery__users")}} su
join {{ref("stg_greenery__addresses")}} sa on
	sa.address_id = su.address_id