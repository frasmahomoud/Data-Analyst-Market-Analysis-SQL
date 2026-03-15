/*
Question: What are the top skills based on salary?
Goal: Look at the average salary associated with specific technical skills.
*/
SELECT 
skills_dim.skills,
    ROUND(AVG(jp.salary_year_avg)) as salary_yearly
        from job_postings_fact as JP
INNER JOIN skills_job_dim ON
 JP.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON
 skills_job_dim.skill_id = skills_dim.skill_id
        where 
jp.job_title_short = 'Data Analyst' and
JP.job_location = 'Anywhere' AND
salary_year_avg is NOT NULL
    GROUP BY skills_dim.skills 
    HAVING COUNT(DISTINCT JP.job_id) > 30
ORDER BY salary_yearly DESC
