--1
SELECT DISTINCT s.CustomerName
FROM #Sales s
WHERE EXISTS (
    SELECT 1
    FROM #Sales m
    WHERE m.CustomerName = s.CustomerName
      AND m.SaleDate >= '2024-03-01'
      AND m.SaleDate <  '2024-04-01'
);
--2
SELECT Product, SUM(Quantity*Price) AS TotalRevenue
FROM #Sales
GROUP BY Product
HAVING SUM(Quantity*Price) >= ALL (
    SELECT SUM(Quantity*Price)
    FROM #Sales
    GROUP BY Product
);
--3
WITH amt AS (
    SELECT CAST(Quantity*Price AS DECIMAL(18,2)) AS SaleAmount
    FROM #Sales
)
SELECT MAX(SaleAmount) AS SecondHighestSaleAmount
FROM amt
WHERE SaleAmount < (SELECT MAX(SaleAmount) FROM amt);
--4
SELECT
    YEAR(SaleDate) AS [Year],
    MONTH(SaleDate) AS [Month],
    (SELECT SUM(s2.Quantity)
     FROM #Sales s2
     WHERE YEAR(s2.SaleDate) = YEAR(s1.SaleDate)
       AND MONTH(s2.SaleDate) = MONTH(s1.SaleDate)) AS TotalQty
FROM #Sales s1
GROUP BY YEAR(SaleDate), MONTH(SaleDate)
ORDER BY [Year], [Month];
--5
SELECT DISTINCT s1.CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s2.Product = s1.Product
      AND s2.CustomerName <> s1.CustomerName
);
--6
SELECT
    Name,
    SUM(CASE WHEN Fruit = 'Apple'  THEN 1 ELSE 0 END) AS Apple,
    SUM(CASE WHEN Fruit = 'Orange' THEN 1 ELSE 0 END) AS Orange,
    SUM(CASE WHEN Fruit = 'Banana' THEN 1 ELSE 0 END) AS Banana
FROM Fruits
GROUP BY Name
ORDER BY Name;
--7
;WITH rel AS (
    SELECT ParentId AS PID, ChildID AS CHID
    FROM Family
    UNION ALL
    SELECT r.PID, f.ChildID
    FROM rel r
    JOIN Family f ON f.ParentId = r.CHID
)
SELECT DISTINCT PID, CHID
FROM rel
ORDER BY PID, CHID
OPTION (MAXRECURSION 0);
--8
SELECT o.*
FROM #Orders o
WHERE o.DeliveryState = 'TX'
  AND EXISTS (
      SELECT 1
      FROM #Orders x
      WHERE x.CustomerID = o.CustomerID
        AND x.DeliveryState = 'CA'
  )
ORDER BY o.CustomerID, o.OrderID;
--9
-- If fullname is NULL, extract name=... from address and fill it
UPDATE r
SET r.fullname = SUBSTRING(
                    r.address,
                    CHARINDEX('name=', r.address) + 5,
                    CASE
                        WHEN CHARINDEX(' ', r.address + ' ', CHARINDEX('name=', r.address) + 5) = 0
                        THEN LEN(r.address) - (CHARINDEX('name=', r.address) + 4)
                        ELSE CHARINDEX(' ', r.address + ' ', CHARINDEX('name=', r.address) + 5)
                             - (CHARINDEX('name=', r.address) + 5)
                    END
                 )
FROM #residents r
WHERE r.fullname IS NULL
  AND CHARINDEX('name=', r.address) > 0;

-- Check:
SELECT * FROM #residents ORDER BY resid;
--10
;WITH Paths AS (
    SELECT
        CAST(DepartureCity + ' - ' + ArrivalCity AS VARCHAR(400)) AS Route,
        DepartureCity,
        ArrivalCity,
        CAST(Cost AS MONEY) AS TotalCost
    FROM #Routes
    WHERE DepartureCity = 'Tashkent'

    UNION ALL

    SELECT
        CAST(p.Route + ' - ' + r.ArrivalCity AS VARCHAR(400)) AS Route,
        p.DepartureCity,
        r.ArrivalCity,
        p.TotalCost + r.Cost
    FROM Paths p
    JOIN #Routes r
      ON r.DepartureCity = p.ArrivalCity
    -- avoid small cycles by limiting route length
    WHERE LEN(p.Route) < 380
)
SELECT TOP (1) WITH TIES Route, TotalCost AS Cost
FROM Paths
WHERE ArrivalCity = 'Khorezm'
ORDER BY CASE WHEN TotalCost = (SELECT MIN(TotalCost) FROM Paths WHERE ArrivalCity='Khorezm') THEN 0 ELSE 1 END,
         TotalCost;

-- If you want explicitly cheapest and most expensive rows:
;WITH Final AS (
    SELECT Route, TotalCost,
           RANK()  OVER (ORDER BY TotalCost ASC)  AS rk_min,
           RANK()  OVER (ORDER BY TotalCost DESC) AS rk_max
    FROM (
        SELECT DISTINCT Route, TotalCost
        FROM Paths
        WHERE ArrivalCity = 'Khorezm'
    ) z
)
SELECT Route, TotalCost AS Cost
FROM Final
WHERE rk_min = 1
UNION ALL
SELECT Route, TotalCost
FROM Final
WHERE rk_max = 1
ORDER BY Cost;
--11
-- Assign a group that increments each time 'Product' appears
SELECT
    ID,
    Vals,
    SUM(CASE WHEN Vals = 'Product' THEN 1 ELSE 0 END)
        OVER (ORDER BY ID ROWS UNBOUNDED PRECEDING) AS InsGroup
FROM #RankingPuzzle
ORDER BY ID;
--12
SELECT e.*
FROM #EmployeeSales e
WHERE e.SalesAmount >
      (
        SELECT AVG(e2.SalesAmount)
        FROM #EmployeeSales e2
        WHERE e2.Department = e.Department
          AND e2.SalesYear   = e.SalesYear
          AND e2.SalesMonth  = e.SalesMonth
      )
ORDER BY e.SalesYear, e.SalesMonth, e.Department, e.EmployeeName;
--13
SELECT DISTINCT e.EmployeeName
FROM #EmployeeSales e
WHERE NOT EXISTS (
    SELECT 1
    FROM #EmployeeSales x
    WHERE x.SalesYear  = e.SalesYear
      AND x.SalesMonth = e.SalesMonth
      AND x.SalesAmount > e.SalesAmount
);
--14
;WITH Months AS (
    SELECT DISTINCT SalesYear, SalesMonth FROM #EmployeeSales
)
SELECT DISTINCT e.EmployeeName
FROM #EmployeeSales e
WHERE NOT EXISTS (
    SELECT 1
    FROM Months m
    WHERE NOT EXISTS (
        SELECT 1
        FROM #EmployeeSales x
        WHERE x.EmployeeName = e.EmployeeName
          AND x.SalesYear  = m.SalesYear
          AND x.SalesMonth = m.SalesMonth
    )
)
ORDER BY e.EmployeeName;
--15
SELECT Name
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products)
ORDER BY Name;
--16
SELECT ProductID, Name, Stock
FROM Products
WHERE Stock < (SELECT MAX(Stock) FROM Products)
ORDER BY Stock DESC, Name;
--17
SELECT p2.Name
FROM Products p2
WHERE p2.Category = (
    SELECT Category FROM Products WHERE Name = 'Laptop'
);
--18
SELECT ProductID, Name, Price
FROM Products
WHERE Price > (
    SELECT MIN(Price) FROM Products WHERE Category = 'Electronics'
)
ORDER BY Price DESC;
--19
SELECT p.ProductID, p.Name, p.Category, p.Price
FROM Products p
WHERE p.Price > (
    SELECT AVG(p2.Price)
    FROM Products p2
    WHERE p2.Category = p.Category
)
ORDER BY p.Category, p.Price DESC;
--20
SELECT DISTINCT p.ProductID, p.Name
FROM Products p
WHERE EXISTS (
    SELECT 1 FROM Orders o WHERE o.ProductID = p.ProductID
)
ORDER BY p.ProductID;
--21
SELECT DISTINCT p.ProductID, p.Name
FROM Products p
WHERE EXISTS (
    SELECT 1 FROM Orders o WHERE o.ProductID = p.ProductID
)
ORDER BY p.ProductID;
--22
SELECT p.ProductID, p.Name
FROM Products p
WHERE NOT EXISTS (
    SELECT 1 FROM Orders o WHERE o.ProductID = p.ProductID
)
ORDER BY p.ProductID;
--23
SELECT TOP (1) WITH TIES
    p.ProductID, p.Name,
    SUM(o.Quantity) AS TotalOrderedQty
FROM Products p
JOIN Orders o ON o.ProductID = p.ProductID
GROUP BY p.ProductID, p.Name
ORDER BY SUM(o.Quantity) DESC;

