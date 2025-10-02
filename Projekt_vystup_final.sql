--První tabulka mezd a cen

create table "t_monika_mendlikova_project_sql_primary_final" as
with pt as (
  select
    cp.payroll_year as year,
    cpib.name                    as branch,
    avg(cp.value)                as avg_payroll_value
  from czechia_payroll cp
  join czechia_payroll_calculation    cpc  on cp.calculation_code = cpc.code
  join czechia_payroll_industry_branch cpib on cp.industry_branch_code = cpib.code
  join czechia_payroll_unit            cpu  on cp.unit_code = cpu.code
  join czechia_payroll_value_type      cpvt on cp.value_type_code = cpvt.code
  where cp.value is not null and cp.value_type_code = 5958  and cp.calculation_code = 200   
  group by cp.payroll_year, cpib.name
),
dt as (
  select
    extract(year from cp.date_from)::int  as year,
    cpc.name                               as product,
    avg(cp.value)                           as avg_price,
    cpc.price_value                         as price_count,
    cpc.price_unit                          as unit
  from czechia_price cp
  join czechia_price_category cpc on cp.category_code = cpc.code
  where cp.region_code is not null
  group by extract(year from cp.date_from), cpc.name, cpc.price_value, cpc.price_unit
)
select
  pt.year,
  dt.product,
  dt.avg_price,
  dt.price_count,
  dt.unit,
  pt.branch,
  pt.avg_payroll_value
from pt
left join dt on dt.year = pt.year
where dt.avg_price is not null
order by pt.year, dt.product

--Druhá tabulka ekonomické ukazatele Evropa
 
create table t_monika_mendlikova_project_sql_secondary_final as (
select 
    c.country, 
    c.population, 
    e.year, 
    e.gdp, 
    e.gini
from countries c 
join economies e on c.country = e.country
where c.continent = 'Europe' 
  and e.gdp is not null 
  and e.year between 2006 and 2018
order by year, country
)

-- Q1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

select
    branch,
    year,
    round(avg(avg_payroll_value)::numeric,2),
    avg_payroll_value - lag(avg_payroll_value) over (partition by branch order by year) as difference,
    case
        when avg_payroll_value > lag(avg_payroll_value) over (partition by branch order by year) then 'increased'
        when avg_payroll_value < lag(avg_payroll_value) over (partition by branch order by year) then 'decline'
        else 'equal'
    end as change
from t_monika_mendlikova_project_sql_primary_final
group by branch, year, avg_payroll_value
order by branch, year



-- Q2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

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


-- Q3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 

with product as (
  select distinct product,
  		 avg_price as price,
  		 year 
  from t_monika_mendlikova_project_sql_primary_final
  order by product
),
count as (
  select product,
         (price - lag(price) over (partition by product order by year))
             /(lag(price) over (partition by product order by year)) * 100 as calc
  from product
)
select product,
	   round(avg(calc)::numeric,2) as avg_calc
from count 
where calc is not null
group by product
having avg(calc) >= 0            
order by avg_calc asc
limit 1

-- Q4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?


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


-- Q5: Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

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




