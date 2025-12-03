-- Test: No report months should be more than 1 month in the future
-- This aims to catch incorrect date assignment

select
    chv_id,
    report_month,
    current_date as today,
    date_trunc('month', current_date + interval '1 month')::date as max_allowed_month
from {{ ref('chw_activity_monthly') }}
where report_month > date_trunc('month', current_date + interval '1 month')::date
-- Should return 0 rows