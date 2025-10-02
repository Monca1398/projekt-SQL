--Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 

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