{% macro month_assignment(date_column) %}
    CASE
        WHEN EXTRACT(DAY FROM {{ date_column }}) < 26 
        THEN DATE_TRUNC('month', {{ date_column }})
        ELSE DATE_TRUNC('month', {{ date_column }} + INTERVAL '1 month')
    END
{% endmacro %}
