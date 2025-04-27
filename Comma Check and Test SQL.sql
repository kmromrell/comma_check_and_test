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
		test_score,
		test_percent,
		gender,
		absence_s1_rank AS absence_s1,
		absence_q3 AS absence_q3,
		support,
		support_class,
		most_impact_status AS impact,
		impact_with_tag AS impact_tag
	FROM comma_check_9
	JOIN comma_test_9 ON comma_check_9.student_id=comma_test_9.student_id
	JOIN students ON comma_check_9.student_id=students.student_id
);

-- Creating joint table for demographic data, check/test overall score data, and aggregated scores per comma rule for check/test for students who completed both the check and the test online. (No rule-specific data for students who completed the test on paper.)

CREATE
	VIEW all_rules AS (
		SELECT 
		comma_check_9.student_id,
		comma_check_9.period,
		score AS check_score,
		percentage AS check_percent,
		test_score,
		test_percent,
		gender,
		absence_s1_rank AS absence_s1,
		absence_q3 AS absence_q3,
		support,
		support_class,
		most_impact_status AS impact,
		impact_with_tag AS impact_tag,
		FANBOYS_all	AS fanboys_check,
		intro_all AS intro_check,
		quote_all AS quote_check,
		list_all AS list_check,
		date_address_all AS date_address_check,
		adjective_all AS adjective_check,
		extra_all AS extra_check,
		fanboys_test_all AS fanboys_test,
		intro_test_all AS intro_test,
		quote_test_all AS quote_test,
		list_test_all AS list_test,
		date_address_test_all AS date_address_test,
		adjective_test_all AS adjective_test,
		extra_test_all AS extra_test
	FROM comma_check_9
	JOIN comma_test_9 ON comma_check_9.student_id=comma_test_9.student_id
	JOIN students ON comma_check_9.student_id=students.student_id
	JOIN rule_check_9 ON comma_check_9.student_id=rule_check_9.student_id
	JOIN rule_test_9 ON comma_check_9.student_id=rule_test_9.student_id
);

-- Finding period averages (limiting to students who took both the check-in and the test)

SELECT 
	period,
	round(avg(check_precent), 2) AS check_avg_perc,
	round(avg(test_percent), 2) AS test_avg_perc
FROM all_data
GROUP BY
	period
ORDER BY
	period;
	
SELECT
	count(student_id)
FROM
	combined_data
WHERE 
	score IS NOT NULL
	AND test_score IS NOT NULL;
	
	
	



