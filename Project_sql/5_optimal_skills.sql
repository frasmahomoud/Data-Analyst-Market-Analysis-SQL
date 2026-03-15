/*
Question: What are the most optimal skills to learn (High Demand AND High Salary)?
Goal: Identify skills that offer both job security (high demand) and financial upside (high salary).
*/
WITH skills_demand as (
    SELECT
    skills_dim.skills,
     COUNT(DISTINCT JP.job_id) AS demand_count,
        skills_dim.skill_id
          from job_postings_fact as JP
            INNER JOIN skills_job_dim ON
               JP.job_id = skills_job_dim.job_id
                 INNER JOIN skills_dim ON
                  skills_job_dim.skill_id = skills_dim.skill_id
                    where 
                      jp.job_title_short = 'Data Analyst' and
                       JP.job_location = 'Anywhere'
                         GROUP BY skills_dim.skills, 
                           skills_dim.skill_id
)
   ,salary_yearly as (SELECT 
    skills_dim.skills,
    
        ROUND(AVG(jp.salary_year_avg)) as salary_yearly,
        skills_dim.skill_id
                from job_postings_fact as JP
                INNER JOIN skills_job_dim ON
                 JP.job_id = skills_job_dim.job_id
                 INNER JOIN skills_dim ON
                  skills_job_dim.skill_id = skills_dim.skill_id
                          where 
                          jp.job_title_short = 'Data Analyst' and
                          JP.job_location = 'Anywhere' AND
                          salary_year_avg is NOT NULL
                              GROUP BY skills_dim.skills ,
                              skills_dim.skill_id
)
    SELECT 
    skills_demand.skills,
    skills_demand.demand_count,
    salary_yearly.salary_yearly
    from skills_demand
    INNER JOIN salary_yearly ON
    skills_demand.skill_id = salary_yearly.skill_id
    ORDER BY 
    demand_count DESC
