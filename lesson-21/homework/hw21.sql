1) Row number by SaleDate
SELECT *, ROW_NUMBER() OVER (ORDER BY SaleDate) AS rn
FROM ProductSales
ORDER BY SaleDate;

2) Rank products by total quantity sold (no gaps → DENSE_RANK)
WITH q AS (
  SELECT ProductName, SUM(Quantity) AS TotalQty
  FROM ProductSales
  GROUP BY ProductName
)
SELECT ProductName, TotalQty,
       DENSE_RANK() OVER (ORDER BY TotalQty DESC) AS drnk
FROM q
ORDER BY drnk, ProductName;

3) Top sale per customer (by SaleAmount)
WITH x AS (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY SaleAmount DESC, SaleDate DESC) AS rn
  FROM ProductSales
)
SELECT *
FROM x
WHERE rn = 1
ORDER BY CustomerID;

4) Each sale with the next sale amount (by date)
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       LEAD(SaleAmount) OVER (ORDER BY SaleDate) AS NextSaleAmount
FROM ProductSales
ORDER BY SaleDate;

5) Each sale with the previous sale amount (by date)
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       LAG(SaleAmount) OVER (ORDER BY SaleDate) AS PrevSaleAmount
FROM ProductSales
ORDER BY SaleDate;

6) Sales amounts greater than the previous sale’s amount (by date)
WITH x AS (
  SELECT *, LAG(SaleAmount) OVER (ORDER BY SaleDate) AS PrevSale
  FROM ProductSales
)
SELECT *
FROM x
WHERE PrevSale IS NOT NULL AND SaleAmount > PrevSale
ORDER BY SaleDate;

7) Difference from previous sale within the same product
SELECT ProductName, SaleDate, SaleAmount,
       SaleAmount - LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS DiffFromPrev
FROM ProductSales
ORDER BY ProductName, SaleDate;

8) % change vs next sale (by date)
SELECT SaleID, SaleDate, SaleAmount,
       LEAD(SaleAmount) OVER (ORDER BY SaleDate) AS NextSale,
       100.0 * (LEAD(SaleAmount) OVER (ORDER BY SaleDate) - SaleAmount) / NULLIF(SaleAmount,0) AS PctChangeToNext
FROM ProductSales
ORDER BY SaleDate;

9) Ratio of current to previous sale within product
SELECT ProductName, SaleDate, SaleAmount,
       CAST(SaleAmount AS DECIMAL(18,4))
       / NULLIF(LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate), 0) AS RatioToPrev
FROM ProductSales
ORDER BY ProductName, SaleDate;

10) Difference from the first sale of that product
SELECT ProductName, SaleDate, SaleAmount,
       SaleAmount - FIRST_VALUE(SaleAmount)
                     OVER (PARTITION BY ProductName ORDER BY SaleDate
                           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS DiffFromFirst
FROM ProductSales
ORDER BY ProductName, SaleDate;

11) Products whose sales are strictly increasing across time
-- List products where no step is <= previous
WITH chk AS (
  SELECT ProductName,
         CASE WHEN LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) IS NULL
                   THEN 1
              WHEN SaleAmount > LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate)
                   THEN 1 ELSE 0 END AS is_increase
  FROM ProductSales
)
SELECT ProductName
FROM chk
GROUP BY ProductName
HAVING MIN(is_increase) = 1;  -- all steps are increases (first row counted as 1)


(If you instead want the rows that are part of increasing runs, say the word and I’ll give a streak query.)

12) Running total (“closing balance”) by date
SELECT SaleDate, SaleAmount,
       SUM(SaleAmount) OVER (ORDER BY SaleDate ROWS UNBOUNDED PRECEDING) AS RunningTotal
FROM ProductSales
ORDER BY SaleDate;

13) Moving average of last 3 sales (by date)
SELECT SaleDate, SaleAmount,
       AVG(SaleAmount) OVER (ORDER BY SaleDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovAvg3
FROM ProductSales
ORDER BY SaleDate;

14) Difference between each sale and the overall average
SELECT SaleID, SaleAmount,
       SaleAmount - AVG(SaleAmount) OVER () AS DiffFromGlobalAvg
FROM ProductSales
ORDER BY SaleID;

Employees1 tasks
15) Employees who share the same salary rank
SELECT EmployeeID, Name, Department, Salary,
       DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
FROM Employees1
ORDER BY Salary DESC, Name;

16) Top 2 highest salaries in each department
WITH r AS (
  SELECT *, DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS rnk
  FROM Employees1
)
SELECT EmployeeID, Name, Department, Salary
FROM r
WHERE rnk <= 2
ORDER BY Department, Salary DESC, Name;

17) Lowest-paid employee(s) per department (ties included)
WITH r AS (
  SELECT *, DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary ASC) AS rnk
  FROM Employees1
)
SELECT EmployeeID, Name, Department, Salary
FROM r
WHERE rnk = 1
ORDER BY Department, Name;

18) Running total of salaries by department (ordered by HireDate)
SELECT Department, EmployeeID, Name, HireDate, Salary,
       SUM(Salary) OVER (PARTITION BY Department ORDER BY HireDate
                         ROWS UNBOUNDED PRECEDING) AS DeptRunningTotal
FROM Employees1
ORDER BY Department, HireDate;

19) Total salary per department without GROUP BY
SELECT DISTINCT Department,
       SUM(Salary) OVER (PARTITION BY Department) AS TotalDeptSalary
FROM Employees1
ORDER BY Department;

20) Average salary per department without GROUP BY
SELECT DISTINCT Department,
       AVG(Salary) OVER (PARTITION BY Department) AS AvgDeptSalary
FROM Employees1
ORDER BY Department;

21) Difference between an employee’s salary and their dept average
SELECT EmployeeID, Name, Department, Salary,
       Salary - AVG(Salary) OVER (PARTITION BY Department) AS DiffFromDeptAvg
FROM Employees1
ORDER BY Department, Salary DESC;

22) Moving average salary over 3 employees (prev, current, next) per dept
SELECT Department, EmployeeID, Name, HireDate, Salary,
       AVG(Salary) OVER (PARTITION BY Department ORDER BY HireDate
                         ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS MovAvg3
FROM Employees1
ORDER BY Department, HireDate;

23) Sum of salaries for the last 3 hired employees (overall)
SELECT SUM(Salary) AS SumLast3Hires
FROM (
  SELECT TOP (3) Salary
  FROM Employees1
  ORDER BY HireDate DESC
) t;


If you want any of these tweaked (e.g., percent changes per product, “increasing runs” output, or last-3 per department), I can adapt quickly.