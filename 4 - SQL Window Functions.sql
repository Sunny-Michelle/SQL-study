# 윈도우 함수 ; 고유의 행의 값은 유지한 채로 테이블 전체에서 그 행과 연관 있는 값들을 연산함 / 주로 그 행까지의 누적 통계 중에서 값 추출
## running total SUM(standard_qty) OVER (ORDER BY occurred_as) AS running_total

SELECT standard_qty,
		DATE_TRUNC('month', occurred_at) AS month,
		SUM(standard_qty) OVER (PARTITION BY DATE_TRUNC('month', occurred_at) ORDER BY occurred_at) AS running_total

SELECT standard_amt_usd,
	   DATE_TRUNC('year', occurred_at) AS year,
     SUM(standard_amt_usd) OVER (PARTITION BY  DATE_TRUNC('year', occurred_at) ORDER BY occurred_at) AS running_total
FROM orders

# RANK(), DENSE_RANK(), ROW_NUMBER()
## ROW_NUMBER() OVER(PARTITION BY column1 ORDER BY column2) AS new_name ::: column2를 기준으로 1번부터 행 번호 매기기
## RANK() OVER(PARTITION BY column1 ORDER BY column2) AS new_name ::: column2를 기준으로, 하지만 column1이 겹치면 그룹핑하고, 동일한 랭킹은 1, 2 2개, 4.. 이렇게
## DENS_RANK() OVER(PARTITION BY column1 ORDER BY column2) AS new_name ::: 중복 랭킹 상관 없이 1, 2, 3, ... 순서대로 랭킹 매기기

SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER account_year_window AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER account_year_window AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER account_year_window AS count_total_amt_usd,
       AVG(total_amt_usd) OVER account_year_window AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER account_year_window AS min_total_amt_usd,
       MAX(total_amt_usd) OVER account_year_window AS max_total_amt_usd
FROM orders

WINDOW account_year_window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at))


# LAG(), LEAD()
## LAG(column1) OVER (ORDER BY column1) AS lag -- column1 계산 행의 바로 앞 행 숫자
## LEAD(column1) OVER (ORDER BY column1) AS lead -- column1 계산 행의 바로 뒤 행 숫자

SELECT order_time,
       total_amt_sum AS current_order_total_revenue,
       LEAD(total_amt_sum) OVER (ORDER BY order_time) AS next_order_total_revenue,
       LEAD(total_amt_sum) OVER (ORDER BY order_time) total_amt_sum AS total_difference
FROM (
SELECT occurred_at AS order_time,
       SUM(total_amt_usd) AS total_amt_sum
  FROM orders
 GROUP BY 1
 ) sub


# NTILE(N) 퍼센타일 나타내는. N등분에서 해당 행이 몇 번째 등분에 위치하는지. 큰 숫자가 N등분에 가까움
## NTILE(4) ORDER BY(standard_qty) AS quartile

SELECT account_id,
				occurred_at,
        standard_qty,
        NTILE(4) OVER(PARTITION BY account_id ORDER BY standard_qty) AS standard_quartile
FROM orders
ORDER BY 3 DESC;

SELECT account_id,
				occurred_at,
        gloss_qty,
        NTILE(2) OVER(PARTITION BY account_id ORDER BY gloss_qty) AS gloss_half
FROM orders
ORDER BY account_id DESC;

SELECT account_id,
		occurred_at,
        total_amt_usd,
        NTILE(100) OVER(PARTITION BY account_id ORDER BY total_amt_usd) AS total_percentile
FROM orders
ORDER BY account_id DESC;
