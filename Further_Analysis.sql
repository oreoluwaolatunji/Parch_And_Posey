-- What is the ratio of companies to sales reps by region?
SELECT 
	region, 
	no_of_reps,
	no_of_companies,
	no_of_companies/no_of_reps AS company_rep_ratio
FROM(SELECT 
	r.name AS region,
	COUNT(DISTINCT s.name) AS no_of_reps,
	COUNT(DISTINCT a.name) AS no_of_companies
FROM region AS r
JOIN sales_reps AS s
On r.id = s.region_id
JOIN accounts AS a
ON s.id = a.sales_rep_id
GROUP BY 1) AS t1;

-- average revenue and unit by region
SELECT
	r.name AS region,
	COUNT(*) AS no_of_orders,
	ROUND(AVG(o.total), 2) AS units_average,
	ROUND(AVG(o.total_amt_usd), 2) AS revenue_average
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON a.sales_rep_id = s.id
JOIN orders AS o
ON o.account_id = a.id
WHERE DATE_PART('year', occurred_at) IN (2014, 2015, 2016)
GROUP BY 1
ORDER BY 4 DESC;

-- Orders to rep ratio, units to rep ratio and revenue to rep ratio
SELECT 
	region,
	no_of_reps,
	no_of_orders,
	no_of_orders/no_of_reps AS orders_rep_ratio,
	units,
	units/no_of_reps AS units_rep_ratio,
	revenue,
	ROUND(revenue/no_of_reps, 2) AS revenue_rep_ratio
FROM(SELECT
	r.name AS region,
	COUNT(DISTINCT s.name) AS no_of_reps,
	COUNT(*) AS no_of_orders,
	SUM(o.total) AS units,
	SUM(o.total_amt_usd) AS revenue,
	ROUND(AVG(o.total_amt_usd), 2) AS revenue_average
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON a.sales_rep_id = s.id
JOIN orders AS o
ON o.account_id = a.id
WHERE DATE_PART('year', occurred_at) IN (2014, 2015, 2016)
GROUP BY 1) AS t1
ORDER BY 8 DESC;

-- Sales Reps Average by region
SELECT
	region,
	sales_rep,
	orders,
	average
FROM(SELECT
	r.name AS region,
	s.name AS sales_rep,
	COUNT(*) AS orders,
	AVG(total_amt_usd) as average,
	RANK() OVER(PARTITION BY r.name ORDER BY AVG(total_amt_usd) DESC) AS ranking
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON a.sales_rep_id = s.id
JOIN orders AS o
ON o.account_id = a.id
WHERE DATE_PART('year', occurred_at) IN (2014, 2015, 2016)
GROUP BY 1,2
ORDER BY 1,4) AS t1
WHERE ranking = 1
ORDER BY 4 DESC;

-- Sales Reps Average
SELECT
	region,
	sales_rep,
	orders,
	average
FROM(SELECT
	r.name AS region,
	s.name AS sales_rep,
	COUNT(*) AS orders,
	AVG(total_amt_usd) as average
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON a.sales_rep_id = s.id
JOIN orders AS o
ON o.account_id = a.id
WHERE DATE_PART('year', occurred_at) IN (2014, 2015, 2016)
GROUP BY 1,2
ORDER BY 1,4) AS t1
ORDER BY 4 DESC;