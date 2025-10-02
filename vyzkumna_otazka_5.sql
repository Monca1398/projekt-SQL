--Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

with gdp as (
  select
    year,
   ((gdp - lag(gdp) over (order by year))
          / (lag(gdp) over (order by year)) * 100) as gdp_change
  from economies
  where country = 'Czech Republic'
),
wages as (
  select
    year,
    avg(avg_payroll_value)::numeric as avg_wage
  from t_monika_mendlikova_project_sql_primary_final
  group by year
),
wages_change as (
  select
    year,
    ((avg_wage - lag(avg_wage) over (order by year))
          / (lag(avg_wage) over (order by year)) * 100) as wage_change
  from wages
),
prices as (
  select
    year,
    avg(avg_price)::numeric as avg_price
  from t_monika_mendlikova_project_sql_primary_final
  group by year
),
prices_change as (
  select
    year,
   ((avg_price - lag(avg_price) over (order by year))
          /(lag(avg_price) over (order by year)) * 100) as price_change
  from prices
)
select 
  p.year,
  round(g.gdp_change::numeric,2) as gdp_change,
  round(w.wage_change::numeric,2) as wage_change,
  round(p.price_change::numeric,2) as price_change,
  case when gdp_change > 0 and w.wage_change > 0 then 'wages grow when gdp grows'
    when g.gdp_change < 0 and w.wage_change < 0 then 'wages fall when gdp falls'
    else 'no clear link wages vs gdp'
  end as wage_interpretation,
  case 
    when g.gdp_change > 0 and p.price_change > 0 then 'prices grow when gdp grows'
    when g.gdp_change < 0 and p.price_change < 0 then 'prices fall when gdp falls'
    else 'no clear link prices vs gdp'
  end as price_interpretation
from gdp g
join wages_change w on g.year = w.year
join prices_change p on g.year = p.year
where w.wage_change is not null
order by g.year;