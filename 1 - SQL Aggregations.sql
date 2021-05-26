
# Prerequisite SQL -- L3-27
# Date 함수
SELECT DATE_TRUNC('year', occurred_at) AS year, SUM(total_amt_usd) AS total_sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

SELECT DATE_PART('month', occurred_at) AS sales_month, SUM(total_amt_usd) AS total_sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

SELECT DATE_TRUNC('year', occurred_at) AS sales_year, SUM(total) AS total_orders
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

SELECT DATE_PART('month', occurred_at) AS sales_month, SUM(total) AS total_orders
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

SELECT DATE_TRUNC('year', occurred_at) AS sales_year, DATE_PART('month', occurred_at) AS sales_month, SUM(gloss_amt_usd) AS gloss_sales
FROM orders
GROUP BY 1, 2
ORDER BY 3 DESC;

SELECT a.name, DATE_TRUNC('month', o.occurred_at) AS month, SUM(o.gloss_amt_usd) AS gloss_sales
FROM orders o
JOIN accounts a
ON a.id = o.account_id
WHERE a.name = 'Walmart' AND o.occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1, 2
ORDER BY 3 DESC;


# L3--29
# CASE 구문 & Aggregations
SELECT CASE WHEN total > 500 THEN 'Over 500'
ELSE '500 or Under' END AS total_group,
COUNT(*) AS order_count
FROM orders
GROUP BY 1;


# L3--31
# CASE
SELECT account_id, total total_orders,
CASE WHEN total_amt_usd >= 3000 THEN 'Large'
ELSE 'Small' END AS level_of_order
FROM orders;

SELECT CASE WHEN total >= 2000 THEN 'At Least 2000'
WHEN total BETWEEN 1000 AND 2000 THEN 'Between 1000 and 2000'
ELSE 'Less than 1000' END AS total, COUNT(*) AS total_number_of_orders
FROM orders
GROUP BY 1;

SELECT a.name, o.total_amt_usd,
CASE WHEN total_amt_usd > 200000 THEN 'Greater than 200,000'
WHEN total_amt_usd BETWEEN 100000 AND 200000 THEN '200,000 and 100,000'
ELSE 'under 100,000' END AS level, COUNT(*)
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY level;

SELECT a.name, SUM(total_amt_usd) total_spent,
CASE WHEN SUM(total_amt_usd) > 200000 THEN 'Top'
WHEN SUM(total_amt_usd) > 100000 AND SUM(total_amt_usd) <= 200000 THEN 'Middle'
ELSE 'Low' END AS customer_level
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY 2 DESC;

SELECT a.name, SUM(total_amt_usd) total_spent,
CASE WHEN SUM(total_amt_usd) > 200000 THEN 'Top'
WHEN SUM(total_amt_usd) > 100000 AND SUM(total_amt_usd) <= 200000 THEN 'Middle'
ELSE 'Low' END AS customer_level
FROM accounts a
JOIN orders o
ON a.id = o.account_id
WHERE o.occurred_at > '2015-12-31'
GROUP BY 1
ORDER BY 2 DESC;

SELECT s.name sales_rep_name, COUNT(*),
CASE WHEN COUNT(*) > 200 THEN 'Top'
ELSE 'Not' END AS sales_rep_level
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY sales_rep_name
ORDER BY 2 DESC;

SELECT s.name sales_rep_name, COUNT(*),
SUM(o.total_amt_usd) total_sales,
CASE WHEN COUNT(*) > 200 OR SUM(o.total_amt_usd) > 750000 THEN 'top'
WHEN COUNT(*) > 150 OR SUM(o.total_amt_usd) > 500000 THEN 'middle'
ELSE 'low' END AS sales_rep_level
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY sales_rep_name
ORDER BY 3 DESC;


# L3--23
# HAVING
SELECT a.name, COUNT(*) AS orders
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY 1
HAVING COUNT(*) > 20;

SELECT a.name, COUNT(*) AS orders
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

SELECT a.name, COUNT(*) AS orders
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

SELECT a.name, SUM(o.total_amt_usd) AS total_sales
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY 1
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY 2 DESC;

SELECT a.name, SUM(o.total_amt_usd) AS total_sales
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY 1
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY 2 DESC;

SELECT a.name, SUM(o.total_amt_usd) AS total_sales
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

SELECT a.name, SUM(o.total_amt_usd) AS total_sales
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2
LIMIT 1;

SELECT a.name, w.channel, COUNT(*) contact
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY 1, 2
HAVING COUNT(*) > 6 AND w.channel = 'facebook'
ORDER BY 3 DESC;

SELECT a.name, w.channel, COUNT(*) contact
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE w.channel = 'facebook'
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 1;

SELECT a.name, w.channel, COUNT(*) contact
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 10;
