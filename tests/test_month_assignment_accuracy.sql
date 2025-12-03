-- Test: Verify the 26th cutoff rule is working correctly
-- Activities on/after 26th should be in next month

with source_activities as (
    select
        activity_id,
        chv_id,
        activity_date,
        extract(day from activity_date) as day_of_month,
        case
            when extract(day from activity_date) >= 26 
            then date_trunc('month', activity_date + interval '1 month')::date
            else date_trunc('month', activity_date)::date
        end as expected_month
    from {{ source('marts', 'fct_chv_activity') }}
    where chv_id is not null
      and activity_date is not null
      and is_deleted = false
),

aggregated_data as (
    select distinct
        chv_id,
        report_month
    from {{ ref('chw_activity_monthly') }}
)

-- Check if any activities would be in wrong month
select
    s.activity_id,
    s.activity_date,
    s.day_of_month,
    s.expected_month,
    'Should be in ' || to_char(s.expected_month, 'YYYY-MM') as error_message
from source_activities s
left join aggregated_data a 
    on s.chv_id = a.chv_id 
    and s.expected_month = a.report_month
where a.report_month is null
-- Should return 0 rows