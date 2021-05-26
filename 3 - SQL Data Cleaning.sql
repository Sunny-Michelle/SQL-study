# L5 -- 3-1
## LEFT(name, 3), RIGHT(name, 4), LENGTH(name)
SELECT COUNT(*), website_type
FROM(SELECT website, RIGHT(website, 3) website_type
	FROM accounts) sub
GROUP BY 2;

SELECT RIGHT(website, 3) as domain, COUNT(*) domain_type_numbers
FROM accounts
GROUP BY 1

SELECT LEFT(name, 1), COUNT(*)
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;

SELECT SUM(num) nums, SUM(letter) letters
FROM (SELECT name, CASE WHEN LEFT(name, 1) IN ('0','1','2','3','4','5','6','7','8','9')
						THEN 1 ELSE 0 END AS num,
		CASE WHEN LEFT(NAME, 1) IN ('0','1','2','3','4','5','6','7','8','9')
				THEN 0 ELSE 1 END AS letter
		FROM accounts) t1;

SELECT SUM(starts_with_vowel) vowel, SUM(starts_with_others) others
FROM (SELECT name, CASE WHEN LEFT(name, 1) IN ('a', 'e', 'i', 'o', 'u')
						THEN 1 ELSE 0 END AS starts_with_vowel,
						CASE WHEN LEFT(name, 1) IN ('a', 'e', 'i', 'o', 'u')
						THEN 0 ELSE 1 END AS starts_with_others
FROM accounts) t1;

SELECT SUM(vowels) vowels, SUM(other) other
FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U')
          THEN 1 ELSE 0 END AS vowels,
          CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U')
                       THEN 0 ELSE 1 END AS other
         FROM accounts) t1;


# POSITION, STRPOS, LOWER, UPPER
## POSITION(',' IN name) 은 name 칼럼 안에서 콤마로 나뉘어지는 부분까지 문자수 갯수
## STRPOS(name, ',') 은 POSITION과 같이 콤마를 기준으로 나뉘어지는 부분까지 문자수 갯수
## POSITION， STRPOS은 모두 대소문자 구분하기 때문에 주의 필요, 보통 구분자까지 포함해서 숫자를 셈
## LOWER， UPPER 는 그 열의 문자를 모두 대>소 혹은 소>대 문자로 만듦

SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') -1 ) first_name,
RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name
FROM accounts;

SELECT LEFT(name, STRPOS(name, ' ') -1 ) first_name,
RIGHT(name, LENGTH(name) - STRPOS(name, ' ')) last_name
FROM sales_reps;


# CONCAT 2 열의 내용을 합쳐서 하나의 열에 나타낼 때
# CONCAT(first_column, '구분자', second_column) 또는 first_column || '구분자' || second_column

WITH t1 AS (SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ')-1) first_name, RIGHT(primary_poc, LENGTH(primary_poc)-STRPOS(primary_poc, ' ')) last_name, name
FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', name, '.com')
FROM t1;

WITH t1 AS (SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ')-1) first_name, RIGHT(primary_poc, LENGTH(primary_poc)-STRPOS(primary_poc, ' ')) last_name, REPLACE(name, ' ', '_') company_name
FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', company_name, '.com')
FROM t1;

WITH t1 AS (
SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ')-1) first_name, RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', REPLACE(name, ' ', ''), '.com') email_address,
LOWER(LEFT(first_name, 1)) || RIGHT(first_name, 1) || LOWER(LEFT(last_name, 1)) || RIGHT(last_name, 1) || LENGTH(first_name) || LENGTH(last_name) || UPPER(REPLACE(name, ' ', '')) AS password
FROM t1;

## 오답노트 ; 너무 구문이 말도 안 되게 길어지는 것 같으면 공통적으로 추출해낼 것을 써브쿼리로 뽑아내고,
## 그 공통된 요소를 테이블화해서 할 수 있는 것은 없을지 구조화해 생각

# CAST ; 데이터 타입을 바꿀 때 - 문자열(string)을 date나 숫자로
## CAST(date_column AS DATE) 또는 date_column :: DATE
## DATE_PART('month', TO_DATE(month, 'month')) 는 해당 월의 이름을 숫자로 바꿔주는 역할
## SUBSTR('ABCDEFG', 3, 2)는 CD 세번째에서부터 2개 뽑기

SELECT date orig_date, (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2))::DATE new_date
FROM sf_crime_data;

## 날짜 형식은 yyyy-mm-dd

# COALESCE는 각 행의 첫 NULL 이 아닌 값을 출력
## COALESCE(칼럼, '출력값') ; '출력값'으로 NULL 부분 채우기

## COLUMN_ALIAS 는 WHERE, GROUP BY, HAVING에서는 아직 쓸 수 없음 (WHERE에서 먼저 제한을 해줘야 하는데, 그 때에는 아직 AS로 변환되기 전)

SELECT COALESCE(o.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, o.occurred_at, COALESCE(o.standard_qty, '0') std_qty, COALESCE(o.gloss_qty, '0') gloss_qty, COALESCE(o.poster_qty, '0') poster_qty, COALESCE(o.total, '0') ttl_qty, COALESCE(o.standard_amt_usd, '0') std_usd, COALESCE(o.gloss_amt_usd, '0') gloss_usd, COALESCE(o.poster_amt_usd, '0') poster_usd, COALESCE(o.total_amt_usd, '0') ttl_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

SELECT COUNT(*)
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id;

SELECT COALESCE(o.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, o.occurred_at, COALESCE(o.standard_qty, 0) standard_qty, COALESCE(o.gloss_qty,0) gloss_qty, COALESCE(o.poster_qty,0) poster_qty, COALESCE(o.total,0) total, COALESCE(o.standard_amt_usd,0) standard_amt_usd, COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, COALESCE(o.poster_amt_usd,0) poster_amt_usd, COALESCE(o.total_amt_usd,0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id;
