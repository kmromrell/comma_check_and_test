-- SQL CLEANING/CREATING THE ENVIRONMENT

-- Updating percent columns to remove "%" and cast as floats so I can work with them as numeric data
UPDATE comma_check_9
SET percentage = REPLACE(percentage, '%', '');

ALTER TABLE comma_check_9
MODIFY COLUMN percentage FLOAT;

UPDATE comma_test_9
SET test_percent = REPLACE(test_percent, '%', '');

ALTER TABLE comma_test_9
MODIFY COLUMN test_percent FLOAT;

-- Creating joint table for demographic data and check/test overall score data for students who completed both the check and the test

CREATE
	VIEW all_scores AS (
		SELECT 
		comma_check_9.student_id,
		comma_check_9.period,
		score AS check_score,
		percentage AS check_percent,
-- creating a field with the letter grade 
		CASE
			WHEN percentage >=90 THEN "A"
			WHEN percentage >=80 THEN "B"
			WHEN percentage >=70 THEN "C"
			WHEN percentage >=60 THEN "D"
			ELSE "F"
		END AS check_grade,
		test_score,
		test_percent,
		CASE
			WHEN test_percent >=90 THEN "A"
			WHEN test_percent >=80 THEN "B"
			WHEN test_percent >=70 THEN "C"
			WHEN test_percent >=60 THEN "D"
			ELSE "F"
		END AS test_grade,
-- calculating the growth/regression from the check to the test
		round(test_percent - percentage, 2) AS score_change,
		gender,
		absence_s1_rank AS absence_s1,
		absence_q3_rank AS absence_q3,
		support,
		support_class,
		most_impact_status AS impact,
		impact_with_tag AS impact_tag
	FROM comma_check_9
	JOIN comma_test_9 USING(student_id)
	JOIN demographics USING(student_id)
);

-- Creating joint table for demographic data, check/test overall score data, and aggregated scores per comma rule for check/test for students who completed both the check and the test online. (No rule-specific data for students who completed the test on paper.)

CREATE
	VIEW all_rules AS (
		SELECT 
		all_scores.student_id,
		test_percent,
		test_grade,
		weakness_test,
		weakness_tied_test,
		fanboys_test_all AS fanboys_test,
		intro_test_all AS intro_test,
		quote_test_all AS quote_test,
		list_test_all AS list_test,
		date_address_test_all AS date_address_test,
		adjective_test_all AS adjective_test,
		extra_test_all AS extra_test
	FROM all_scores
	JOIN rule_check_9 USING(student_id)
	JOIN rule_test_9 USING(student_id)
);

-- QUESTION #1: What were the average scores for the check-in and test? What was the typical improvement from the check-in to the test?

SELECT 
	count(student_id) AS total,
	round(avg(check_percent), 2) AS check_avg_perc,
	round(avg(test_percent), 2) AS test_avg_perc,
	round(avg(score_change), 2) AS growth
FROM all_scores;

WITH check_count AS (
	SELECT
		check_grade AS grade,
		count(check_grade) AS check_count
	FROM
		all_scores
	GROUP BY
		check_grade
	ORDER BY
		grade
),
	test_count AS (
	SELECT
		test_grade AS grade,
		count(test_grade) AS test_count
	FROM
		all_scores
	GROUP BY
		test_grade
	ORDER BY
		grade
)

SELECT
	test_count.grade,
	check_count,
	test_count
FROM
	check_count
JOIN test_count ON check_count.grade=test_count.grade;

-- QUESTION #2: How did the scores/growth vary by period and demographic factors (e.g., gender, enrollment in support class, attendance, etc.)?

SELECT 
	period,
	count(student_id) AS total,
	round(avg(check_percent), 2) AS check_avg_perc,
	round(avg(test_percent), 2) AS test_avg_perc,
	round(avg(score_change), 2) AS growth
FROM all_scores
GROUP BY
	period
ORDER BY
	period;

SELECT 
	gender,
	count(student_id) AS total,
	round(avg(check_percent), 2) AS check_avg_perc,
	round(avg(test_percent), 2) AS test_avg_perc,
	round(avg(score_change), 2) AS growth
FROM all_scores
GROUP BY
	gender;
	
SELECT 
	absence_q3,
	count(student_id) AS total,
	round(avg(check_percent), 2) AS check_avg_perc,
	round(avg(test_percent), 2) AS test_avg_perc,
	round(avg(score_change), 2) AS growth
FROM all_scores
GROUP BY
	absence_q3
ORDER BY
	test_avg_perc DESC;

SELECT 
	absence_s1,
	count(student_id) AS total,
	round(avg(check_percent), 2) AS check_avg_perc,
	round(avg(test_percent), 2) AS test_avg_perc,
	round(avg(score_change), 2) AS growth
FROM all_scores
GROUP BY
	absence_s1
ORDER BY
	test_avg_perc DESC;

SELECT 
	support_class,
	count(student_id) AS total,
	round(avg(check_percent), 2) AS check_avg_perc,
	round(avg(test_percent), 2) AS test_avg_perc,
	round(avg(score_change), 2) AS growth
FROM all_scores
GROUP BY
	support_class
ORDER BY
	test_avg_perc DESC;

SELECT 
	impact,
	count(student_id) AS total,
	round(avg(check_percent), 2) AS check_avg_perc,
	round(avg(test_percent), 2) AS test_avg_perc,
	round(avg(score_change), 2) AS growth
FROM all_scores
GROUP BY
	impact
ORDER BY
	test_avg_perc DESC;

SELECT 
	impact_tag,
	count(student_id) AS total,
	round(avg(check_percent), 2) AS check_avg_perc,
	round(avg(test_percent), 2) AS test_avg_perc,
	round(avg(score_change), 2) AS growth
FROM all_scores
GROUP BY
	impact_tag
ORDER BY
	test_avg_perc DESC;

-- QUESTION #3: Which rule did students struggle with most on the test?

-- Note: This coding only includes students who took the test digitally (n=65) rather than on paper (n=30) since I don't have the weakness data for paper copies

WITH weakness AS (
	SELECT
		weakness_test,
		count(weakness_test) AS weakness_count
	FROM
		all_rules
-- Excluding students who had no weaknesses (i.e., got 100%)
	WHERE
		weakness_test <> ""
	GROUP BY
		weakness_test
),
	weakness_2 AS (
	SELECT
		weakness_tied_test,
		count(weakness_tied_test) AS weakness_2_count
	FROM
		all_rules
-- Excluding students who didn't tie for weakness
	WHERE
		weakness_tied_test <> ""
	GROUP BY
		weakness_tied_test
)

SELECT
	weakness_test AS all_weakness,
-- Use coalesce to address the NULL values resulting from left joining the tied weakness to weakness
	weakness_count + coalesce(weakness_2_count, 0) AS all_weakness_count
FROM
	weakness
LEFT JOIN weakness_2 ON weakness.weakness_test=weakness_2.weakness_tied_test
ORDER BY
	all_weakness_count DESC;
	
	
-- QUESTION #4: How many students failed the test? Did they also fail the check-in? Who are they? 

SELECT
	student_id,
	check_percent,
	test_percent
FROM
	all_scores
WHERE
	test_percent<60
ORDER BY
	test_percent;

-- This query tells me the students names using data that is private for confidentiality reasons

SELECT
	first_name,
	last_name,
	test_percent,
	check_percent,
	all_scores.student_id
FROM
	all_scores
JOIN names ON all_scores.student_id=names.student_id
WHERE
	test_percent<60
ORDER BY
	test_percent;
