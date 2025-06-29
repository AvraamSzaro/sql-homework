--HW2--
/*
Lesson 2: DDL and DML Commands
Notes before doing the tasks:

Tasks should be solved using SQL Server.
Case insensitivity applies.
Alias names do not affect the score.
Scoring is based on the correct output.
One correct solution is sufficient.
*/
--Basic-Level Tasks (10)--
--1. Create a table Employees with columns: EmpID INT, Name (VARCHAR(50)), and Salary (DECIMAL(10,2)).
CREATE DATABASE HW2
GO
USE HW2
CREATE TABLE Employees(EmpID INT, Name VARCHAR(50), Salary DECIMAL(10,2));
--2. Insert three records into the Employees table using different INSERT INTO approaches (single-row insert and multiple-row insert).
INSERT INTO Employees(EmpID,Name,Salary) VALUES
	(1, 'WILLIAM', 15000000.00);
INSERT INTO Employees(EmpID,Name,Salary) VALUES
	(2, 'GEORGE', 12000000.00),
	(3, 'AMELIA', 80000000.50);
--3. Update the Salary of an employee to 7000 where EmpID = 1.
UPDATE Employees SET Salary=7000 WHERE EmpID=1
--4. Delete a record from the Employees table where EmpID = 2.
DELETE FROM Employees WHERE EmpID=2
--5. Give a brief definition for difference between DELETE, TRUNCATE, and DROP.
/*
DELETE
PURPOSE: REMOVES SPECIFIC ROWS FROM A TABLE.
WHERE CLAUSE: CAN BE USED TO FILTER WHICH ROWS TO DELETE.
ROLLBACK: YES, CAN BE ROLLED BACK (IF INSIDE A TRANSACTION).
AFFECT: DATA ONLY, STRUCTURE STAYS.
EXAMPLE:
*/
BEGIN TRANSACTION; --TRANSACTION BLOCK STARTED
DELETE FROM Employees WHERE NAME='WILLIAM';
ROLLBACK --CANCELLED ALL CHANGES SINCE THE TRANSACTION BEGAN
SELECT * FROM Employees
/*
TRUNCATE
PURPOSE: REMOVES ALL ROWS FROM A TABLE VERY QUICKLY.
WHERE CLAUSE: NOT ALLOWED
ROLLBACK: YES, BUT ONLY IN SOME DBS WITH TRANSACTIONS (SQL SERVER SUPPORTS ROLLBACK IF INSIDE BEGIN TRAN).
AFFECTS: DATA ONLY, RESETS IDENTITY COUNTER.
FASTER THAN DELETE
EXAMPLE:
*/
BEGIN TRANSACTION;
TRUNCATE TABLE Employees;
SELECT * FROM Employees;
ROLLBACK;
SELECT * FROM Employees;
/*
DROP
PURPOSE: DELETES THE ENTIRE TABLE STRUCTURE (SCHEMA + DATA).
CANNOT BE ROLLED BACK (UNLESS IN A TRANSACTION AND NOT COMMITTED).
AFFECTS: ENTIRE OBJECT (TABLE, VIEW, ETC).
EXAMPLE:
*/
DROP TABLE Employees
SELECT * FROM Employees
--FROM THIS POINT DATA EXECUTED FROM BEGINNING--
--6. Modify the Name column in the Employees table to VARCHAR(100).
ALTER TABLE Employees ALTER COLUMN Name VARCHAR(100);
--7. Add a new column Department (VARCHAR(50)) to the Employees table.
ALTER TABLE Employees ADD Department VARCHAR(50);
--8. Change the data type of the Salary column to FLOAT.
ALTER TABLE Employees ALTER COLUMN Salary FLOAT;
--9. Create another table Departments with columns DepartmentID (INT, PRIMARY KEY) and DepartmentName (VARCHAR(50)).
CREATE TABLE Departments (DepartmentID INT PRIMARY KEY, Name VARCHAR(20), DepartmentName VARCHAR(50), Salary DECIMAL(12,2))
SELECT * FROM Departments
--10. Remove all records from the Employees table without deleting its structure.
DELETE FROM Employees
--Intermediate-Level Tasks (6)
--11. Insert five records into the Departments table using INSERT INTO SELECT method(you can write anything you want as data).
INSERT INTO Departments (DepartmentID, Name, DepartmentName, Salary)
SELECT 1, 'ANDREW', 'FINANCE', 250000000.00 UNION ALL
SELECT 2, 'BENEDICT','IT', 200000000.00 UNION ALL
SELECT 3, 'ALEXANDER', 'MARKETING', 50000000.00 UNION ALL
SELECT 4, 'JACK', 'HR', 20000000.00 UNION ALL
SELECT 5, 'ANTONIO', 'LOGISTICS', 100000000.99;
SELECT * FROM Departments
--12. Update the Department of all employees where Salary > 5000 to 'Management'.
UPDATE Departments SET DepartmentName='MANAGEMENT' WHERE Salary>5000
--13. Write a query that removes all employees but keeps the table structure intact.
BEGIN TRANSACTION;
TRUNCATE TABLE Departments
ROLLBACK;
SELECT * FROM Departments
--14. Drop the Department column from the Employees table.
ALTER TABLE Employees
DROP COLUMN Department;
--15. Rename the Employees table to StaffMembers using SQL commands.
EXEC sp_rename 'Employees', 'StaffMembers';
SELECT * FROM StaffMembers
--16. Write a query to completely remove the Departments table from the database.
DROP TABLE Departments;

--Advanced-Level Tasks (9)

/*(--17. Create a table named Products with at least 5 columns, including: ProductID (Primary Key), ProductName (VARCHAR), Category (VARCHAR), Price (DECIMAL) and
--18. Add a CHECK constraint to ensure Price is always greater than 0.)*/

CREATE TABLE Products(ProductID INT PRIMARY KEY, ProductName VARCHAR(20), Category VARCHAR(20), Price DECIMAL(12,2) CHECK(Price>0));
--19. Modify the table to add a StockQuantity column with a DEFAULT value of 50.
ALTER TABLE Products ADD StockQuantity INT DEFAULT 50;
--20. Rename Category to ProductCategory.
EXEC sp_rename 'Products.Category', 'ProductCategory', 'COLUMN';
SELECT * FROM Products
--21. Insert 5 records into the Products table using standard INSERT INTO queries.
INSERT INTO Products(ProductID, ProductName, ProductCategory, Price, StockQuantity)
SELECT 1, 'REDBULL', 'BEVERAGE', 20000.00, 10 UNION ALL
SELECT 2, 'PIXEL 10 PRO', 'ELECTRONICS', 17000000, 2 UNION ALL
SELECT 3, 'F458ITALIA', 'CARS', 1300000000, 1 UNION ALL
SELECT 4, 'NITRO5', 'LAPTOP', 18500000, 1 UNION ALL
SELECT 5, 'CFA', 'CERTIFICATION', 60000000, 3;
--22. Use SELECT INTO to create a backup table called Products_Backup containing all Products data.
SELECT * INTO Product_Backup FROM Products; --Products_Backup created automatically, Data copied, Structure copied
SELECT * FROM Product_Backup
--23. Rename the Products table to Inventory.
EXEC sp_rename 'Products', 'Inventory';
SELECT * FROM Inventory;
--24. Alter the Inventory table to change the data type of Price from DECIMAL(10,2) to FLOAT.
ALTER TABLE Inventory DROP CK__Products__Price__4BAC3F29;
ALTER TABLE Inventory ALTER COLUMN PRICE FLOAT;
--25. Add an IDENTITY column named ProductCode that starts from 1000 and increments by 5 to Inventory table.
	-- Direct method like this does NOT work: ALTER TABLE Inventory ADD ProductCode INT IDENTITY(1000, 5) SO:
EXEC sp_rename 'Inventory', 'Inventory_Old';
CREATE TABLE Inventory (ProductCode INT IDENTITY(1000,5) PRIMARY KEY, ProductName VARCHAR(100), Price FLOAT, StockQuantity INT);
INSERT INTO Inventory(ProductName, Price, StockQuantity)
SELECT ProductName, Price, StockQuantity FROM Inventory_Old
DROP TABLE Inventory_Old
SELECT * FROM Inventory
