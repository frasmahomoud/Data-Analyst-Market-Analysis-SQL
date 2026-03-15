/*
Question: What is the relative "Market Dominance" of each skill?
Goal: Use Window Functions to benchmark all skills against the #1 skill in the market.
*/
wITH skill_stats AS (
    SELECT 
        skills_dim.skills AS skill_name,
        COUNT(skills_job_dim.job_id) AS demand_count,
        round (AVG(JP.salary_year_avg))AS avg_salary
    FROM job_postings_fact AS JP
    INNER JOIN skills_job_dim ON JP.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND job_location = 'Anywhere' 
    GROUP BY
        skills_dim.skills
    HAVING
        COUNT(skills_job_dim.job_id) > 10
)

    SELECT 
    *,
    ROUND((demand_count::NUMERIC / MAX(demand_count) OVER()) * 100, 2) AS market_dominance_score
    FROM 
    skill_stats
    ORDER BY
    market_dominance_score DESC
    LIMIT 10;
