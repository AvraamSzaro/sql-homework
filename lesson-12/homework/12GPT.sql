1️⃣ Combine Two Tables — LEFT JOIN Person with Address
sql
Copy
Edit
SELECT 
    P.firstName, 
    P.lastName, 
    A.city, 
    A.state
FROM Person P
LEFT JOIN Address A ON P.personId = A.personId;
2️⃣ Employees Earning More Than Their Managers — Self Join
sql
Copy
Edit
SELECT 
    E.name AS Employee
FROM Employee E
JOIN Employee M ON E.managerId = M.id
WHERE E.salary > M.salary;
3️⃣ Duplicate Emails — GROUP BY HAVING
sql
Copy
Edit
SELECT 
    email
FROM Person
GROUP BY email
HAVING COUNT(*) > 1;
4️⃣ Delete Duplicate Emails — DELETE with Subquery
sql
Copy
Edit
DELETE FROM Person
WHERE id NOT IN (
    SELECT MIN(id)
    FROM Person
    GROUP BY email
);
5️⃣ Parents Who Have Only Girls — NOT EXISTS
sql
Copy
Edit
SELECT DISTINCT 
    g.ParentName
FROM girls g
WHERE NOT EXISTS (
    SELECT 1
    FROM boys b
    WHERE b.ParentName = g.ParentName
);
6️⃣ Total Sales Over 50 + Least Weight (TSQL2012) — GROUP BY with Aggregates
sql
Copy
Edit
SELECT 
    CustomerID, 
    SUM(SalesAmount) AS TotalSalesOver50, 
    MIN(OrderWeight) AS LeastWeight
FROM Sales.Orders
WHERE OrderWeight > 50
GROUP BY CustomerID;
7️⃣ Cart1 and Cart2 Full Outer Join
sql
Copy
Edit
SELECT 
    c1.Item AS [Item Cart 1], 
    c2.Item AS [Item Cart 2]
FROM Cart1 c1
FULL JOIN Cart2 c2 ON c1.Item = c2.Item;
8️⃣ Customers Who Never Order — LEFT JOIN with NULL Filter
sql
Copy
Edit
SELECT 
    C.name AS Customers
FROM Customers C
LEFT JOIN Orders O ON C.id = O.customerId
WHERE O.id IS NULL;
9️⃣ Students and Examinations — CROSS JOIN + LEFT JOIN + COUNT
sql
Copy
Edit
SELECT 
    S.student_id, 
    S.student_name, 
    Sub.subject_name, 
    COUNT(E.subject_name) AS attended_exams
FROM Students S
CROSS JOIN Subjects Sub
LEFT JOIN Examinations E 
    ON S.student_id = E.student_id 
   AND Sub.subject_name = E.subject_name
GROUP BY S.student_id, S.student_name, Sub.subject_name
ORDER BY S.student_id, Sub.subject_name;