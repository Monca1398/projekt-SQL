--Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

with price as (
  select year, avg(avg_price) as avg_price
  from t_monika_mendlikova_project_sql_primary_final
  group by year
),
wages as (
  select year, avg(avg_payroll_value) as avg_wage
  from t_monika_mendlikova_project_sql_primary_final 
  group by year 
),
price_calc as (
  select year, avg_price, lag(avg_price) over (order by year),
         (avg_price - lag(avg_price) over (order by year))
             / (lag(avg_price) over (order by year)) * 100 as price_calc
  from price
),
wages_calc as (
  select year,
         (avg_wage - lag(avg_wage) over (order by year))
             / (lag(avg_wage) over (order by year)) * 100 as wage_calc
  from wages
)
select
  p.year,
  round(p.price_calc::numeric,2) as price_calc,
  round(w.wage_calc::numeric,2) as wage_calc,
  round((p.price_calc - w.wage_calc)::numeric,2) as difference,
case when (p.price_calc - w.wage_calc) > 10 then 'prices grew significantly faster than wages' else 'difference < 10%'end as result
from price_calc p
join wages_calc w on p.year = w.year
where w.wage_calc is not null
order by p.year