--Inspecting the survey table

SELECT * 
FROM survey
LIMIT 10;

--What is the number of responses for each question?

SELECT question,
  COUNT(DISTINCT user_id)
FROM survey
GROUP BY 1;

--Which question(s) of the quiz have a lower completion rate?

SELECT * 
FROM quiz
LIMIT 5;

SELECT * 
FROM home_try_on
LIMIT 5;

SELECT * 
FROM purchase
LIMIT 5;

--Left Join Tables 

SELECT DISTINCT q.user_id,
  h.user_id IS NOT NULL AS 'is_home_try_on',
  h.number_of_pairs,
  p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on 'h'
  ON h.user_id = q.user_id
LEFT JOIN purchase 'p'
  ON p.user_id = h.user_id
LIMIT 10;

--Counting the number of users at each step

WITH funnels AS (
SELECT DISTINCT q.user_id,
  h.user_id IS NOT NULL AS 'is_home_try_on',
  h.number_of_pairs,
  p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on 'h'
  ON h.user_id = q.user_id
LEFT JOIN purchase 'p'
  ON p.user_id = h.user_id)
SELECT COUNT(*) AS 'num_browse',
SUM(is_home_try_on) AS 'num_home_tries',
SUM(is_purchase) AS 'num_purchase',
1.0 * SUM(is_home_try_on) / COUNT(user_id) AS 'browse_to_home_tries',
1.0 * SUM(is_purchase) / SUM(is_home_try_on) AS 'home_tries_to_purchase'
FROM funnels;

--Counting the number of purchase among those, who received 3 pairs 

WITH funnels AS (
SELECT DISTINCT q.user_id,
  h.user_id IS NOT NULL AS 'is_home_try_on',
  h.number_of_pairs,
  p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on 'h'
  ON h.user_id = q.user_id
LEFT JOIN purchase 'p'
  ON p.user_id = h.user_id)
SELECT SUM(is_purchase) AS 'num_purchase_3_pairs'
FROM funnels
WHERE number_of_pairs ='3 pairs';

--Counting the number of purchase among those, who received 5 pairs

WITH funnels AS (
SELECT DISTINCT q.user_id,
  h.user_id IS NOT NULL AS 'is_home_try_on',
  h.number_of_pairs,
  p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on 'h'
  ON h.user_id = q.user_id
LEFT JOIN purchase 'p'
  ON p.user_id = h.user_id)
SELECT SUM(is_purchase) AS 'num_purchase_5_pairs' 
FROM funnels
WHERE number_of_pairs ='5 pairs';

--Checking for the 3 most popular chosen styles

SELECT style,
  COUNT(style) AS 'occurence'
FROM quiz
GROUP BY 1
ORDER BY 'occurence' DESC
LIMIT 3;

--Checking the most popular models

SELECT model_name,
  COUNT(model_name) AS 'occurence'
FROM purchase
GROUP BY 1
ORDER BY COUNT(*) DESC;