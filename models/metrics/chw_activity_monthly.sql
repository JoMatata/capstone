-- models/metrics/chw_activity_monthly.sql
{{
    config(
        materialized='incremental',
        unique_key=['chv_id', 'report_month'],
        on_schema_change='fail'
    )
}}

WITH staged AS (
    SELECT * FROM {{ ref('stg_chw_activities') }}
    {% if is_incremental() %}
    WHERE report_month >= (
        SELECT DATE_TRUNC('month', MAX(report_month) - INTERVAL '2 months')
        FROM {{ this }}
    )
    {% endif %}
)

SELECT
    chv_id,
    report_month,
    COUNT(*) AS total_activities,
    COUNT(DISTINCT household_id) AS unique_households_visited,
    COUNT(DISTINCT patient_id) AS unique_patients_served,
    COUNT(CASE WHEN activity_type = 'pregnancy_visit' THEN 1 END) AS pregnancy_visits,
    COUNT(CASE WHEN activity_type = 'child_assessment' THEN 1 END) AS child_assessments,
    COUNT(CASE WHEN activity_type = 'family_planning' THEN 1 END) AS family_planning_visits
FROM staged
GROUP BY chv_id, report_month
