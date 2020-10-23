USE sakila;

/* 1) Get number of monthly active customers
*/
SELECT * FROM rental;

-- Create active_customers 
CREATE OR REPLACE VIEW customer_activity AS
SELECT customer_id, convert(rental_date, date) AS activity_date,
date_format(CONVERT(rental_date, date), '%m') AS activity_month,
date_format(CONVERT(rental_date, date), '%Y') AS activity_year
FROM rental;

-- active_customers_view check
SELECT * FROM customer_activity;

-- Number of monthtly active customers
CREATE OR REPLACE VIEW monthly_active_customers AS
SELECT COUNT(DISTINCT customer_id) AS active_customers, activity_year, activity_month
FROM customer_activity
GROUP BY activity_year, activity_month
ORDER BY activity_year, activity_month;

-- monthly_active_customer check
SELECT * FROM monthly_active_customers
ORDER BY activity_month;

/* 2) Active users in the previous month.
*/
WITH cte_activity as (
  select active_customers, lag(active_customers,1) over (partition by activity_year) as last_month, activity_year, activity_month
  from monthly_active_customers
)
select * from cte_activity
where last_month is not null

/* 3) Percentage change in the number of active customers
*/
with cte_activity as (
  select active_customers, (active_customers-(lag(active_customers,1) over (partition by activity_year)))/(active_customers)*100 as percentage, 
  lag(active_customers,1) over (partition by activity_year) as last_month, activity_year, activity_month
  from monthly_customers
)
select * from cte_activity
where last_month is not null;

/* 4) Retained customers every month
*/
with distinct_users as (
  select distinct customer_id , activity_month, activity_year
  from customer_activity
)
select count(distinct d1.customer_id) as Retained_customers, d1.activity_month, d1.activity_year
from distinct_users d1
join distinct_users d2 on d1.customer_id = d2.customer_id
and d1.activity_month = d2.activity_month + 1
group by d1.activity_month, d1.activity_year
order by d1.activity_year, d1.activity_month;