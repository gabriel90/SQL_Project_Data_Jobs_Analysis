/*
Question: What are the top skills based on salary?
- Look at the average salary asscociated with each skill for machine learning engineer positions.
- Focuses on roles with specified salaries, regardless of location.
- Why? It reveals how different skills impact salary levels for machine learning engineers and 
    helps identify the most finacially rewarding skills to acquire or improve.
*/

SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Machine Learning Engineer' AND
    salary_year_avg IS NOT NULL AND 
    job_location LIKE '%, CA'
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25