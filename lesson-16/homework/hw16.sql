--1
;with cte as (
	select 1 as n
	union all
	select n+1 from cte
	where n<100
) select * from cte

--2 Write a query to find the total sales per employee using a derived table.(Sales, Employees)
SELECT e.EmployeeID,
       e.FirstName,
       e.LastName,
       dt.TotalSales
FROM (
    SELECT EmployeeID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY EmployeeID
) AS dt
JOIN Employees e
    ON e.EmployeeID = dt.EmployeeID
ORDER BY dt.TotalSales DESC;
--3. Create a CTE to find the average salary of employees.(Employees)
WITH AvgSalaryCTE AS (
    SELECT AVG(Salary) AS AvgSalary
    FROM Employees
)
SELECT AvgSalary
FROM AvgSalaryCTE;
--4. Write a query using a derived table to find the highest sales for each product.(Sales, Products)
select * from sales
select * from Products

select
	p.ProductID,
	p.ProductName,
	maxsale.maxsales,
	p.Price
from	(
	select productid, MAX(salesAmount) as maxsales
	from Sales
	group by ProductID
	) as maxsale
join Products p on maxsale.ProductID=p.ProductID
--5. Beginning at 1, write a statement to double the number for each record, the max value you get should be less than 1000000.
;with cte as (
	select 1 as num
	union all
	select num*2 from cte
	where num<1000000
) select * from cte
--6. Use a CTE to get the names of employees who have made more than 5 sales.(Sales, Employees)
;WITH SalesCountCTE AS (
    SELECT 
        EmployeeID,
        COUNT(*) AS TotalSales
    FROM Sales
    GROUP BY EmployeeID
)
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    sc.TotalSales
FROM SalesCountCTE sc
JOIN Employees e 
    ON e.EmployeeID = sc.EmployeeID
WHERE sc.TotalSales > 5
ORDER BY sc.TotalSales DESC;
--7
;WITH ProductSalesCTE AS (
    SELECT 
        s.ProductID,
        SUM(s.SalesAmount) AS TotalSales
    FROM Sales s
    GROUP BY s.ProductID
)
SELECT 
    p.ProductID,
    p.ProductName,
    ps.TotalSales
FROM ProductSalesCTE ps
JOIN Products p 
    ON p.ProductID = ps.ProductID
WHERE ps.TotalSales > 500
ORDER BY ps.TotalSales DESC;
--8
;WITH AvgSalaryCTE AS (
    SELECT AVG(Salary) AS AvgSalary
    FROM Employees
)
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.Salary
FROM Employees e
CROSS JOIN AvgSalaryCTE a
WHERE e.Salary > a.AvgSalary
ORDER BY e.Salary DESC;

--Medium Tasks
--1. Write a query using a derived table to find the top 5 employees by the number of orders made.(Employees, Sales)
select top 5
	e.firstname,
	e.lastname,
	rr.numoforders
from (
	select EmployeeID, count(*) as numoforders
	from Sales
	group by EmployeeID
	) rr
join Employees e
	on rr.EmployeeID = e.EmployeeID
order by rr.numoforders desc;

--2. Write a query using a derived table to find the sales per product category.(Sales, Products)
SELECT dt.CategoryID,
       dt.TotalSales
FROM (
        SELECT p.CategoryID,
               SUM(s.SalesAmount) AS TotalSales
        FROM Sales s
        JOIN Products p
             ON s.ProductID = p.ProductID
        GROUP BY p.CategoryID
     ) AS dt;

--3. Write a script to return the factorial of each value next to it.(Numbers1)
WITH FactorialCTE AS (
    -- Anchor: start with each number from Numbers1
    SELECT Number AS OriginalNum, Number AS CurrentNum, 1 AS Factorial
    FROM Numbers1

    UNION ALL

    -- Recursive step: multiply downwards until CurrentNum = 1
    SELECT OriginalNum, CurrentNum - 1,
           Factorial * CurrentNum
    FROM FactorialCTE
    WHERE CurrentNum > 1
)
SELECT OriginalNum AS Number,
       MAX(Factorial) AS FactorialResult
FROM FactorialCTE
GROUP BY OriginalNum
ORDER BY OriginalNum;

--4. This script uses recursion to split a string into rows of substrings for each character in the string.(Example)
WITH SplitCTE AS (
    -- Anchor: start with the first character
    SELECT 
        Id,
        1 AS Position,
        SUBSTRING(String, 1, 1) AS Character
    FROM Example

    UNION ALL

    -- Recursive step: move to the next character
    SELECT 
        Id,
        Position + 1,
        SUBSTRING(String, Position + 1, 1)
    FROM SplitCTE
    WHERE Position + 1 <= LEN((SELECT String FROM Example WHERE Example.Id = SplitCTE.Id))
)
SELECT Id, Position, Character
FROM SplitCTE
ORDER BY Id, Position
OPTION (MAXRECURSION 0);  -- allow recursion for longer strings
--5. 
WITH Monthly AS (
    SELECT
        MonthStart = DATEFROMPARTS(YEAR(SaleDate), MONTH(SaleDate), 1),
        MonthlySales = SUM(SalesAmount)
    FROM Sales
    GROUP BY DATEFROMPARTS(YEAR(SaleDate), MONTH(SaleDate), 1)
)
SELECT
    MonthStart,
    MonthlySales,
    PrevMonthSales = LAG(MonthlySales) OVER (ORDER BY MonthStart),
    DiffFromPrev   = MonthlySales - LAG(MonthlySales) OVER (ORDER BY MonthStart)
FROM Monthly
ORDER BY MonthStart;

--6/Create a derived table to find employees with sales over $45000 in each quarter.(Sales, Employees)

SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    dt.QuarterStart,
    dt.QuarterlySales
FROM (
        SELECT 
            EmployeeID,
            DATEPART(YEAR, SaleDate)   AS SaleYear,
            DATEPART(QUARTER, SaleDate) AS SaleQuarter,
            SUM(SalesAmount) AS QuarterlySales,
            DATEFROMPARTS(YEAR(SaleDate),
                          ((DATEPART(QUARTER, SaleDate) - 1) * 3) + 1,
                          1) AS QuarterStart
        FROM Sales
        GROUP BY EmployeeID, DATEPART(YEAR, SaleDate), DATEPART(QUARTER, SaleDate)
     ) AS dt
JOIN Employees e 
     ON dt.EmployeeID = e.EmployeeID
WHERE dt.QuarterlySales > 45000
ORDER BY dt.SaleYear, dt.SaleQuarter, dt.QuarterlySales DESC;

--difficult tasks
--This script uses recursion to calculate Fibonacci numbers
WITH FibonacciCTE AS (
    -- Anchor members
    SELECT 0 AS n, 0 AS Fib
    UNION ALL
    SELECT 1 AS n, 1 AS Fib

    UNION ALL

    -- Recursive step: use previous two values
    SELECT f1.n + 1,
           f1.Fib + f2.Fib
    FROM FibonacciCTE f1
    JOIN FibonacciCTE f2
        ON f1.n = f2.n + 1   -- ensures "previous two" alignment
    WHERE f1.n < 20          -- limit recursion (20 numbers here)
)
SELECT n, Fib
FROM FibonacciCTE
ORDER BY n
OPTION (MAXRECURSION 0);
--2. Find a string where all characters are the same and the length is greater than 1.(FindSameCharacters)
SELECT Id, Vals
FROM FindSameCharacters
WHERE LEN(Vals) > 1
  AND Vals NOT LIKE REPLICATE(LEFT(Vals,1), LEN(Vals)-1) + '[^' + LEFT(Vals,1) + ']';

--3Create a numbers table that shows all numbers 1 through n and their order gradually increasing by the next number in the sequence.(Example:n=5 | 1, 12, 123, 1234, 12345)

DECLARE @n INT = 5;

WITH Numbers AS (
    -- Anchor: start with "1"
    SELECT 1 AS num, CAST('1' AS VARCHAR(50)) AS seq
    UNION ALL
    -- Recursive step: append the next number
    SELECT num + 1,
           seq + CAST(num + 1 AS VARCHAR(10))
    FROM Numbers
    WHERE num < @n
)
SELECT seq
FROM Numbers
ORDER BY num
OPTION (MAXRECURSION 0);

--7.
SELECT TOP (1) WITH TIES
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    dt.TotalSalesLast6M
FROM (
    SELECT
        s.EmployeeID,
        SUM(s.SalesAmount) AS TotalSalesLast6M
    FROM Sales s
    WHERE s.SaleDate >= DATEADD(MONTH, -6, CAST(GETDATE() AS DATE))
    GROUP BY s.EmployeeID
) AS dt
JOIN Employees e
  ON e.EmployeeID = dt.EmployeeID
ORDER BY dt.TotalSalesLast6M DESC;
--the last one
;WITH Digits AS (
    -- Anchor: start with first character
    SELECT 
        PawanName,
        Pawan_slug_name,
        1 AS Pos,
        SUBSTRING(Pawan_slug_name, 1, 1) AS Chr,
        CAST('' AS VARCHAR(100)) AS Cleaned
    FROM RemoveDuplicateIntsFromNames

    UNION ALL

    -- Recursive step: move through each character
    SELECT 
        PawanName,
        Pawan_slug_name,
        Pos + 1,
        SUBSTRING(Pawan_slug_name, Pos + 1, 1),
        Cleaned
    FROM Digits
    WHERE Pos < LEN(Pawan_slug_name)
),
Build AS (
    SELECT 
        PawanName,
        Pawan_slug_name,
        Pos,
        Chr,
        -- Only keep non-digit characters OR digits not already seen
        Cleaned = 
            CASE 
                WHEN Chr NOT LIKE '[0-9]' THEN Chr
                WHEN LEN(Chr) = 1 
                     AND PATINDEX('%' + Chr + '%', Cleaned) = 0 
                     AND NOT EXISTS (
                           SELECT 1 FROM Digits d2
                           WHERE d2.PawanName = Digits.PawanName
                             AND d2.Chr = Chr
                             HAVING COUNT(*) = 1
                       ) 
                     THEN Chr
                ELSE ''
            END
    FROM Digits
)
SELECT 
    PawanName,
    Original = Pawan_slug_name,
    CleanedString = STRING_AGG(Cleaned, '') WITHIN GROUP (ORDER BY Pos)
FROM Build
GROUP BY PawanName, Pawan_slug_name;

