# Advanced JOINs :: FULL OUTER JOIN
# Unmatched values ONLY ::
## FULL OUTER JOIN
## WHERE TableA.column1 IS NULL OR TableB.column2 IS NULL

SELECT *
  FROM accounts
 FULL JOIN sales_reps ON accounts.sales_rep_id = sales_reps.id

## Can use this to check whether there is any unmatched data in purpose

# Inequality JOINs
## 숫자 뿐만 아니라 string, 즉 알파벳 순서 같은 거에도 적용 가능 ('<', '>', '<>', LIKE, BETWEEN)

SELECT a.name account_name, a.primary_poc, s.name sales_rep_name
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id = s.id
AND a.primary_poc < s.name;

# SELF JOIN
## 같은 테이블을 조인하기 때문에 이름을 구분해서 지어주는 게 헷갈리지 않음

SELECT we1.id AS we_id,
       we1.account_id AS we1_account_id,
       we1.occurred_at AS we1_occurred_at,
       we1.channel AS we1_channel,
       we2.id AS we2_id,
       we2.account_id AS we2_account_id,
       we2.occurred_at AS we2_occurred_at,
       we2.channel AS we2_channel
  FROM web_events we1
 LEFT JOIN web_events we2
   ON we1.account_id = we2.account_id
  AND we1.occurred_at > we2.occurred_at
  AND we1.occurred_at <= we2.occurred_at + INTERVAL '1 day'
ORDER BY we1.account_id, we2.occurred_at


# UNION -- 2개 이상의 테이블에서 중복 행 제거에 사용.
## 주의 : 두 테이블의 열 갯수도 같아야 하고, 첫 테이블과의 데이터 타입이 같아야 하는데 순서도 같아야 함.
## 단, 테이블의 이름까지 같을 필요는 없음.
# UNION ALL -- 중복 제거 없이 모든 데이터 합치는.

SELECT *
FROM accounts
WHERE name = 'Walmart'

UNION

SELECT *
FROM accounts
WHERE name = 'Disney'

--

SELECT *
FROM accounts

UNION

SELECT *
FROM accounts

--

WITH double_accounts AS (
    SELECT *
      FROM accounts

    UNION ALL

    SELECT *
      FROM accounts
)

SELECT name,
       COUNT(*) AS name_count
 FROM double_accounts
GROUP BY 1
ORDER BY 2 DESC;


# 쿼리 더 빠르게 하는 법
## 통제 불가 변수 -- 1. 테이블 크기, 2. 테이블 갯수, 3. Aggregations 갯수, 4. 데이터베이스 자체 다른 사람 사용량, 5. 데이터베이스 타입
## 통제 가능 변수 통제 :: 1) 행 갯수 제한. 단, Agg가 있다면 써브 쿼리를 만들어 전체 테이블 러닝하는 걸 막자.
## (이유? 쿼리 순서는 Aggregation 항상 먼저.)
## :: 2) JOIN 하기 전에 써브쿼리 내에서 Aggregate 먼저. 아니면 조인하는 테이블마다 훑고 다님.
## :: 3) EXPLAIN 을 넣어서 쿼리 돌리기 전에 쿼리 시간 확인, 리소스 계획 가능. (쿼리 수정 전후 대략 차이 비교 가능)
## :: 4) aggregate 하기 전에 ON에서 매치되는 부분이 거의 1000 * 1000으로, 79만,, 이렇게 커진다면,
## -- aggregate 부터 해줄 테이블로 쪼개기.(아래 이미지 참고)


## 기타 함수 ; COUNT(DISTINCT column)
