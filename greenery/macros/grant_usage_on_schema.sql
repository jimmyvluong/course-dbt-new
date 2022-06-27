{% macro grant_usage_on_schema(schema, role) %}
    grant usage on schema {{ schema }} to group {{ role }};
    grant select on all tables in schema {{ schema }} to group {{ role }};
{% endmacro %}