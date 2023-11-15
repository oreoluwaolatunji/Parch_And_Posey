-- Analysis By Company
-- 1). How many companies have an account with Parch & Posey?
SELECT COUNT(*) AS no_of_companies
FROM accounts;

-- 2). What are the domain names present in the table and what are the counts?
SELECT domain, COUNT(*) AS domain_count
FROM(SELECT RIGHT(website, 3) AS domain
FROM accounts) AS t1
GROUP BY 1;

-- 3). How many orders were made by companies in total?
SELECT COUNT(*) AS no_of_orders
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id;

-- 4). What companies made the most orders?
SELECT a.name AS company, COUNT(*) AS no_of_orders
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 5). What company made no orders?
SELECT a.name AS company
FROM accounts AS a
LEFT JOIN orders AS o
ON a.id = o.account_id 
WHERE o.total IS NULL;

-- 6). What companies bought the most paper?
SELECT a.name AS company, 
	   COUNT(*) AS no_of_orders,
	   SUM(total) AS no_of_papers
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id 
GROUP BY 1
ORDER BY 3 DESC
LIMIT 5;

-- 7). What are the most profitable companies in terms of revenue?
SELECT a.name AS company,
	   COUNT(*) no_of_orders,
	   SUM(total_amt_usd) AS revenue
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 3 DESC
LIMIT 5;

-- 8). What was the average number of orders?
SELECT no_of_orders/no_of_companies AS orders_per_company
FROM(SELECT COUNT(*) AS no_of_orders,
	   COUNT(DISTINCT a.name) AS no_of_companies
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id) AS t1;

-- 9). What was the total number of paper bought, total revenue, average number of paper bought & average revenue per order?
SELECT 
	SUM(total) AS total_orders,
	ROUND(AVG(total), 2) AS paper_per_order,
	SUM(total_amt_usd) AS total_revenue,
	ROUND(AVG(total_amt_usd), 2) AS revenue_per_order
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id;

-- 10). What companies ordered and spent the most standard paper?
SELECT 
	a.name AS company, 
	SUM(o.standard_qty) AS standard_paper,
	SUM(o.standard_amt_usd) AS standard_paper_revenue
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 3 DESC
LIMIT 5;

-- 11). What companies ordered and spent the most gloss paper?
SELECT 
	a.name AS company, 
	SUM(o.gloss_qty) AS gloss_paper,
	SUM(o.gloss_amt_usd) AS gloss_paper_revenue
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 12). What companies ordered and spent the most poster paper?
SELECT 
	a.name AS company, 
	SUM(o.poster_qty) AS poster_paper,
	SUM(o.poster_amt_usd) AS poster_paper_revenue
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 13). What day did each company first order?
SELECT a.name AS company, MIN(occurred_at) AS first_order
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id
GROUP BY 1
ORDER by 2;

-- 14). What day did each company last order?
SELECT a.name AS company, MAX(occurred_at) AS latest_order
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id
GROUP BY 1
ORDER by 2;

-- 15). How many companies had a minimum of the average number of orders and a revenue greater than the average revenue?
SELECT COUNT(*) AS no_of_companies
FROM(
SELECT 
	a.name AS company, 
	COUNT(*) AS no_of_orders,
	SUM(o.total_amt_usd) AS revenue
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id
GROUP BY 1
HAVING COUNT(*) >= 19 AND SUM(o.total_amt_usd) > (
SELECT ROUND(AVG(total_amt_usd), 2) AS revenue_per_order
FROM orders)
ORDER BY 2) AS t1;