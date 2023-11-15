-- Analysis by Paper
-- 1). What is the unit price of each paper type?
SELECT 
	ROUND(SUM(gloss_amt_usd)/SUM(gloss_qty), 2) AS gloss_unit_price,
	ROUND(SUM(standard_amt_usd)/SUM(standard_qty), 2) AS standard_unit_price,
	ROUND(SUM(poster_amt_usd)/SUM(poster_qty), 2) AS poster_unit_price
FROM orders;

-- 2). What is the sum total of all orders papers sold and revenue?
SELECT
	COUNT(*) AS no_of_orders,
	SUM(total) AS total_paper_sold,
	SUM(total_amt_usd) AS total_revenue
FROM orders;

-- 3).  What is the sum total of all orders papers sold and revenue by paper?
SELECT
	SUM(gloss_qty) AS gloss_paper_sold,
	SUM(gloss_amt_usd) AS gloss_revenue,
	SUM(standard_qty) AS standard_papers_sold,
	SUM(standard_amt_usd) AS standard_revenue,
	SUM(poster_qty) AS poster_papers_sold,
	SUM(poster_amt_usd) AS poster_revenue
FROM orders;

-- 4). How did the company perform by year?
SELECT 
	DATE_PART('year', occurred_at) AS year,
	SUM(total) AS papers_sold,
	SUM(total_amt_usd) AS total_revenue
FROM orders
GROUP BY 1
ORDER BY 3 DESC;

-- 5). How did each paper perform by year?
SELECT 
	DATE_PART('year', occurred_at) AS year,
	SUM(gloss_qty) AS gloss_paper_sold,
	SUM(gloss_amt_usd) AS gloss_revenue,
	SUM(standard_qty) AS standard_papers_sold,
	SUM(standard_amt_usd) AS standard_revenue,
	SUM(poster_qty) AS poster_papers_sold,
	SUM(poster_amt_usd) AS poster_revenue
FROM orders
GROUP BY 1
ORDER BY 1;

-- 6). What was the most succesful month for the company in terms of revenue?
SELECT
	DATE_PART('month', occurred_at) AS month,
	DATE_PART('year', occurred_at) AS year,
	SUM(total) AS total_paper_sold,
	SUM(total_amt_usd) AS total_revenue
FROM orders
GROUP BY 1, 2
ORDER BY 4 DESC
LIMIT 1;

-- 7). What month had the highest gloss paper sales?
SELECT
	DATE_PART('month', occurred_at) AS month,
	DATE_PART('year', occurred_at) AS year,
	SUM(gloss_qty) AS gloss_paper_sold,
	SUM(gloss_amt_usd) AS gloss_revenue
FROM orders
GROUP BY 1, 2
ORDER BY 4 DESC
LIMIT 1;

-- 8). What month had the highest standard paper sales?
SELECT
	DATE_PART('month', occurred_at) AS month,
	DATE_PART('year', occurred_at) AS year,
	SUM(standard_qty) AS standard_paper_sold,
	SUM(standard_amt_usd) AS standard_revenue
FROM orders
GROUP BY 1, 2
ORDER BY 4 DESC
LIMIT 1;

-- 9). What month had the highest poster paper sales?
SELECT
	DATE_PART('month', occurred_at) AS month,
	DATE_PART('year', occurred_at) AS year,
	SUM(poster_qty) AS poster_paper_sold,
	SUM(poster_amt_usd) AS poster_revenue
FROM orders
GROUP BY 1, 2
ORDER BY 4 DESC
LIMIT 1;

-- 10). What was the running total of revenue by month and year?
SELECT
	year,
	month,
	total_revenue,
	SUM(total_revenue) OVER (ORDER BY year, month) AS running_total
FROM(
SELECT 
	DATE_PART('year', occurred_at) AS year,
	DATE_PART('month', occurred_at) AS month,
	SUM(total_amt_usd) AS total_revenue
FROM orders
GROUP BY 1,2
ORDER BY 1,2
	) AS t1;
	
	
SELECT 
	MIN(occurred_at) AS earliest_order, 
	MAX(occurred_at) AS latest_order
FROM orders;


SELECT 
	DISTINCT DATE_part('year', occurred_at) AS year,
	DATE_part('month', occurred_at) AS month
FROM orders
ORDER BY 1;