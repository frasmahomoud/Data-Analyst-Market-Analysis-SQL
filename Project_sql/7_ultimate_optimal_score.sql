/*
Question: What is the single "Ultimate Optimal Score" for each skill?
Goal: 
  1. Calculate the market volume (Demand) and financial value (Average Salary) per skill.
  2. Normalize both metrics into a 0-100 score using Window Functions (MAX OVER).
  3. Combine them into an "Ultimate Optimal Score" to rank skills by their overall career value.
Rationale: This avoids the "Apples vs. Oranges" problem by giving equal weight to both demand and salary.
*/
WITH skill_stats AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills AS skill_name,
        COUNT(DISTINCT JP.job_id) AS demand_count,
        AVG(JP.salary_year_avg) AS avg_salary
    FROM job_postings_fact AS JP
    INNER JOIN skills_job_dim ON JP.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        JP.job_title_short = 'Data Analyst'
        AND JP.job_location = 'Anywhere'
    GROUP BY 
        skills_dim.skill_id,
        skills_dim.skills 
    HAVING COUNT(DISTINCT JP.job_id) > 250                                                    
),

scores_calculation AS (
    SELECT
        skill_id,
        skill_name,
        demand_count,
        avg_salary,
        (demand_count::NUMERIC / MAX(demand_count) OVER()) * 100 AS demand_score,
        (avg_salary::NUMERIC / MAX(avg_salary) OVER()) * 100 AS salary_score
    FROM skill_stats
    WHERE avg_salary IS NOT NULL
)

SELECT
    skill_name,
    demand_count,
    ROUND(avg_salary, 0) AS avg_salary,
    ROUND(demand_score, 2) AS demand_score,
    ROUND(salary_score, 2) AS salary_score,
    ROUND((demand_score + salary_score) / 2, 2) AS ultimate_optimal_score
FROM scores_calculation
ORDER BY ultimate_optimal_score DESC
LIMIT 15
