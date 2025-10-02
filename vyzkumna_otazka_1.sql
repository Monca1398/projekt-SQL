--Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

select
    branch,
    year,
    round(avg(avg_payroll_value)::numeric,2) as avg_payroll_value,
    avg_payroll_value - lag(avg_payroll_value) over (partition by branch order by year) as difference,
    case
        when avg_payroll_value > lag(avg_payroll_value) over (partition by branch order by year) then 'increased'
        when avg_payroll_value < lag(avg_payroll_value) over (partition by branch order by year) then 'decline'
        else 'equal'
    end as change
from t_monika_mendlikova_project_sql_primary_final
group by branch, year, avg_payroll_value
order by branch, year