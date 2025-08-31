Easy
1) Running total sales per customer
SELECT
  sale_id, customer_id, customer_name, order_date, total_amount,
  SUM(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date
                          ROWS UNBOUNDED PRECEDING) AS running_total
FROM sales_data
ORDER BY customer_id, order_date;

2) Number of orders per product_category
SELECT product_category, COUNT(*) AS orders_cnt
FROM sales_data
GROUP BY product_category
ORDER BY product_category;

3) Max total_amount per product_category
SELECT product_category, MAX(total_amount) AS max_total_amount
FROM sales_data
GROUP BY product_category
ORDER BY product_category;

4) Min unit_price per product_category
SELECT product_category, MIN(unit_price) AS min_unit_price
FROM sales_data
GROUP BY product_category
ORDER BY product_category;

5) 3-day moving average (prev, curr, next) by order_date
SELECT
  order_date, total_amount,
  AVG(total_amount) OVER (ORDER BY order_date
                          ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS mov_avg_3
FROM sales_data
ORDER BY order_date;

6) Total sales per region
SELECT region, SUM(total_amount) AS total_sales
FROM sales_data
GROUP BY region
ORDER BY region;

7) Rank customers by total purchase (ties share rank)
WITH t AS (
  SELECT customer_id, customer_name, SUM(total_amount) AS total_spent
  FROM sales_data
  GROUP BY customer_id, customer_name
)
SELECT *, DENSE_RANK() OVER (ORDER BY total_spent DESC) AS spend_rank
FROM t
ORDER BY spend_rank, customer_id;

8) Difference vs previous sale per customer
SELECT
  customer_id, customer_name, order_date, total_amount,
  total_amount - LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS diff_prev
FROM sales_data
ORDER BY customer_id, order_date;

9) Top 3 most expensive products in each category (by unit_price)
WITH r AS (
  SELECT product_category, product_name, unit_price,
         DENSE_RANK() OVER (PARTITION BY product_category ORDER BY unit_price DESC) AS rnk
  FROM sales_data
  GROUP BY product_category, product_name, unit_price
)
SELECT product_category, product_name, unit_price
FROM r
WHERE rnk <= 3
ORDER BY product_category, unit_price DESC, product_name;

10) Cumulative sales per region by order_date
SELECT
  region, order_date, total_amount,
  SUM(total_amount) OVER (PARTITION BY region ORDER BY order_date
                          ROWS UNBOUNDED PRECEDING) AS cum_sales_region
FROM sales_data
ORDER BY region, order_date;

Medium
11) Cumulative revenue per product_category
SELECT
  product_category, order_date, total_amount,
  SUM(total_amount) OVER (PARTITION BY product_category ORDER BY order_date
                          ROWS UNBOUNDED PRECEDING) AS cum_rev_category
FROM sales_data
ORDER BY product_category, order_date;

12) Sum of previous values (sample IDs 1..n)
SELECT ID,
       SUM(ID) OVER (ORDER BY ID ROWS UNBOUNDED PRECEDING) AS SumPreValues
FROM (VALUES (1),(2),(3),(4),(5)) v(ID);

13) Sum of previous values to current (table OneColumn)
SELECT
  Value,
  SUM(Value) OVER (ORDER BY (SELECT NULL) ROWS UNBOUNDED PRECEDING) AS [Sum of Previous]
FROM OneColumn;

14) Customers who bought from more than one product_category
SELECT customer_id, customer_name
FROM sales_data
GROUP BY customer_id, customer_name
HAVING COUNT(DISTINCT product_category) > 1
ORDER BY customer_id;

15) Customers with above-average spending in their region
WITH spend AS (
  SELECT customer_id, customer_name, region, SUM(total_amount) AS total_spent
  FROM sales_data
  GROUP BY customer_id, customer_name, region
)
SELECT s.*
FROM spend s
WHERE s.total_spent > AVG(s.total_spent) OVER (PARTITION BY s.region)
ORDER BY s.region, s.total_spent DESC;

16) Rank customers by total spending within region (ties share rank)
WITH spend AS (
  SELECT customer_id, customer_name, region, SUM(total_amount) AS total_spent
  FROM sales_data
  GROUP BY customer_id, customer_name, region
)
SELECT *,
       DENSE_RANK() OVER (PARTITION BY region ORDER BY total_spent DESC) AS region_rank
FROM spend
ORDER BY region, region_rank, customer_id;

17) Running total of total_amount per customer (by order_date)
SELECT
  customer_id, customer_name, order_date, total_amount,
  SUM(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date
                          ROWS UNBOUNDED PRECEDING) AS cumulative_sales
FROM sales_data
ORDER BY customer_id, order_date;

18) Monthly sales growth rate vs previous month
WITH m AS (
  SELECT
    DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1) AS month_start,
    SUM(total_amount) AS month_sales
  FROM sales_data
  GROUP BY YEAR(order_date), MONTH(order_date)
)
SELECT
  month_start,
  month_sales,
  100.0 * (month_sales - LAG(month_sales) OVER (ORDER BY month_start))
        / NULLIF(LAG(month_sales) OVER (ORDER BY month_start), 0) AS growth_rate_pct
FROM m
ORDER BY month_start;

19) Orders where total_amount > previous order’s total_amount (per customer)
SELECT *
FROM (
  SELECT *,
         LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_amt
  FROM sales_data
) x
WHERE prev_amt IS NOT NULL AND total_amount > prev_amt
ORDER BY customer_id, order_date;

Hard
20) Products whose unit_price is above the overall average product price
WITH p AS (
  SELECT product_name, MAX(unit_price) AS unit_price
  FROM sales_data
  GROUP BY product_name
)
SELECT product_name, unit_price
FROM p
WHERE unit_price > (SELECT AVG(unit_price) FROM p)
ORDER BY unit_price DESC, product_name;

21) Group total (Val1+Val2) only on the first row of each group
WITH t AS (
  SELECT *,
         SUM(val1 + val2) OVER (PARTITION BY grp) AS grp_total,
         ROW_NUMBER() OVER (PARTITION BY grp ORDER BY id) AS rn
  FROM MyData
)
SELECT id, grp, val1, val2,
       CASE WHEN rn = 1 THEN grp_total ELSE NULL END AS Tot
FROM t
ORDER BY grp, id;

22) TheSumPuzzle (sum Cost; Quantity sums only if values differ)
SELECT
  id,
  SUM(cost) AS Cost,
  CASE WHEN COUNT(DISTINCT quantity) = 1
       THEN MAX(quantity)
       ELSE SUM(quantity)
  END AS Quantity
FROM TheSumPuzzle
GROUP BY id
ORDER BY id;

23) Seat gaps (report missing continuous ranges)
;WITH S AS (
  SELECT 0 AS SeatNumber
  UNION ALL
  SELECT SeatNumber FROM Seats
  UNION ALL
  SELECT (SELECT MAX(SeatNumber) FROM Seats) + 1
),
G AS (
  SELECT SeatNumber,
         LEAD(SeatNumber) OVER (ORDER BY SeatNumber) AS next_seat
  FROM S
)
SELECT
  SeatNumber + 1 AS [Gap Start],
  next_seat - 1  AS [Gap End]
FROM G
WHERE next_seat - SeatNumber > 1
ORDER BY [Gap Start];

Extra set (Sales / Customers / Products)

Use your Sales, Customers, and Products tables from the prompt.

7) Total revenue generated
SELECT SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales;

8) Average unit price
SELECT AVG(UnitPrice) AS AvgUnitPrice
FROM Sales;

9) Number of sales transactions
SELECT COUNT(*) AS TransactionsCount
FROM Sales;

10) Highest units in a single transaction
SELECT MAX(QuantitySold) AS MaxUnits
FROM Sales;

11) Products sold per category
SELECT Category, SUM(QuantitySold) AS TotalUnits
FROM Sales
GROUP BY Category
ORDER BY Category;

12) Total revenue per region
SELECT Region, SUM(QuantitySold * UnitPrice) AS RegionRevenue
FROM Sales
GROUP BY Region
ORDER BY Region;

13) Product with highest total revenue
SELECT TOP (1) WITH TIES
  Product,
  SUM(QuantitySold * UnitPrice) AS ProductRevenue
FROM Sales
GROUP BY Product
ORDER BY SUM(QuantitySold * UnitPrice) DESC;

14) Running total of revenue ordered by date
SELECT
  SaleDate,
  (QuantitySold * UnitPrice) AS Revenue,
  SUM(QuantitySold * UnitPrice) OVER (ORDER BY SaleDate
                                      ROWS UNBOUNDED PRECEDING) AS RunningRevenue
FROM Sales
ORDER BY SaleDate;

15) Category contribution to total revenue (share %)
WITH r AS (
  SELECT Category, SUM(QuantitySold * UnitPrice) AS CatRevenue
  FROM Sales
  GROUP BY Category
),
tot AS (
  SELECT SUM(CatRevenue) AS GrandTotal FROM r
)
SELECT r.Category, r.CatRevenue,
       CAST(100.0 * r.CatRevenue / t.GrandTotal AS DECIMAL(6,2)) AS PctOfTotal
FROM r CROSS JOIN tot t
ORDER BY r.Category;

17) All sales with customer names
SELECT s.*, c.CustomerName
FROM Sales s
JOIN Customers c ON c.CustomerID = s.CustomerID
ORDER BY s.SaleID;

18) Customers with no purchases
SELECT c.*
FROM Customers c
LEFT JOIN Sales s ON s.CustomerID = c.CustomerID
WHERE s.CustomerID IS NULL
ORDER BY c.CustomerID;

19) Total revenue by customer
SELECT c.CustomerID, c.CustomerName,
       SUM(s.QuantitySold * s.UnitPrice) AS CustomerRevenue
FROM Customers c
LEFT JOIN Sales s ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY CustomerRevenue DESC, c.CustomerID;

20) Customer who contributed the most revenue
SELECT TOP (1) WITH TIES *
FROM (
  SELECT c.CustomerID, c.CustomerName,
         SUM(s.QuantitySold * s.UnitPrice) AS CustomerRevenue
  FROM Customers c
  LEFT JOIN Sales s ON s.CustomerID = c.CustomerID
  GROUP BY c.CustomerID, c.CustomerName
) x
ORDER BY CustomerRevenue DESC;

21) Total sales per customer (units)
SELECT c.CustomerID, c.CustomerName,
       SUM(s.QuantitySold) AS TotalUnits
FROM Customers c
LEFT JOIN Sales s ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalUnits DESC, c.CustomerID;

22) Products sold at least once
SELECT DISTINCT s.Product
FROM Sales s
ORDER BY s.Product;

23) Most expensive product (by SellingPrice in Products)
SELECT TOP (1) WITH TIES *
FROM Products
ORDER BY SellingPrice DESC;

24) Products priced above their category average (SellingPrice)
SELECT p.*
FROM Products p
WHERE p.SellingPrice >
      (SELECT AVG(p2.SellingPrice) FROM Products p2 WHERE p2.Category = p.Category)
ORDER BY p.Category, p.SellingPrice DESC;