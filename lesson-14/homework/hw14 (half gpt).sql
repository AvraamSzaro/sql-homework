--Easy Tasks
--Write a SQL query to split the Name column by a comma into two separate columns: Name and Surname.(TestMultipleColumns)
select
	SUBSTRING(name, 1, CHARINDEX(',', name)-1),
	SUBSTRING(name, CHARINDEX(',', name)+1, LEN(name)-CHARINDEX(',', name))
from TestMultipleColumns
--Write a SQL query to find strings from a table where the string itself contains the % character.(TestPercent)
SELECT 
    SUBSTRING(Name, 1, CHARINDEX(',', Name) - 1) AS Name,
    SUBSTRING(Name, CHARINDEX(',', Name) + 1, LEN(Name)) AS Surname
FROM TestMultipleColumns
WHERE CHARINDEX(',', Name) > 0;
from TestPercent
--In this puzzle you will have to split a string based on dot(.).(Splitter)
SELECT
  CASE 
    WHEN CHARINDEX('.', Vals) > 0 
      THEN LEFT(Vals, CHARINDEX('.', Vals) - 1)
    ELSE Vals
  END AS a1,
  CASE 
    WHEN CHARINDEX('.', Vals) > 0 
      THEN SUBSTRING(Vals, CHARINDEX('.', Vals) + 1, LEN(Vals) - CHARINDEX('.', Vals))
    ELSE NULL
  END AS a2
FROM Splitter;
--Write a SQL query to replace all integers (digits) in the string with 'X'.(1234ABC123456XYZ1234567890ADS)
create table replace_digits(txt varchar(100))
insert into replace_digits values
('1234ABC123456XYZ1234567890ADS')
select
	TRANSLATE(txt, '0123456789', 'XXXXXXXXXX') AS Replaced
from replace_digits
--Write a SQL query to return all rows where the value in the Vals column contains more than two dots (.).(testDots)
select
	*
from testdots
where LEN(vals) - LEN(REPLACE(vals, '.', '')) > 2;
--Write a SQL query to count the spaces present in the string.(CountSpaces)
SELECT 
    texts,
    LEN(texts) - LEN(REPLACE(texts, ' ', '')) AS SpaceCount
FROM CountSpaces;
--write a SQL query that finds out employees who earn more than their managers.(Employee)
SELECT e.Id, e.Name, e.Salary, e.ManagerId
FROM Employee e
JOIN Employee m 
    ON e.ManagerId = m.Id
WHERE e.Salary > m.Salary;
--Find the employees who have been with the company for more than 10 years, but less than 15 years. Display their Employee ID, First Name, Last Name, Hire Date, and the Years of Service (calculated as the number of years between the current date and the hire date).(Employees)
SELECT
    EMPLOYEE_ID, 
    FIRST_NAME, 
    LAST_NAME, 
    HIRE_DATE,
    DATEDIFF(YEAR, HIRE_DATE, GETDATE()) AS YearsOfService
FROM Employees
WHERE DATEDIFF(YEAR, HIRE_DATE, GETDATE()) > 10
  AND DATEDIFF(YEAR, HIRE_DATE, GETDATE()) < 15;
--medium tasks
--Write a SQL query to separate the integer values and the character values into two different columns.(rtcfvty34redt)
WITH t(s) AS (
    SELECT 'rtcfvty34redt'
)
SELECT
    -- letters only (remove digits)
    REPLACE(TRANSLATE(s, '0123456789', '##########'), '#', '') AS Letters,
    -- digits only (remove letters; both cases)
    REPLACE(TRANSLATE(s,
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ',
        REPLICATE('#', 52)
    ), '#', '') AS Digits
FROM t;
--write a SQL query to find all dates' Ids with higher temperature compared to its previous (yesterday's) dates.(weather)
SELECT w1.Id, w1.RecordDate, w1.Temperature
FROM weather w1
JOIN weather w2 
   ON w2.RecordDate = DATEADD(DAY, -1, w1.RecordDate)
WHERE w1.Temperature > w2.Temperature;
--Write an SQL query that reports the first login date for each player.(Activity)
select
	player_id,
	MIN(event_date) as firstlogin
from activity
group by player_id
--Your task is to return the third item from that list.(fruits)
SELECT
    LTRIM(RTRIM(
        SUBSTRING(
            fruit_list,
            CHARINDEX(',', fruit_list, CHARINDEX(',', fruit_list) + 1) + 1,
            CHARINDEX(',', fruit_list, CHARINDEX(',', fruit_list, CHARINDEX(',', fruit_list) + 1) + 1)
              - (CHARINDEX(',', fruit_list, CHARINDEX(',', fruit_list) + 1) + 1)
        )
    )) AS third_item
FROM fruits;
--Write a SQL query to create a table where each character from the string will be converted into a row.(sdgfhsdgfhs@121313131)
SELECT 
    SUBSTRING(t.txt, n.number, 1) AS CharValue
FROM (SELECT 'sdgfhsdgfhs@121313131' AS txt) t
JOIN master.dbo.spt_values n 
     ON n.type = 'P' 
    AND n.number BETWEEN 1 AND LEN(t.txt);
--You are given two tables: p1 and p2. Join these tables on the id column. The catch is: when the value of p1.code is 0, replace it with the value of p2.code.(p1,p2)
SELECT 
    p1.id,
    CASE 
        WHEN p1.code = 0 THEN p2.code 
        ELSE p1.code 
    END AS final_code
FROM p1
JOIN p2 
    ON p1.id = p2.id;
/*Write an SQL query to determine the Employment Stage for each employee based on their HIRE_DATE. The stages are defined as follows:
If the employee has worked for less than 1 year ? 'New Hire'
If the employee has worked for 1 to 5 years ? 'Junior'
If the employee has worked for 5 to 10 years ? 'Mid-Level'
If the employee has worked for 10 to 20 years ? 'Senior'
If the employee has worked for more than 20 years ? 'Veteran'(Employees)*/
-- Compute exact years-of-service (anniversary-aware) and classify
SELECT
  EMPLOYEE_ID,
  FIRST_NAME,
  LAST_NAME,
  HIRE_DATE,
  -- accurate full years completed as of today
  DATEDIFF(YEAR, HIRE_DATE, GETDATE())
    - CASE
        WHEN DATEADD(YEAR, DATEDIFF(YEAR, HIRE_DATE, GETDATE()), HIRE_DATE) > GETDATE()
             THEN 1 ELSE 0
      END AS YearsOfService,
  CASE
    WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE())
         - CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, HIRE_DATE, GETDATE()), HIRE_DATE) > GETDATE() THEN 1 ELSE 0 END < 1
      THEN 'New Hire'
    WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE())
         - CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, HIRE_DATE, GETDATE()), HIRE_DATE) > GETDATE() THEN 1 ELSE 0 END < 5
      THEN 'Junior'
    WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE())
         - CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, HIRE_DATE, GETDATE()), HIRE_DATE) > GETDATE() THEN 1 ELSE 0 END < 10
      THEN 'Mid-Level'
    WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE())
         - CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, HIRE_DATE, GETDATE()), HIRE_DATE) > GETDATE() THEN 1 ELSE 0 END < 20
      THEN 'Senior'
    ELSE 'Veteran'
  END AS EmploymentStage
FROM Employees
ORDER BY EMPLOYEE_ID;
--Write a SQL query to extract the integer value that appears at the start of the string in a column named Vals.(GetIntegers)
SELECT 
    Id,
    VALS,
    LEFT(VALS, PATINDEX('%[^0-9]%', VALS + 'A') - 1) AS LeadingInteger
FROM GetIntegers
WHERE VALS IS NOT NULL;
--Difficult Tasks
--In this puzzle you have to swap the first two letters of the comma separated string.(MultipleVals)
SELECT 
    Id,
    Vals,
    -- Build new string: 2nd element + ',' + 1st element + rest
    SUBSTRING(Vals, CHARINDEX(',', Vals) + 1,
              CHARINDEX(',', Vals, CHARINDEX(',', Vals) + 1) - CHARINDEX(',', Vals) - 1)
    + ',' +
    LEFT(Vals, CHARINDEX(',', Vals) - 1)
    + SUBSTRING(Vals, CHARINDEX(',', Vals, CHARINDEX(',', Vals) + 1), LEN(Vals)) 
        AS SwappedVals
FROM MultipleVals;
--Write a SQL query that reports the device that is first logged in for each player.(Activity)
SELECT player_id, device_id
FROM Activity a
WHERE event_date = (
    SELECT MIN(event_date)
    FROM Activity
    WHERE player_id = a.player_id
);
--You are given a sales table. Calculate the week-on-week percentage of sales per area for each financial week. For each week, the total sales will be considered 100%, and the percentage sales for each day of the week should be calculated based on the area sales for that week.(WeekPercentagePuzzle)
;WITH base AS (
  SELECT
      Area,
      [Date],
      [DayName],
      [DayOfWeek],
      FinancialWeek,
      FinancialYear,
      ISNULL(SalesLocal,0) + ISNULL(SalesRemote,0) AS DaySales
  FROM WeekPercentagePuzzle
),
wk AS (
  SELECT
      b.*,
      SUM(b.DaySales) OVER (
        PARTITION BY b.FinancialYear, b.FinancialWeek, b.Area
      ) AS WeekAreaTotal
  FROM base b
)
SELECT
    Area,
    FinancialYear,
    FinancialWeek,
    [Date],
    [DayName],
    DaySales,
    WeekAreaTotal,
    CASE
      WHEN WeekAreaTotal = 0 THEN 0
      ELSE ROUND(100.0 * DaySales / WeekAreaTotal, 2)
    END AS DayPctOfWeek  -- percentage for that day within the area's week (total = 100%)
FROM wk
ORDER BY Area, FinancialYear, FinancialWeek, [Date];
