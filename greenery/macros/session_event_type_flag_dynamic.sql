-- query for all unique event_type
-- ~ is string concatenation in Jinja
{% set event_types = dbt_utils.get_query_results_as_dict(
    "select DISTINCT event_type from" ~ ref('stg_greenery__events')) 
%}
# {# This macro returns a dictionary of the form {column_name: (tuple_of_results)} #}

--- This is what the dictionary looks like
--- "event_type": ("page_view", "add_to_cart", "checkout" ...)
for
    session_id
    -- get the event_type KEY from event_types using "event_types['event_type']"
    -- remember that all dictionaries have KEY:VALUE pairs
    -- so here we are looping through the tuple of ("page_view", "add_to_cart", "checkout" ...)
    {% for event_type in event_types['event_type'] %}
        , MAX(case when event_type = '{{event_type}}' then 1 else 0 end) as {{event_type}}_present,
    {% endfor %}
from {{ ref('stg_greenery__events') }}
group by session_id


