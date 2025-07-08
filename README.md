# comma_check_and_test
## 📚 Comma Rules Mastery Analysis
### 📝 Project Overview
This project analyzes student performance on an ungraded check-in quiz and a graded test after targeted comma instruction. The goal was to measure growth, identify persistent weaknesses, and highlight trends by period and demographic group. All analysis was conducted using MySQL after initial cleaning in Google Sheets.

### ❓ Analysis Questions
1. **Average Improvement**: What were the average scores for the check-in and the test? What was the typical improvement between the two?
2. **Demographic and Period Trends**: How did scores and growth vary by period and demographic factors (gender, support class enrollment, attendance, etc.)?
3. **Comma Rule Weaknesses**: Which comma rule(s) did students continue to struggle with most on the test?
4. **Failure Rates**: How many students failed the test? Did they also fail the check-in?

### 🛠️ Data Cleaning and Analysis
* **Initial Google Sheets Cleaning**: Generated student_id, translated test responses/demographic attributes into 1/0 binary, calculated avg score per comma rule, used XLOOKUP to identify weakest comma rules, addressed inconsistencies in formatting
* **Final Cleaning in SQL**: Removed % symbol and cast percents as floats, created VIEW to reduce future JOIN requirements,created letter grade string
* **Analysis in SQL**: Identified averages, growth, demographic breakdowns, rule weaknesses, and students needing additional support

### 🧮 Key SQL Functions Used
* **SQL Basics**: `SELECT`, `FROM`, `WHERE`, `ORDER BY`, `AS`, basic operators/arithmetic
* **Aggregation**: `GROUP BY`, `COUNT()`, `AVG()`, `ROUND()`
* **Joins & Combination Queries**: `JOIN`, `LEFT JOIN`, `USING()`, `WITH` CTEs
* **Conditional Expressions**: `CASE WHEN ... THEN ... ELSE ... END`, `COALESCE()`
* **Table Design & Cleaning**: `CREATE VIEW`, `ALTER TABLE`, `MODIFY COLUMN`, `UPDATE`, `SET`, `REPLACE()`

### 🧠 Analysis Question Answers
1. **Average Improvement**: Students grew 11% on average (low C average on the check-in, low B average on the test)
2. **Demographic and Period Trends**:
   * Period A1 received the highest scores and A4 receive the lowest, but A4 also showed the most improvement
   * Students in support classes did poorer on both the check-in and test but generally showed more growth. This wasn't the case for the LSC class.
   * Test results varied by impact status. TAG students scored significantly higher but showed less growth. 504/IEP students scored lower, with IEP students showing less relative growth as well. ELL students regressed on the test, but since there are only two ELL students, it is hard to generalize those results.
   * Attendance did not appear significantly correlated with score
3. **Comma Rule Weaknesses**: Students struggled most with commas for coordinate adjectives, FANBOYS, and quotes/dialogue
4. **Failure Rates**: 6 students failed the comma test. All received an F/low D on the check-in and showed low or regressive growth from the check-in to the test

### ✅ Data-informed Recommendations
* Reteach commas for coordinate adjectives, FANBOYS, and quotes/dialogue
* Reach out to LSC (class supporting students with IEPs) and organize additional reviews of comma rules
* Continue instruction to give students/groups with high growth rates but lower scores the chance to catch up
* Pull 6 failing students in for additional practice
