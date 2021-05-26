# 써브쿼리 좋은 예 1

SELECT *
FROM (SELECT DATE_TRUNC('day', occurred_at) AS day, channel, COUNT(*) AS event_numbers
FROM web_events
GROUP BY 1, 2
ORDER BY 3 DESC) sub;

SELECT channel, AVG(events) AS average_events
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
             channel, COUNT(*) as events
      FROM web_events
      GROUP BY 1,2) sub
GROUP BY channel
ORDER BY 2 DESC;



# 써브쿼리 좋은 예 2

SELECT *
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
                channel, COUNT(*) as events
      FROM web_events
      GROUP BY 1,2
      ORDER BY 3 DESC) sub
GROUP BY day, channel, events
ORDER BY 2 DESC;

SELECT AVG(standard_qty) avg_std, AVG(gloss_qty) avg_gls, AVG(poster_qty) avg_pst
FROM orders
WHERE DATE_TRUNC('month', occurred_at) =
     (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);



# L4-9-1  (써브쿼리 매니아)

SELECT t2.rep_name, t2.region_name, t2.total_amt
FROM(SELECT region_name, MAX(total_amt) total_amt
     FROM(SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
             FROM sales_reps s
             JOIN accounts a
             ON a.sales_rep_id = s.id
             JOIN orders o
             ON o.account_id = a.id
             JOIN region r
             ON r.id = s.region_id
             GROUP BY 1, 2) sub
     GROUP BY 1) t1
JOIN (SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
     FROM sales_reps s
     JOIN accounts a
     ON a.sales_rep_id = s.id
     JOIN orders o
     ON o.account_id = a.id
     JOIN region r
     ON r.id = s.region_id
     GROUP BY 1,2
     ORDER BY 3 DESC) t2
ON t2.region_name = t1.region_name AND t2.total_amt = t1.total_amt;



# L4-9-2 (써브쿼리 매니아)
# region's MAX SUM total_amt_usd & total orders

# 먼저 구할 것 ; regions' sum(sales) > max all
# if only orders, then have no link with regions.

SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (
      SELECT MAX(total_amt)
      FROM (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
              FROM sales_reps s
              JOIN accounts a
              ON a.sales_rep_id = s.id
              JOIN orders o
              ON o.account_id = a.id
              JOIN region r
              ON r.id = s.region_id
              GROUP BY r.name) sub);



# L4-9-3 (써브쿼리 매니아)

SELECT COUNT(*)
FROM (SELECT a.name
       FROM orders o
       JOIN accounts a
       ON a.id = o.account_id
       GROUP BY 1
       HAVING SUM(o.total) > (SELECT total
                   FROM (SELECT a.name act_name, SUM(o.standard_qty) tot_std, SUM(o.total) total
                         FROM accounts a
                         JOIN orders o
                         ON o.account_id = a.id
                         GROUP BY 1
                         ORDER BY 2 DESC
                         LIMIT 1) inner_tab)
             ) counter_tab;



# L4-9-4 (써브쿼리 매니아)

SELECT a.name customer_name, w.channel, COUNT(*) web_event_occurrence
FROM accounts a
JOIN orders o
ON o.account_id = a.id
JOIN web_events w
ON w.account_id = a.id
HAVING SUM(o.total_amt_usd) =
		(SELECT MAX(sub.total_spend)
		FROM(SELECT a.name account_name,
             SUM(o.total_amt_usd) total_spend
			FROM accounts a
			JOIN orders o
			ON o.account_id = a.id
		    GROUP BY 1) sub)
GROUP BY 1, 2



# L4-9-5 (써브쿼리 매니아)
SELECT AVG(sub2.ts) avg_total_spending
FROM(SELECT sub.total_spending ts
		FROM (SELECT a.id id, a.name account_name, SUM(o.total_amt_usd) total_spending
					FROM accounts a
					JOIN orders o
					ON a.id = o.account_id
					GROUP BY 1, 2) sub
		ORDER BY 1 DESC
		LIMIT 10) sub2


SELECT AVG(tot_spent)
FROM (SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
      FROM orders o
      JOIN accounts a
      ON a.id = o.account_id
      GROUP BY a.id, a.name
      ORDER BY 3 DESC
       LIMIT 10) temp;



# L4-9-6 (써브쿼리 매니아)

SELECT AVG(avg_amt)
FROM (SELECT o.account_id, AVG(o.total_amt_usd) avg_amt
    FROM orders o
    GROUP BY 1
    HAVING AVG(o.total_amt_usd) >
		(SELECT AVG(o.total_amt_usd) avg_all
     FROM orders o)) temp_table;
