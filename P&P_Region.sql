-- Analysis by Region
-- 1). What are the regions present in the database?
SELECT name as region
FROM region;

-- 2). How many companies are present in each region?
SELECT 
	r.name AS region,
	COUNT(DISTINCT s.name) AS no_of_reps,
	COUNT(DISTINCT a.name) AS no_of_companies,
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON a.sales_rep_id = s.id
GROUP BY 1;

-- 3). How many sales reps are present in region?
SELECT 
	r.name AS region, 
	COUNT(*) AS no_of_reps
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
GROUP BY 1;

-- 4). What are the number of orders, papers purchased and revenue by region?
SELECT 
	r.name AS region,
	COUNT(*) AS no_of_orders,
	SUM(o.total) AS papers_sold,
	SUM(o.total_amt_usd) AS revenue
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON a.sales_rep_id = s.id
JOIN orders AS o
ON o.account_id = a.id
GROUP BY 1
ORDER BY 3;

-- 5). What region bought the most gloss paper?
SELECT 
	r.name AS region,
	SUM(o.gloss_qty) AS gloss_quantity,
	SUM(gloss_amt_usd) AS gloss_revenue
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON a.sales_rep_id = s.id
JOIN orders AS o
ON o.account_id = a.id
GROUP BY 1
ORDER BY 3;

-- 6). What region bought the most standard paper?
SELECT 
	r.name AS region,
	SUM(o.standard_qty) AS standard_quantity,
	SUM(standard_amt_usd) AS standard_revenue
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON a.sales_rep_id = s.id
JOIN orders AS o
ON o.account_id = a.id
GROUP BY 1
ORDER BY 3;

-- 7). What region bought the most poster paper?
SELECT 
	r.name AS region,
	SUM(o.poster_qty) AS poster_quantity,
	SUM(poster_amt_usd) AS poster_revenue
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON a.sales_rep_id = s.id
JOIN orders AS o
ON o.account_id = a.id
GROUP BY 1
ORDER BY 3;

-- 8). Breakdown the web events by region.
SELECT
	r.name AS region,
	w.channel AS channel,
	COUNT(*) AS no_of_events
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON a.sales_rep_id = s.id
JOIN web_events AS w
ON w.account_id = a.id
GROUP BY 1, 2
ORDER BY 1, 3 DESC;

-- 9) What was the most popular channel in each region?
SELECT
	region, 
	channel,
	no_of_events
FROM(SELECT
	r.name AS region,
	w.channel AS channel,
	COUNT(*) AS no_of_events,
	RANK() OVER (PARTITION BY r.name ORDER BY COUNT(*) DESC) AS ranking
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON a.sales_rep_id = s.id
JOIN web_events AS w
ON w.account_id = a.id
GROUP BY 1, 2
ORDER BY 1, 3 DESC) AS t1
WHERE ranking = 1; 

