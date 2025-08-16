-- This macro generates a schema name based on the provided custom schema name or defaults to the target schema.
{% macro generate_schema_name(custom_schema_name, node) -%}

   {%- set default_schema = target.schema -%}
   {%- if custom_schema_name is none -%}

       {{ default_schema }}

   {%- else -%}

       {{ custom_schema_name | trim }}

   {%- endif -%}

{%- endmacro %}
