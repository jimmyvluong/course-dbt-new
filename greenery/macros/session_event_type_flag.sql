{% set event_types = dbt_utils.get_query_results_as_dict(
    "select DISTINCT event_type from" ~ ref('stg_greenery__events')) 
%}


--- This is what the dictionary looks like
--- "event_type": ("page_view", "add_to_cart", "checkouout" ...)
for
    session_id
    {% for event_type in event_types['event_type'] %}
        , MAX(case when event_type = '{{event_type}}' then 1 else 0 end) as {{event_type}}_present,
    {% endfor %}
from {{ ref('stg_greenery__events') }}
group by session_id


