-- Test: Each month should have at least some activity diversity
-- Flags months where ALL activity types are zero (suspicious)

select
    report_month,
    sum(pregnancy_visits) as total_pregnancy,
    sum(child_assessments) as total_child,
    sum(family_planning_visits) as total_fp,
    'No activities recorded for any type' as issue
from {{ ref('chw_activity_monthly') }}
group by report_month
having sum(pregnancy_visits) = 0
   and sum(child_assessments) = 0
   and sum(family_planning_visits) = 0
-- Should return 0 rows