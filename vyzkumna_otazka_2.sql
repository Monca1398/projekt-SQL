--Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

with years as (
  select min(year) as first, max(year) as last
  from t_monika_mendlikova_project_sql_primary_final
  where product in ('Mléko polotučné pasterované', 'Chléb konzumní kmínový')
),
product as (
  select
    year,
    product,
    unit,
    avg_payroll_value,
    avg_price
  from t_monika_mendlikova_project_sql_primary_final
  where product in ('Mléko polotučné pasterované', 'Chléb konzumní kmínový')
),
wage_price as (
  select
    year,
    product,
    unit,
    avg(avg_payroll_value) as avg_wage,
    avg(avg_price)  as avg_price
  from product
  group by year, product, unit
)
select
  year,
  product,
  round(avg_wage::numeric, 2)  as avg_wage,
  round(avg_price::numeric, 2) as avg_price,
  unit,
  round((avg_wage / (avg_price))::numeric, 2) as purchasable_units
from wage_price wp
join years y on wp.year in (y.first, y.last)
order by year, product