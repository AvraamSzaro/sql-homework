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

5) 3-day moving average of sales (prev, current, next) by order_date
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

7) Rank customers by total purchase amount (global, ties share rank)
WITH t AS (
  SELECT customer_id, customer_name, SUM(total_amount) AS total_spent
  FROM sales_data
  GROUP BY customer_id, customer_name
)
SELECT *, DENSE_RANK() OVER (ORDER BY total_spent DESC) AS spend_rank
FROM t
ORDER BY spend_rank, customer_id;

8) Difference vs previous sale amount per customer
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

10) Cumulative sum of sales per region by order_date
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

12) “Sum of previous values” (sample ID → running sum 1..n)
-- Assuming a table like: CREATE TABLE Ids(ID INT);
-- Use running sum ordered by ID:
SELECT ID,
       SUM(ID) OVER (ORDER BY ID ROWS UNBOUNDED PRECEDING) AS SumPreValues
FROM (VALUES (1),(2),(3),(4),(5)) v(ID);

13) Sum of previous to current value (table OneColumn)
SELECT
  Value,
  SUM(Value) OVER (ORDER BY (SELECT NULL) ROWS UNBOUNDED PRECEDING) AS [Sum of Previous]
FROM OneColumn;

14) Customers who purchased from more than one product_category
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
WHERE s.total_spent >
      AVG(s.total_spent) OVER (PARTITION BY s.region)
ORDER BY s.region, s.total_spent DESC;

16) Rank customers by total spending within each region (ties share rank)
WITH spend AS (
  SELECT customer_id, customer_name, region, SUM(total_amount) AS total_spent
  FROM sales_data
  GROUP BY customer_id, customer_name, region
)
SELECT *,
       DENSE_RANK() OVER (PARTITION BY region ORDER BY total_spent DESC) AS region_rank
FROM spend
ORDER BY region, region_rank, customer_id;

17) Running total of total_amount per customer_id ordered by order_date
SELECT
  customer_id, customer_name, order_date, total_amount,
  SUM(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date
                          ROWS UNBOUNDED PRECEDING) AS cumulative_sales
FROM sales_data
ORDER BY customer_id, order_date;

18) Monthly sales growth rate vs previous month
WITH m AS (
  SELECT
    CONVERT(date, DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1)) AS month_start,
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

19) Customers whose total_amount > their last order’s total_amount
SELECT *
FROM (
  SELECT
    *,
    LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_amount
  FROM sales_data
) x
WHERE prev_amount IS NOT NULL AND total_amount > prev_amount
ORDER BY customer_id, order_date;

Hard
20) Identify products whose unit_price is above the overall average product price
-- Consider the product as (product_category, product_name, unit_price)
-- If products can repeat, distinct prices per product_name are grouped first.
WITH p AS (
  SELECT product_name, MAX(unit_price) AS unit_price
  FROM sales_data
  GROUP BY product_name
)
SELECT product_name, unit_price
FROM p
WHERE unit_price > (SELECT AVG(unit_price) FROM p)
ORDER BY unit_price DESC, product_name;

21) Put group total (val1+val2 per group) only on the first row of each group
WITH t AS (
  SELECT *,
         SUM(val1 + val2) OVER (PARTITION BY grp) AS grp_total,
         ROW_NUMBER()      OVER (PARTITION BY grp ORDER BY id) AS rn
  FROM MyData
)
SELECT
  id, grp, val1, val2,
  CASE WHEN rn = 1 THEN grp_total ELSE NULL END AS Tot
FROM t
ORDER BY grp, id;

22) TheSumPuzzle: sum Cost by ID; Quantity sums if different, else keep one
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


This prints (with your data):

Gap Start | Gap End
----------+--------
1         | 6
8         | 12
16        | 26
36        | 51


If you want any outputs pivoted, wrapped into views or stored procedures, or validated with sample runs, I can adapt these instantly.