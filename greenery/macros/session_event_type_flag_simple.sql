
-- Set this event_types variable equal to ["1", "2", "3"] etc.
{% set event_types = ["page_view", "add_to_cart", "checkout"] %}

-- for each session_id
for
    session_id
    -- for each of the 3 event_type
    { for event_type in event_types %}
    -- when the event_type is the event_type in the variable, make a 1 flag
        , MAX(case when event_type = '{{event_type}}' then 1 else 0 end) as {{event_type}}_present,
    {% endfor %}
from {{ ref('stg_events') }}
-- then group by session_id
group by session_id

-- what it looks like
-- session_id, page_view_present, add_to_cart_present, checkout_present