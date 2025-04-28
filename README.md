# comma_check_and_test
## 📚 Comma Rules Mastery Analysis
### 📝 Project Overview
As a Freshman English teacher, I designed a unit to assess and support student learning of seven standard comma rules. After the initial comma instruction, students completed an ungraded comma check-in quiz. They then received targeted study materials to help them practice their weakest rules and were given a graded comma test two weeks later. This project analyzes the effectiveness of the practice in creating growth and explores trends across periods and demographics using MySQL.

#### Research Questions
* **Average Improvement**: What were the average scores for the check-in and the test? What was the typical improvement between the two?
* **Demographic and Period Trends**: How did scores and growth vary by period and demographic factors (gender, support class enrollment, attendance, etc.)?
* **Comma Rule Weaknesses**: Which comma rule(s) did students continue to struggle with most on the test?
* **Failure Rates**: How many students failed the test? Did they also fail the check-in?

### 🗂️ Data Overview
#### Data Sources: Cleaned and anonymized data can be found in "Tables" folder 
* **Check-In and Test Data**: Collected through Google Forms quizzes
* **Demographic Data**: Exported from Synergy (student records system)

#### Table Key
* comma_check_9: Check-in quiz results
* comma_test_9: Test results
* demographics: Student demographic information
* rule_check_9:  Aggregated scores per comma rule in check-in
* rule_test_9:  Aggregated scores per comma rule in test
* names: Private file with student names correlated to ID numbers (excluded from public uploads)

#### Repository Files/Folders
* README.md: Project overview and documentation.
* comma_rules_analysis.sql: Full SQL code for cleaning, creating tables, and answering research questions
* TABLES/: folder including all non-confidential datasets

### 🛠️ Data Cleaning and Analysis
#### Data Preparation: Initial cleaning was completed in Google Sheets unless otherwise specified
* Assigned randomized student ID numbers to ensure anonymity and lined up IDs across multiple sheets
* Translated check-in/test responses into binary (1 = correct, 0 = incorrect) or partial credit decimals
* Converted demographic attributes (e.g., support class enrollment, ELL status, etc.) into binary fields
* Addressed empty cells, inconsistent formatting, and correcting errors in demographic data
* Aggregated comma question data into comma rules fields (i.e., averaging the results of all questions about FANBOYS into one rule column)
* Used XLOOKUP to identify each student's weakest comma rule in the check-in and test
* Translated percentage columns from strings to floats by removing % signs and recasting (in SQL)
* Created string field assigning letter grades to the check-in/test score percentages (in SQL)

#### SQL Analysis Highlights
* Created all_scores and all_rules view (combining scores and demographics in the first, aggregating rule-specific performance in the second)
* Analyzed averages, growth, demographic breakdowns, and rule weaknesses
* Identified students needing additional support

#### Key SQL Functions Used
* UPDATE SET and ALTER TABLE, MODIFY COLUMN for cleaning
* CREATE VIEW, WITH clauses, and CTEs to simplify data retrieval process
* JOIN clauses for combining various datasets
* CASE WHEN for creating a new field
* WITH clauses and CTEs for easier aggregation
* COALESCE to address null values
* ROUND, AS, and ORDER BY to make data readable and functional
* AVG, COUNT, GROUP BY for data aggregation

#### Sample Results
This data results from the first query under "QUESTION #2" in the SQL code
| Period | Total Students | Check-In Avg (%) | Test Avg (%) | Growth (%) |
|:------:|:--------------:|:----------------:|:------------:|:----------:|
| A1     | 25             | 75.6             | 85.74        | 10.14      |
| A4     | 22             | 62.15            | 78.49        | 16.35      |
| B7     | 25             | 71.67            | 80.85        | 9.19       |
| B8     | 23             | 73.93            | 83.74        | 9.81       |

### 🧠 Conclusions and Next Steps
#### Research Question Answers
* **Average Improvement**: On average, students received a low C on the check-in and a low B on the test, demonstrating an average growth of 11%
* **Demographic and Period Trends**:
  * Period A1 received the highest scores and A4 receive the lowest, but A4 showed the most improvement
  * Students enrolled in support classes did poorer on the check-in/test but generally showed more growth. This wasn't the case for the LSC class.
  * Test results varied by impact status (e.g., students with IEPs, 504 plans, ELL status, TAG status, etc.). TAG students scored significantly higher (but showed less growth). 504/IEP students scored lower, with IEP students showing less relative growth as well. ELL students regressed on the test, but since there are only two ELL students, it is hard to generalize those results.
  * Attendance did not appear to be significantly correlated with score
* **Comma Rule Weaknesses**: Students struggled most with commas for coordinate adjectives, FANBOYS, and quotes/dialogue 
* **Failure Rates**: Overall, 6 students failed the comma test, all of which received a low D or lower on the check-in. These students all showed low or regressive growth from the check-in to the test

#### Data-informed Recommendations
* Reteach commas for coordinate adjectives, FANBOYS, and quotes/dialogue
* Reach out to LSC (who supports the students with IEP) and organize additional reviews and learning of comma rules
* Continue instruction to give students/groups with high growth rates but lower scores the chance to catch up

#### Future Analysis Improvements
* Include visualization (e.g., rule struggles by pie chart, period/group comparison bar charts, numerical rather than ordinal attendance data by score in scatterplot to see if data grouping is obscuring a relationship)
* Compare check-in rule weaknesses to test rule weaknesses to see if the rules students struggled with were consistent
* Expand analysis to include the short-answer test questions that were not included in this analysis due to time constraints
