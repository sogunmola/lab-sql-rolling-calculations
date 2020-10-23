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
SELECT * FROM monthly_active_customers;