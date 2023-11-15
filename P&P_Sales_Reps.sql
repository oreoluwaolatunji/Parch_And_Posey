-- Analysis By Sales Reps
-- 1). How many sales reps are present?
SELECT COUNT(*) AS no_of_reps
FROM sales_reps;

-- 2). Find out the number of accounts each sales rep handles.
SELECT 
	s.name AS sales_rep,
	COUNT(a.name) AS no_of_accounts
FROM sales_reps AS s
JOIN accounts AS a
ON a.sales_rep_id = s.id
GROUP BY 1
ORDER BY 2 DESC;

-- 3). What is the average number of accounts per sales rep?
SELECT accounts/sales_reps AS accounts_per_rep
FROM(
	SELECT
	COUNT(a.name) AS accounts,
	COUNT(DISTINCT s.name) AS sales_reps
FROM sales_reps AS s
JOIN accounts AS a
ON a.sales_rep_id = s.id
	) AS t1;
	
-- 4). How many sales reps handle more than or equal to the average number of accounts?
SELECT 
	COUNT(*) AS no_of_reps
FROM(
	SELECT 
	s.name AS sales_rep,
	COUNT(*) AS no_of_accounts
FROM sales_reps AS s
JOIN accounts AS a
ON a.sales_rep_id = s.id
GROUP BY 1
HAVING COUNT(*) >= (SELECT accounts/sales_reps AS accounts_per_rep
FROM(
	SELECT
	COUNT(a.name) AS accounts,
	COUNT(DISTINCT s.name) AS sales_reps
FROM sales_reps AS s
JOIN accounts AS a
ON a.sales_rep_id = s.id
	) AS t1)
	) AS t2;

-- 5). Who are the sales reps who handled the most orders?
SELECT 
	s.name AS sales_rep,
	COUNT(*) AS no_of_orders
FROM sales_reps AS s
JOIN accounts AS a
ON s.id = a.sales_rep_id
JOIN orders AS o
ON o.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 5). Who are the sales reps who had the most paper sales?
SELECT 
	s.name AS sales_rep,
	SUM(total) AS total_paper_sold
FROM sales_reps AS s
JOIN accounts AS a
ON s.id = a.sales_rep_id
JOIN orders AS o
ON o.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 5). Who are the sales reps who had the most revenue from paper sales?
SELECT 
	s.name AS sales_rep,
	SUM(total_amt_usd) AS revenue
FROM sales_reps AS s
JOIN accounts AS a
ON s.id = a.sales_rep_id
JOIN orders AS o
ON o.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 6). Who sold the most gloss paper?
SELECT 
	s.name AS sales_rep,
	SUM(o.gloss_qty) AS gloss_paper_sold,
	ROUND((SUM(o.gloss_qty)/SUM(o.total + 0.01) * 100), 2) AS percentage,
	SUM(o.gloss_amt_usd) AS gloss_revenue
FROM sales_reps AS s
JOIN accounts AS a
ON s.id = a.sales_rep_id
JOIN orders AS o
ON o.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- 7). Who sold the most standard paper?
SELECT 
	s.name AS sales_rep,
	SUM(o.standard_qty) AS standard_paper_sold,
	ROUND((SUM(o.standard_qty)/SUM(o.total + 0.01) * 100), 2) AS percentage,
	SUM(o.standard_amt_usd) AS standard_revenue
FROM sales_reps AS s
JOIN accounts AS a
ON s.id = a.sales_rep_id
JOIN orders AS o
ON o.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- 8). Who sold the most poster paper?
SELECT 
	s.name AS sales_rep,
	SUM(o.poster_qty) AS poster_paper_sold,
	ROUND((SUM(o.poster_qty)/SUM(o.total + 0.01) * 100), 2) AS percentage,
	SUM(o.poster_amt_usd) AS poster_revenue
FROM sales_reps AS s
JOIN accounts AS a
ON s.id = a.sales_rep_id
JOIN orders AS o
ON o.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- 9). What channels were used by sales reps?
SELECT 
	w.channel AS channel,
	COUNT(DISTINCT s.name) AS no_of_reps
FROM sales_reps AS s
JOIN accounts AS a
ON s.id = a.sales_rep_id
JOIN web_events as w
ON w.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC;

-- 10). What channel was the most used by each sales_rep?
SELECT
	sales_rep,
	channel,
	no_of_events
FROM(
	SELECT 
	s.name AS sales_rep,
	w.channel AS channel,
	COUNT(*) AS no_of_events,
	RANK() OVER(PARTITION BY s.name ORDER BY COUNT(*) DESC) AS ranking
FROM sales_reps AS s
JOIN accounts AS a
ON s.id = a.sales_rep_id
JOIN web_events as w
ON w.account_id = a.id
GROUP BY 1, 2
ORDER BY 1, 3 DESC
	) AS t1
WHERE ranking = 1;

-- 11). Company to Sales Rep Ratio
SELECT
	region,
	no_of_companies,
	no_of_reps,
	no_of_companies/no_of_reps AS company_rep_ratio
FROM(SELECT 
	r.name AS region,
	COUNT(DISTINCT s.name) AS no_of_reps,
	COUNT(DISTINCT a.name) AS no_of_companies
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON a.sales_rep_id = s.id
GROUP BY 1) AS t1;