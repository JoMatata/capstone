-- Test: Total activities must be >= sum of activity type counts
-- This validates the conditional aggregation logic

select
    chv_id,
    report_month,
    total_activities,
    pregnancy_visits,
    child_assessments,
    family_planning_visits,
    (pregnancy_visits + child_assessments + family_planning_visits) as sum_of_types,
    total_activities - (pregnancy_visits + child_assessments + family_planning_visits) as difference
from {{ ref('chw_activity_monthly') }}
where total_activities < (pregnancy_visits + child_assessments + family_planning_visits)
-- Should return 0 rows (total should always be >= sum)