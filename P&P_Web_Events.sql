-- Analysis by web events
-- 1). Number of channels?
SELECT COUNT(DISTINCT channel) AS no_of_channels
FROM web_events;

-- 2). List the channels.
SELECT DISTINCT(channel) AS channels
FROM web_events;

-- 3). Total number of web events?
SELECT COUNT(*) AS no_of_web_events
FROM web_events;

-- 4). Most popular channel?
SELECT channel, COUNT(*) AS no_of_events
FROM web_events
GROUP BY 1
ORDER BY 2 DESC;

-- 5). What companies were the most active?
SELECT 
	a.name AS company,
	COUNT(*) AS no_of_events
FROM web_events AS w
JOIN accounts AS a
ON a.id = w.account_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 6a). Channel Usage by Companies
SELECT
	w.channel AS channel,
	COUNT(DISTINCT a.name) AS no_of_companies
FROM web_events AS w
JOIN accounts AS a
ON a.id = w.account_id
GROUP BY 1
ORDER BY 2 DESC;

-- 6b). Channel Usage by Companies in percentage
SELECT
	channel,
	no_of_companies,
	ROUND(no_of_companies/((SELECT COUNT(*) FROM accounts) + 0.01) * 100, 2) AS percentage
FROM(
SELECT
	w.channel AS channel,
	COUNT(DISTINCT a.name) AS no_of_companies
FROM web_events AS w
JOIN accounts AS a
ON a.id = w.account_id
GROUP BY 1
ORDER BY 2 DESC
	) AS t1;
	
-- 7a). Channel Usage by Sales Reps
SELECT
	w.channel AS channel,
	COUNT(DISTINCT s.name) AS no_of_companies
FROM web_events AS w
JOIN accounts AS a
ON a.id = w.account_id
JOIN sales_reps AS s
ON s.id = a.sales_rep_id
GROUP BY 1
ORDER BY 2 DESC;

-- 7b). Channel Usage by Sales Reps in percentage
SELECT
	channel,
	no_of_reps,
	ROUND(no_of_reps/((SELECT COUNT(*) FROM sales_reps) + 0.01) * 100, 1) AS percentage
FROM(
SELECT
	w.channel AS channel,
	COUNT(DISTINCT s.name) AS no_of_reps
FROM web_events AS w
JOIN accounts AS a
ON a.id = w.account_id
JOIN sales_reps AS s
ON s.id = a.sales_rep_id
GROUP BY 1
ORDER BY 2 DESC
	) AS t1;

-- 8). What was the percentage usage of each channel?
SELECT 
	channel,
	no_of_events,
	ROUND(no_of_events/(total_events + 0.01) * 100, 2) AS percentage
FROM(
	SELECT
	channel,
	COUNT(*) AS no_of_events,
	(SELECT COUNT(*) FROM web_events) AS total_events
FROM web_events
GROUP BY 1
ORDER BY 2 DESC
	) AS t1;