--1
-- Current month window
DECLARE @monthStart DATE = DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1);
DECLARE @monthEnd   DATE = EOMONTH(@monthStart);

IF OBJECT_ID('tempdb..#MonthlySales') IS NOT NULL DROP TABLE #MonthlySales;
CREATE TABLE #MonthlySales (
    ProductID     INT PRIMARY KEY,
    TotalQuantity INT,
    TotalRevenue  DECIMAL(18,2)
);

INSERT INTO #MonthlySales(ProductID, TotalQuantity, TotalRevenue)
SELECT
    s.ProductID,
    SUM(s.Quantity) AS TotalQuantity,
    SUM(s.Quantity * p.Price) AS TotalRevenue
FROM Sales s
JOIN Products p ON p.ProductID = s.ProductID
WHERE s.SaleDate >= @monthStart AND s.SaleDate <= @monthEnd
GROUP BY s.ProductID;

-- Return
SELECT * FROM #MonthlySales ORDER BY ProductID;

--2
IF OBJECT_ID('dbo.vw_ProductSalesSummary', 'V') IS NOT NULL DROP VIEW dbo.vw_ProductSalesSummary;
GO
CREATE VIEW dbo.vw_ProductSalesSummary
AS
SELECT
    p.ProductID,
    p.ProductName,
    p.Category,
    COALESCE(SUM(s.Quantity), 0) AS TotalQuantitySold
FROM Products p
LEFT JOIN Sales s ON s.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName, p.Category;
GO

--3
IF OBJECT_ID('dbo.fn_GetTotalRevenueForProduct', 'FN') IS NOT NULL DROP FUNCTION dbo.fn_GetTotalRevenueForProduct;
GO
CREATE FUNCTION dbo.fn_GetTotalRevenueForProduct (@ProductID INT)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @rev DECIMAL(18,2);
    SELECT @rev = COALESCE(SUM(s.Quantity * p.Price), 0.00)
    FROM Sales s
    JOIN Products p ON p.ProductID = s.ProductID
    WHERE s.ProductID = @ProductID;
    RETURN @rev;
END
GO

--4
IF OBJECT_ID('dbo.fn_GetSalesByCategory', 'IF') IS NOT NULL DROP FUNCTION dbo.fn_GetSalesByCategory;
GO
CREATE FUNCTION dbo.fn_GetSalesByCategory (@Category VARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT
        p.ProductName,
        COALESCE(SUM(s.Quantity), 0)                    AS TotalQuantity,
        COALESCE(SUM(s.Quantity * p.Price), 0.00)       AS TotalRevenue
    FROM Products p
    LEFT JOIN Sales s ON s.ProductID = p.ProductID
    WHERE p.Category = @Category
    GROUP BY p.ProductName
);
GO

--5
IF OBJECT_ID('dbo.fn_IsPrime', 'FN') IS NOT NULL DROP FUNCTION dbo.fn_IsPrime;
GO
CREATE FUNCTION dbo.fn_IsPrime (@Number INT)
RETURNS VARCHAR(3)
AS
BEGIN
    IF @Number IS NULL OR @Number <= 1 RETURN 'No';
    IF @Number IN (2,3) RETURN 'Yes';
    IF @Number % 2 = 0 OR @Number % 3 = 0 RETURN 'No';

    DECLARE @i INT = 5, @lim INT = FLOOR(SQRT(@Number));
    WHILE @i <= @lim
    BEGIN
        IF @Number % @i = 0 OR @Number % (@i + 2) = 0 RETURN 'No';
        SET @i += 6;
    END
    RETURN 'Yes';
END
GO
-- Example:
-- SELECT dbo.fn_IsPrime(29); -- Yes
-- SELECT dbo.fn_IsPrime(91); -- No

--6
IF OBJECT_ID('dbo.fn_GetNumbersBetween', 'IF') IS NOT NULL DROP FUNCTION dbo.fn_GetNumbersBetween;
GO
CREATE FUNCTION dbo.fn_GetNumbersBetween (@Start INT, @End INT)
RETURNS TABLE
AS
RETURN
(
    WITH nums AS (
        SELECT CASE WHEN @Start <= @End THEN @Start ELSE @End END AS n,
               CASE WHEN @Start <= @End THEN @End   ELSE @Start END AS m
        UNION ALL
        SELECT n + 1, m FROM nums WHERE n + 1 <= m
    )
    SELECT n AS [Number] FROM nums
);
GO
-- Example: SELECT * FROM dbo.fn_GetNumbersBetween(3,7);

--7
DECLARE @N INT = 2;  -- change as needed

WITH s AS (
    SELECT DISTINCT salary FROM Employee
),
r AS (
    SELECT salary, DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM s
)
SELECT (SELECT salary FROM r WHERE rnk = @N) AS HighestNSalary;

--8
-- Input: RequestAccepted(requester_id, accepter_id, accept_date)

WITH AllEdges AS (
    SELECT requester_id AS id, accepter_id AS friend FROM RequestAccepted
    UNION ALL
    SELECT accepter_id  AS id, requester_id AS friend FROM RequestAccepted
),
Counts AS (
    SELECT id, COUNT(DISTINCT friend) AS num
    FROM AllEdges
    GROUP BY id
)
SELECT TOP (1) id, num
FROM Counts
ORDER BY num DESC;

--9
IF OBJECT_ID('dbo.vw_CustomerOrderSummary', 'V') IS NOT NULL DROP VIEW dbo.vw_CustomerOrderSummary;
GO
CREATE VIEW dbo.vw_CustomerOrderSummary
AS
SELECT
    c.customer_id,
    c.name,
    COUNT(o.order_id)                           AS total_orders,
    COALESCE(SUM(o.amount), 0.00)               AS total_amount,
    MAX(o.order_date)                           AS last_order_date
FROM Customers c
LEFT JOIN Orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name;
GO

-- Example:
-- SELECT * FROM dbo.vw_CustomerOrderSummary ORDER BY customer_id;

--10
-- Table: Gaps(RowNumber, TestCase)

WITH LNN AS (
    SELECT
        g.RowNumber,
        g.TestCase,
        MAX(CASE WHEN g.TestCase IS NOT NULL THEN g.RowNumber END)
            OVER (ORDER BY g.RowNumber ROWS UNBOUNDED PRECEDING) AS last_nonnull_rn
    FROM Gaps g
)
SELECT
    RowNumber,
    COALESCE(g2.TestCase, LNN.TestCase) AS Workflow
FROM LNN
LEFT JOIN Gaps g2
  ON g2.RowNumber = LNN.last_nonnull_rn
ORDER BY RowNumber;

