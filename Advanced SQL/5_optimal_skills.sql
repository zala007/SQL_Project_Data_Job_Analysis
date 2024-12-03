WITH demanded_job AS ( 
    SELECT 
        skills_dim.skill_id,
        skills,
        COUNT(skills_dim.skill_id) AS demand_count
    FROM 
        job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
    GROUP BY
            skills_dim.skill_id
), average_salary AS ( 
    SELECT
    skills_dim.skill_id, 
    skills,
    ROUND(AVG(salary_year_avg),2) AS avg_salary
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
GROUP BY 
            skills_dim.skill_id
)

SELECT 
    demanded_job.skills,
    demand_count,
    avg_salary
FROM
    demanded_job
INNER JOIN average_salary ON demanded_job.skills = average_salary.skills
ORDER BY
    demand_count DESC,
    avg_salary DESC;


