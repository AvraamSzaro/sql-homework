--1
IF OBJECT_ID('dbo.usp_MakeEmployeeBonus', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_MakeEmployeeBonus;
GO
CREATE PROCEDURE dbo.usp_MakeEmployeeBonus
AS
BEGIN
    SET NOCOUNT ON;

    IF OBJECT_ID('tempdb..#EmployeeBonus') IS NOT NULL DROP TABLE #EmployeeBonus;
    CREATE TABLE #EmployeeBonus
    (
        EmployeeID   INT PRIMARY KEY,
        FullName     NVARCHAR(120),
        Department   NVARCHAR(50),
        Salary       DECIMAL(10,2),
        BonusAmount  DECIMAL(18,2)
    );

    INSERT INTO #EmployeeBonus (EmployeeID, FullName, Department, Salary, BonusAmount)
    SELECT
        e.EmployeeID,
        CONCAT(e.FirstName, ' ', e.LastName) AS FullName,
        e.Department,
        e.Salary,
        CAST(e.Salary * (db.BonusPercentage / 100.0) AS DECIMAL(18,2)) AS BonusAmount
    FROM Employees e
    INNER JOIN DepartmentBonus db
        ON db.Department = e.Department;

    SELECT * FROM #EmployeeBonus ORDER BY EmployeeID;
END
GO

-- Example:
-- EXEC dbo.usp_MakeEmployeeBonus;

--2
IF OBJECT_ID('dbo.usp_UpdateDepartmentSalary', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_UpdateDepartmentSalary;
GO
CREATE PROCEDURE dbo.usp_UpdateDepartmentSalary
    @Department NVARCHAR(50),
    @IncreasePercent DECIMAL(5,2)   -- e.g., 5 = +5%
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE e
    SET e.Salary = CAST(e.Salary * (1 + (@IncreasePercent / 100.0)) AS DECIMAL(10,2))
    FROM Employees e
    WHERE e.Department = @Department;

    SELECT *
    FROM Employees
    WHERE Department = @Department
    ORDER BY EmployeeID;
END
GO

-- Example:
-- EXEC dbo.usp_UpdateDepartmentSalary @Department = N'Sales', @IncreasePercent = 5;
--3
-- Final state of Products_Current after MERGE
MERGE dbo.Products_Current AS tgt
USING dbo.Products_New     AS src
ON (tgt.ProductID = src.ProductID)
WHEN MATCHED THEN
    UPDATE SET
        tgt.ProductName = src.ProductName,
        tgt.Price       = src.Price
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProductID, ProductName, Price)
    VALUES (src.ProductID, src.ProductName, src.Price)
WHEN NOT MATCHED BY SOURCE THEN
    DELETE
OUTPUT $action AS MergeAction, inserted.*, deleted.*;

-- Show final result:
SELECT * FROM dbo.Products_Current ORDER BY ProductID;
--4
-- Table Tree(id, p_id) is assumed loaded as per prompt.
-- Classify each id:
SELECT
    t.id,
    CASE
        WHEN t.p_id IS NULL THEN 'Root'
        WHEN t.id NOT IN (SELECT DISTINCT p_id FROM Tree WHERE p_id IS NOT NULL) THEN 'Leaf'
        ELSE 'Inner'
    END AS [type]
FROM Tree t
ORDER BY t.id;
--5
-- SQL Server version (no ENUM; assume Confirmations.action contains 'confirmed' or 'timeout' strings)

SELECT
    s.user_id,
    CAST(
        CASE 
            WHEN COUNT(c.time_stamp) = 0 THEN 0.00
            ELSE 1.0 * SUM(CASE WHEN c.action = 'confirmed' THEN 1 ELSE 0 END) / COUNT(c.time_stamp)
        END
        AS DECIMAL(4,2)
    ) AS confirmation_rate
FROM Signups s
LEFT JOIN Confirmations c
    ON c.user_id = s.user_id
GROUP BY s.user_id
ORDER BY s.user_id;
--6
SELECT e.*
FROM employees e
WHERE e.salary = (
    SELECT MIN(salary) FROM employees
);
--7
IF OBJECT_ID('dbo.GetProductSalesSummary', 'P') IS NOT NULL DROP PROCEDURE dbo.GetProductSalesSummary;
GO
CREATE PROCEDURE dbo.GetProductSalesSummary
    @ProductID INT
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH agg AS
    (
        SELECT
            s.ProductID,
            SUM(s.Quantity)                         AS TotalQty,
            SUM(s.Quantity * p.Price)               AS TotalAmount,
            MIN(s.SaleDate)                         AS FirstSaleDate,
            MAX(s.SaleDate)                         AS LastSaleDate
        FROM Sales s
        INNER JOIN Products p ON p.ProductID = s.ProductID
        WHERE s.ProductID = @ProductID
        GROUP BY s.ProductID
    )
    SELECT
        p.ProductName,
        a.TotalQty          AS [Total Quantity Sold],
        a.TotalAmount       AS [Total Sales Amount],
        a.FirstSaleDate     AS [First Sale Date],
        a.LastSaleDate      AS [Last Sale Date]
    FROM Products p
    LEFT JOIN agg a
        ON a.ProductID = p.ProductID
    WHERE p.ProductID = @ProductID;
END
GO

-- Examples:
-- EXEC dbo.GetProductSalesSummary @ProductID = 1;  -- product with sales
-- EXEC dbo.GetProductSalesSummary @ProductID = 999;-- product not existing -> no row
-- (For existing product with no sales, it will still return name with NULL aggregates)