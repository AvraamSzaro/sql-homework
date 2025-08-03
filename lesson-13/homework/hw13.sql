--Easy Tasks
--1
select CAST(employee_id as varchar)+'-'+first_name+' '+last_name as output
from employees
where employee_id=100;
--2
select
	studentID,
	fullname,
	grade,
	sum(grade) over(order by studentid) as cumulative_grade
from students;
--3
select distinct first_name, len(first_name) as length
from employees
where first_name like 'A%'
	or first_name like 'J%'
	or first_name like 'M%';
--4
select
	manager_id,
	sum(salary) as ttl_salary
from employees
group by manager_id
order by manager_id
--5
select year1, GREATEST(max1, max2,max3) as greatestof3
from testmax
--6
select *
from cinema
where id%2=1 
	and description <> 'boring'; -- or not like
--7
select *
from singleorder
order by case when id=0 then 99999 else id end;
--8
select 
	id,
	coalesce(ssn, passportid, itin) as nonnull
from person;
--Medium Tasks
--1
select
	studentid,
	fullname,
	PARSENAME(REPLACE(fullname, ' ', '.'), 3) AS FirstName,
	PARSENAME(REPLACE(fullname, ' ', '.'), 2) AS MiddleName,
	PARSENAME(REPLACE(fullname, ' ', '.'), 1) AS LastName
from students;
--3
select 
	STRING_AGG(string, ' ') within group(order by sequencenumber) as fullstatement
from dmltable;
--4
select CONCAT(first_name, ' ', last_name)
from employees
where CONCAT(first_name, ' ', last_name) like '%a%a%a%';
--5
select 
	department_id,
	count(*) as ttlemp,
	sum(
		case
			when datediff(year, hire_date, getdate())>3 then 1
			else 0
		end) as EmpOver3,
	CAST(SUM(CASE
				when datediff(year, hire_date, getdate())>3 then 1
				else 0
			end) * 100/count(*) as decimal(5,2)) as percentageOver3
from employees
group by department_id;
--6
WITH RankedMissions AS (
    SELECT 
        SpacemanID,
        JobDescription,
        MissionCount,
        ROW_NUMBER() OVER (PARTITION BY JobDescription ORDER BY MissionCount DESC) AS MaxRank,
        ROW_NUMBER() OVER (PARTITION BY JobDescription ORDER BY MissionCount ASC) AS MinRank
    FROM Personal
)
SELECT 
    JobDescription,
    MAX(CASE WHEN MaxRank = 1 THEN SpacemanID END) AS MostExperienced,
    MAX(CASE WHEN MinRank = 1 THEN SpacemanID END) AS LeastExperienced
FROM RankedMissions
GROUP BY JobDescription;
--Difficult Tasks
--1
WITH chars AS (
  SELECT 
    SUBSTRING('tf56sd#%OqH', number, 1) AS ch
  FROM master.dbo.spt_values
  WHERE type = 'P' AND number BETWEEN 1 AND LEN('tf56sd#%OqH')
),
classified AS (
  SELECT
    ch,
    CASE 
      WHEN ch LIKE '[A-Z]' THEN 'Upper'
      WHEN ch LIKE '[a-z]' THEN 'Lower'
      WHEN ch LIKE '[0-9]' THEN 'Digit'
      ELSE 'Other'
    END AS char_type
  FROM chars
)
SELECT
  STRING_AGG(CASE WHEN char_type = 'Upper' THEN ch ELSE NULL END, '') AS Uppercase,
  STRING_AGG(CASE WHEN char_type = 'Lower' THEN ch ELSE NULL END, '') AS Lowercase,
  STRING_AGG(CASE WHEN char_type = 'Digit' THEN ch ELSE NULL END, '') AS Numbers,
  STRING_AGG(CASE WHEN char_type = 'Other' THEN ch ELSE NULL END, '') AS Others
FROM classified;
--2
select studentid, fullname, Grade,
sum(Grade) over(order by studentid) as ttlcumulative
from students
--4
SELECT *
FROM Student
WHERE Birthday IN (
    SELECT Birthday
    FROM Student
    GROUP BY Birthday
    HAVING COUNT(*) > 1
)
ORDER BY Birthday, StudentName;
--5
SELECT 
  CASE 
    WHEN PlayerA < PlayerB THEN PlayerA 
    ELSE PlayerB 
  END AS Player1,
  CASE 
    WHEN PlayerA < PlayerB THEN PlayerB 
    ELSE PlayerA 
  END AS Player2,
  SUM(Score) AS TotalScore
FROM PlayerScores
GROUP BY 
  CASE 
    WHEN PlayerA < PlayerB THEN PlayerA 
    ELSE PlayerB 
  END,
  CASE 
    WHEN PlayerA < PlayerB THEN PlayerB 
    ELSE PlayerA 
  END;  