-- Test: Flag suspiciously high activity counts
-- Helps identify data quality issues

select
    chv_id,
    report_month,
    total_activities,
    unique_households_visited,
    'Suspiciously high activity count' as issue
from {{ ref('chw_activity_monthly') }}
where total_activities > 500  -- More than 500 activities per month is unusual
   or unique_households_visited > 300  -- More than 300 households is unusual
-- Should return 0 rows for normal data