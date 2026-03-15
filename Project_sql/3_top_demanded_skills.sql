/*
Question: What are the most in-demand skills for data analysts?
Goal: Identify the skills appearing most frequently in job postings.
*/
SELECT 
skills_dim.skills,
    count(skills_dim.skills)
        from job_postings_fact as JP
INNER JOIN skills_job_dim ON
 JP.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON
 skills_job_dim.skill_id = skills_dim.skill_id
        where 
jp.job_title_short = 'Data Analyst' and
JP.job_location = 'Anywhere'
    GROUP BY skills_dim.skills 
ORDER BY count(skills_dim.skills) DESC
