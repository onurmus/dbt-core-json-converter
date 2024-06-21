-- models/json_to_table.sql

-- Step 1: Extract JSON Keys
{% set keys_query %}
    SELECT DISTINCT jsonb_object_keys(_airbyte_data) AS key
    FROM public.onur_generic_test
{% endset %}

{% set keys_result = run_query(keys_query) %}

{% if execute %}
{% set columns = keys_result.columns[0].values() %}
{% else %}
{% set columns = [] %}
{% endif %}


-- Step 3: Construct Final SQL
WITH  flattened_data AS (
    SELECT
        _airbyte_ab_id,
        {% for column in columns %}
        _airbyte_data->>'{{ column }}' AS {{ column }}{% if not loop.last %},{% endif %}
        {% endfor %}
    FROM public.onur_generic_test
)

SELECT * FROM flattened_data