-- Updating percent columns to remove "%" and cast as floats so I can work with them as numeric data
UPDATE comma_check_9
SET percentage = REPLACE(percentage, '%', '');

ALTER TABLE comma_check_9
MODIFY COLUMN percentage FLOAT;

UPDATE comma_test_9
SET test_percent = REPLACE(test_percent, '%', '');

ALTER TABLE comma_test_9
MODIFY COLUMN test_percent FLOAT;

-- Creating a joint table view

CREATE
	VIEW combined_data AS (
		SELECT 
		comma_check_9.period,
		comma_check_9.student_id,
		score,
		percentage,
		test_score,
		test_percent
	FROM comma_check_9
	JOIN comma_test_9 ON comma_check_9.student_id=comma_test_9.student_id
);

-- Finding period averages (limiting to students who took both the check-in and the test)

SELECT 
	period,
	round(avg(percentage), 2) AS check_avg_perc,
	round(avg(test_percent), 2) AS test_avg_perc
FROM combined_data
WHERE 
	score IS NOT NULL
	AND test_score IS NOT NULL
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
	



