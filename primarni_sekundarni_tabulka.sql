--První tabulka cen a mezd

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

--Druhá tabulka ekonomických ukazatelů v Evropě

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