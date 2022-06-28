{% macro create_index(this, index_columns, include_columns)%}

    create index if not exists "Idx_{{this.name}}{%- for col in index_columns -%} _{{col}} {%- endfor -%}" on {{this}} 
    ({% for col in index_columns %} "{{col}}" {% if not loop.last %} , {% endif %} {% endfor %})

    {% if include_columns %} include
    ({% for col in include_columns %} "{{col}}" {% if not loop.last %} , {% endif %} {% endfor %})
    {% endif %}

{% endmacro %}