SELECT 
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
LIMIT 10
