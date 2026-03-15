/*
Question: What skills are required for the top-paying data analyst jobs?
Goal: Find the core technical requirements of the highest-earning professionals.
*/
with top_paying_jobs as (SELECT 
  JP.job_id ,
    job_title_short,
    salary_year_avg,
    company_dim.name AS COMPANY_NAME,
    JP.job_location
    FROM job_postings_fact AS JP
    LEFT JOIN company_dim ON JP.Company_id = company_dim.company_id
    where 
   JP.salary_year_avg IS NOT NULL AND
    job_location = 'Anywhere' AND
     JP.job_title_short  LIKE '%Data Analyst%'
   order by JP.salary_year_avg DESC
   LIMIT 10 )
   SELECT 
   top_paying_jobs.job_title_short,
   top_paying_jobs.COMPANY_NAME,
      skills_dim.skills,
   top_paying_jobs.salary_year_avg
   from top_paying_jobs
   INNER JOIN skills_job_dim ON 
   top_paying_jobs.job_id = skills_job_dim.job_id
   INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
  
