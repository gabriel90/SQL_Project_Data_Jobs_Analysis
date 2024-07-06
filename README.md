# Introduction
This project looks at job posting data to analyze what skills 
are needed for a machine learning engineer job, which skills 
are in-demand, which are the highest-paying skills, and 
where high demand meets high salary.

SQL queries? Check them out here:
[project_sql folder](/project_sql/)

# Background
Motivated by the need to navigate the machine learning engineer job 
market and understand SQL, this project was born to fill 
this need and to discover the highest-paying skills for 
machine learning engineers in the state of California. 

The data and idea for the project comes from [Luke Barousse](https://www.lukebarousse.com/sql).

## The questions I wanted answered using SQL were:

1. What are the top-paying jobs for my role?
2. What are the skills required for these top-paying roles?
3. What are the most in-demand skills for my role?
4. What are the top skills based on salary for my role?
5. What are the most optimal skills to learn?
    1. Optimal: High Demand and High Paying

# Tools I Used
In order to discover the necessary insights in the machine learning 
engineer job market, multiple tools were used.

- **SQL**: The most important tool that was used to query the 
database and uncover important insights in the job market.
- **PostgreSQL**: This database was chosen because the data was in a 
simple csv format and would be easy to install and configure.
- **Visual Studi Code**: A powerful code editor that allowed me to 
quickly write SQL queries and run them within the editor 
and also view the reaults of the query within the editor.
- **Git & Github**: Git was used for keeping track of changes 
and Github for hosting this repository remotely for public 
viewing.

# The Analysis

## 1. Top Paying Machine Learning Engineer Jobs
In this first part I wanted to find the top 10 machine learning engineer 
roles with the highest average yearly salary that are located in 
California.

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
WHERE
    job_title_short = 'Machine Learning Engineer' AND
    job_location LIKE '%, CA' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```
Here is an analysis of the results:

- **Salary:** The salaries range from a minimum of $225,500 to a maximum of $315,000 with 
a standard deviation of $30,791.54. The salary range varies quite a bit but is fairly 
narrow. 
- **Employers:** The top paying employers are very large and well known tech companies
which include Nvidia, OpenAI, and TikTok. 
- **Job Title Variety:** There is a large variety of job titles, which mainly are senior 
level positions or researcher level positions. The results include titles such as 
Senior AI Platform Engineer, Director of ML Research, Sr. Machine Learning Engineer, 
and Principal Machine Learning Researcher.

![Job Title Salary](/assets/job_title_salary)
*Bar graph visualizing the results of the top 10 highest salaries 
for machine learning engineers located in California. This bar graph 
was generated using ChatGPT from the SQL query results.*

## 2. Top Paying Job Skills

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
    WHERE
        job_title_short = 'Machine Learning Engineer' AND
        job_location LIKE '%, CA' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON skills_job_dim.job_id = top_paying_jobs.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
```
An analysis of the top skills:
- **TensorFlow & PyTorch:** Both have a count 5. This makes sense that these 
would be in the top as both are the most popular libraries used tob build and 
train machine learning models.
- **Go:** Has a count of 4 and is a suprise python is the more well known 
language for machine learning.
- **Python:** Has a count of 3. This low of a count for python is a 
suprise as it is the go to language for machine learning engineering.


![Skills Count For Top Jobs](/assets/2_skills_count.png)
*This bar graph was created using ChatGPT.*

## 3. In-Demand Skills For Machine Learning Engineers

This query helped me identify the top 5 most in-demand skills 
for machine learning engineer jobs. This will help me focus 
on what skills will have the most impact on getting a job 
in that field.

```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Machine Learning Engineer'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5
```
Here's a breakdown of what the most in-demand skills are machine learning 
engineers for 2023 are:

- **Python:** Clearly knowing how to program is the most import skills for 
engineers with python having more than double the count of the second skill.
- **PyTorch & TensorFlow:** These are no suprise as they are known to be 
the most popular machine learning libraries around.
- **AWS:** What I take away from AWS showing up on the list is that knowing 
how to use a cloud services provider is very important and probably 
because you can use it to train your machine learning models and 
deploy them.
- **SQL:** SQL is also a very important language to know as it is widely used to 
query and retrieve data from databases in an efficient manner. Clearly an important 
skill to know.

|Skils        |Demand Count|
|-------------|------------|
|python       |        9685|
|pytorch      |        4389|
|tensorflow   |        4307|
|aws          |        3780|
|sql          |        3497|

## 4. Top-Paying Skills Based on Salary

Here we query the database to obtain the highest-paying skills for machine learning 
engineers located in California.

```sql
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
```

Here's a breakdown of the top-paying skills for machine learning engineers
located in California:

- **Programming:** We can see that top salaries are commanded by those who know 
how to program. 4 out of the top 10 results are programming languages and 
they are in the top 5. These include scala, c, julia, and haskell.
- **Data Processing:** We have results like Snowflake, Databricks, and Hadoop. 
These are all platforms and tools used to process, analyze, and warehouse 
large amounts of data and knowing these skills pays very well.
- **OS:** Linux tops the list as the important OS to know. This very likely the 
case because linux can be very lightweight and is the most deployed os for 
server tasks.

| skills       | avg_salary |
|--------------|------------|
| linux        | 253000     |
| scala        | 220000     |
| c            | 216549     |
| julia        | 213000     |
| haskell      | 213000     |
| snowflake    | 207500     |
| hugging face | 207500     |
| postgresql   | 207500     |
| databricks   | 195625     |
| hadoop       | 195271     |

## 5. Most Optimal Skills to Learn

Combining insights from demand and salary data, this query aimed to identify 
skills that are both highly sought-after and well-compensated, providing a 
strategic focus for skill development.

```sql
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Machine Learning Engineer' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skill_id
ORDER BY
    demand_count DESC,
    avg_salary DESC
LIMIT 10
```

| skill_id |    skills   | demand_count | avg_salary |
|----------|-------------|--------------|------------|
|     1    |    python   |     391      |   $129,781 |
|    99    | tensorflow  |     195      |   $133,798 |
|    101   |   pytorch   |     190      |   $133,475 |
|    76    |      aws    |     174      |   $129,832 |
|    92    |     spark   |     113      |   $138,904 |
| 0        |     sql     |     112      |   $136,859 |
| 214      |    docker   |     110      |   $129,329 |
| 4        |    java     |     106      |   $137,184 |
| 74       |    azure    |      93      |   $119,893 |
| 213      |  kubernetes |      89      |   $133,817 |

*Table of the most optimal skills for machine learning engineers 
ordered by demand count.*

Here is an analysis of the most optimal machine learning skills for 2023:

- **Programming Languages:** Here we see python, sql, and java make the list.
Python tops the list as the most optimal skill due to its high demand and high 
salary. Python has a count of 391, almost more than double the than the 
skill below it. It also has a high average salary of $129,781. This means 
that proficiency in this language is highly valued and widely available.
- **Cloud & Deploment Tools:** Skills in platforms such as aws and azure show 
high demand and very high salaries. We also have import deployment technologies 
such as docker and kubernetes demading high salaries as well. This all points 
to the importance of knowing how to deploy machine learning model on cloud 
platforms with containerization tools.
- **Machine Learning:** Here we see that TensorFlow and Pytorch dominate when 
it comes to high salaries and high demand compared to any other machine 
learning libraries. Clearly there is demand for anyone that has a good 
handle on these skills .   

# What I Learned

Throughout this project I've learned some very valuable SQL skills:

- **Query Crafting:** Learned how to select the correct columns from a 
table along with creating subqueries and CTEs for more complex data 
extraction needs using the WITH keyword. 
- **Data Aggregation:** Used GROUP BY along with COUNT and AVG to create 
data summarizations.
- **Analytical:** Learned how to use SQL to solve real world problems 
and gain powerful insights from data.

# Conclusion

## Insights

1. **Top-Paying Machine Learning Engineer Jobs:** We can 
see that being a machine learning engineer has a very high average salary 
with the highest being $315,000. 
2. **Skills for Top-Paying Jobs:** Programming expertise comes in as 
the most valuable skill to know for machine learning. Knowing languages 
such as python, sql, and java rank amongst the highest paid and therefore 
are the most important to know. 
3. **Optimal Skills for Job Market Value:** The most optimal skills clearly 
come from knowing how to program in python and how to use the most widely 
know machine learning libraries such as tensorflow and pytorch. Without 
these skills one cannot expect to work in the machine learning field and 
demand a high compensation.