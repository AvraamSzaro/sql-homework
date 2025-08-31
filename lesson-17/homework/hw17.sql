--1
;WITH Regions AS (
    SELECT DISTINCT Region FROM #RegionSales
),
Distributors AS (
    SELECT DISTINCT Distributor FROM #RegionSales
),
Base AS (
    SELECT Region, Distributor, SUM(Sales) AS Sales
    FROM #RegionSales
    GROUP BY Region, Distributor
)
SELECT
    r.Region,
    d.Distributor,
    COALESCE(b.Sales, 0) AS Sales
FROM Regions r
CROSS JOIN Distributors d
LEFT JOIN Base b
    ON b.Region = r.Region
   AND b.Distributor = d.Distributor
ORDER BY d.Distributor, r.Region;

--2
SELECT 
    m.id   AS ManagerId,
    m.name AS ManagerName,
    COUNT(e.id) AS DirectReports
FROM Employee e
JOIN Employee m
    ON e.managerId = m.id
GROUP BY m.id, m.name
HAVING COUNT(e.id) >= 5;

--3
SELECT 
    p.product_name,
    SUM(o.unit) AS unit
FROM Orders o
JOIN Products p 
  ON p.product_id = o.product_id
WHERE o.order_date >= '2020-02-01'
  AND o.order_date <  '2020-03-01'   -- Feb 2020 window
GROUP BY p.product_id, p.product_name
HAVING SUM(o.unit) >= 100
ORDER BY unit DESC;
--4
WITH VendorCounts AS (
    SELECT
        CustomerID,
        Vendor,
        COUNT(*) AS OrderCount
    FROM Orders
    GROUP BY CustomerID, Vendor
),
Ranked AS (
    SELECT
        CustomerID,
        Vendor,
        OrderCount,
        ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderCount DESC) AS rn
    FROM VendorCounts
)
SELECT CustomerID, Vendor, OrderCount
FROM Ranked
WHERE rn = 1;


--5
DECLARE @Check_Prime INT = 91;
DECLARE @i INT = 2;
DECLARE @IsPrime BIT = 1;   -- assume prime unless proven otherwise

IF @Check_Prime <= 1
BEGIN
    SET @IsPrime = 0;
END
ELSE
BEGIN
    WHILE @i <= SQRT(@Check_Prime)
    BEGIN
        IF @Check_Prime % @i = 0
        BEGIN
            SET @IsPrime = 0;
            BREAK;
        END
        SET @i = @i + 1;
    END
END;

IF @IsPrime = 1
    PRINT 'This number is prime';
ELSE
    PRINT 'This number is not prime';

--6

WITH DeviceCounts AS (
    SELECT 
        Device_id,
        Locations,
        COUNT(*) AS SignalCount
    FROM Device
    GROUP BY Device_id, Locations
),
Ranked AS (
    SELECT 
        Device_id,
        Locations,
        SignalCount,
        RANK() OVER (PARTITION BY Device_id ORDER BY SignalCount DESC) AS rnk
    FROM DeviceCounts
),
Summary AS (
    SELECT 
        Device_id,
        COUNT(DISTINCT Locations) AS NumLocations,
        SUM(SignalCount) AS TotalSignals
    FROM DeviceCounts
    GROUP BY Device_id
)
SELECT 
    s.Device_id,
    s.NumLocations,
    r.Locations AS MostSignalsLocation,
    r.SignalCount AS MaxSignals,
    s.TotalSignals
FROM Summary s
JOIN Ranked r
  ON s.Device_id = r.Device_id
 AND r.rnk = 1
ORDER BY s.Device_id;



--7

SELECT e.EmpID, e.EmpName, e.Salary
FROM Employee e
WHERE e.Salary > (
    SELECT AVG(Salary)
    FROM Employee
    WHERE DeptID = e.DeptID
);

--8
-- Winning numbers
CREATE TABLE WinningNumbers (Number INT);
TRUNCATE TABLE WinningNumbers;
INSERT INTO WinningNumbers VALUES (25),(45),(78);

-- Tickets: each row = one picked number for a ticket
CREATE TABLE Tickets (TicketID INT, Number INT);
TRUNCATE TABLE Tickets;
INSERT INTO Tickets VALUES
(1, 25),(1,45),(1,78),       -- all 3, should win $100
(2, 25),(2,45),(2,99),       -- 2 matches, $10
(3, 25),(3,11),(3,12),       -- 1 match, $10
(4, 10),(4,11),(4,12);       -- no match, $0
--9
-- Per user per date: gather platform flags and amounts
WITH per_user_date AS (
    SELECT
        Spend_date,
        User_id,
        SUM(CASE WHEN Platform = 'Mobile'  THEN Amount ELSE 0 END) AS amt_mobile,
        SUM(CASE WHEN Platform = 'Desktop' THEN Amount ELSE 0 END) AS amt_desktop,
        MAX(CASE WHEN Platform = 'Mobile'  THEN 1 ELSE 0 END) AS has_mobile,
        MAX(CASE WHEN Platform = 'Desktop' THEN 1 ELSE 0 END) AS has_desktop
    FROM Spending
    GROUP BY Spend_date, User_id
),
classified AS (
    SELECT
        Spend_date,
        CASE
            WHEN has_mobile = 1 AND has_desktop = 1 THEN 'Both'
            WHEN has_mobile = 1 AND has_desktop = 0 THEN 'MobileOnly'
            WHEN has_mobile = 0 AND has_desktop = 1 THEN 'DesktopOnly'
        END AS category,
        CASE
            WHEN has_mobile = 1 AND has_desktop = 1 THEN amt_mobile + amt_desktop
            WHEN has_mobile = 1 AND has_desktop = 0 THEN amt_mobile
            WHEN has_mobile = 0 AND has_desktop = 1 THEN amt_desktop
        END AS amount
    FROM per_user_date
)
SELECT
    Spend_date,
    SUM(CASE WHEN category = 'MobileOnly'  THEN 1 ELSE 0 END) AS users_mobile_only,
    SUM(CASE WHEN category = 'MobileOnly'  THEN amount ELSE 0 END) AS amount_mobile_only,
    SUM(CASE WHEN category = 'DesktopOnly' THEN 1 ELSE 0 END) AS users_desktop_only,
    SUM(CASE WHEN category = 'DesktopOnly' THEN amount ELSE 0 END) AS amount_desktop_only,
    SUM(CASE WHEN category = 'Both'       THEN 1 ELSE 0 END) AS users_both,
    SUM(CASE WHEN category = 'Both'       THEN amount ELSE 0 END) AS amount_both
FROM classified
GROUP BY Spend_date
ORDER BY Spend_date;
--10
WITH Expand AS (
    -- Anchor: start each product at 1
    SELECT Product, 1 AS qty
    FROM Grouped
    WHERE Quantity > 0

    UNION ALL

    -- Recursive step: keep adding rows until Quantity is reached
    SELECT g.Product, e.qty + 1
    FROM Expand e
    JOIN Grouped g
      ON g.Product = e.Product
    WHERE e.qty < g.Quantity
)
SELECT Product, 1 AS Quantity
FROM Expand
ORDER BY Product, qty
OPTION (MAXRECURSION 0);   -- SQL Server only (to allow deeper recursion)


