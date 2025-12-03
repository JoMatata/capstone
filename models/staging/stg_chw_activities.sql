-- models/staging/stg_chw_activities.sql
WITH source AS (
    SELECT * FROM {{ ref('chw_activities_sample') }}
    WHERE chv_id IS NOT NULL
      AND activity_date IS NOT NULL
      AND (is_deleted IS NULL OR is_deleted = FALSE)
)

SELECT
    chv_id,
    activity_date::date as activity_date,
    household_id,
    patient_id,
    activity_type,
    {{ month_assignment('activity_date') }} AS report_month
FROM source
