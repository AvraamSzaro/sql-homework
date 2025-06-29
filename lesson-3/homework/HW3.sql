--HOMEWORK3--
-- Easy-Level Tasks (10)--
--1. Define and explain the purpose of BULK INSERT in SQL Server.
/*
BULK INSERT IS A TRANSACT-SQL(T-SQL) COMMAND IN SQL SERVER USED TO IMPORT LARGE VOLUMES OF DATA FROM A DATA FILE (E.G., .TXT OR .CSV) DIRECTLY INTO A SQL SERVER TABLE.
		BULK INSERT TABLENAME
		FROM 'FULLFILEPATH'
		WITH(
			FIRSTROW=2, 
			FIELDTERMINATOR=',',
			ROWTERMINATOR='\n'
		);
PURPOSE:
EFFICIENT DATA IMPORT: IT'S OPTIMIZED FOR FAST INSERTION OF LARGE DATASETS (THOUSANDS TO MILLIONS OF ROWS).
AUTOMATION: OFTEN USED IN ETL PROCESSES (EXTRACT, TRANSFORM, LOAD) TO AUTOMATE IMPORTING DATA FROM EXTERNAL SYSTEMS.
REDUCED OVERHEAD: COMPARED TO INSERTING ROW-BY-ROW USING INSERT, BULK INSERT REDUCES TRANSACTION AND LOGGING OVERHEAD.
Imagine you have a CSV file named employees.csv:
	1,John,Manager
	2,Sarah,Analyst
	3,Ali,Clerk
You can bulk import it like this:
	BULK INSERT EMPLOYEES
	FROM 'C:\Data\employees.csv'
	WITH(
		FIELDTERMINATOR=',',
		ROWTERMINATOR='\n',
		FIRSTROW=1
	);
USE CASES: 
Importing data exported from Excel/CSV.
Daily log or transaction uploads.
Data warehouse population.
Notes:
File must be accessible from the SQL Server machine.
You may need to configure file and login permissions.
For remote data or more control, use BULK INSERT alternatives like bcp or OPENROWSET(BULK...).
*/

--2. List four file formats that can be imported into SQL Server.
/*
.SQL
.TXT
.XLS OR XLSX
.XML
*/

--3. Create a table Products with columns: ProductID (INT, PRIMARY KEY), ProductName (VARCHAR(50)), Price (DECIMAL(10,2)).
CREATE DATABASE HW3
GO
USE HW3
CREATE TABLE Products (ProductID INT PRIMARY KEY, ProductName VARCHAR(50), Price DECIMAL(10,2));
--4. Insert three records into the Products table using INSERT INTO.
INSERT INTO Products (ProductID, ProductName, Price) VALUES
	(1, 'Laptop', 1200.00),
	(2, 'Mouse', 25.50),
	(3, 'Keyboard', 45.00);
--5. Explain the difference between NULL and NOT NULL.
/*
NULL means "no value" or "unknown value". It doesn't mean 0 or empty string — it literally means nothing has been stored. SQL treats NULL as a special marker to indicate missing or unavailable data.
NOT NULL is a constraint that prevents a column from having NULL values. It means the column must have a valid value when a new row is inserted.
*/
--6. Add a UNIQUE constraint to the ProductName column in the Products table.
ALTER TABLE Products ADD CONSTRAINT UQ_ProductName UNIQUE (ProductName)
--7. Write a comment in a SQL query explaining its purpose.
/*
	Explain complex logic
	Leave notes for future developers or your future self
	--Describe what a query does--
*/
--8. Add CategoryID column to the Products table.
ALTER TABLE Products ADD CategoryID INT;
--9. Create a table Categories with a CategoryID as PRIMARY KEY and a CategoryName as UNIQUE.
CREATE TABLE Categories (CategoryID INT PRIMARY KEY, CategoryName VARCHAR(50) UNIQUE);
--10. Explain the purpose of the IDENTITY column in SQL Server.
/*
The IDENTITY column in SQL Server is used to automatically generate unique numeric values for a column, usually for a primary key.
E.G. IDENTITY(1000, 5) → Starts from 1000 and increments by 5 (1000, 1005, 1010...)
*/

-- Medium-Level Tasks (10)--
--11. Use BULK INSERT to import data from a text file into the Products table.
CREATE TABLE Staging_Products (
    ProductID INT,
    ProductName VARCHAR(100),
    Price DECIMAL(10,2),
    CategoryID INT
);

BULK INSERT Staging_Products
FROM 'C:\Users\LuxEliteClub\Downloads\Full SQL\LESSON 3\products.txt'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

INSERT INTO Products (ProductID, ProductName, Price, CategoryID)
SELECT s.ProductID, s.ProductName, s.Price, s.CategoryID
FROM Staging_Products s
WHERE NOT EXISTS (
    SELECT 1 FROM Products p WHERE p.ProductID = s.ProductID
);

DROP TABLE Staging_Products;

--12. Create a FOREIGN KEY in the Products table that references the Categories table.
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) UNIQUE
);
GO
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50) UNIQUE,
    Price DECIMAL(10,2) CHECK (Price > 0),
    Stock INT NOT NULL DEFAULT 0,
    CategoryID INT,
    CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryID)
        REFERENCES Categories(CategoryID)
);
GO
INSERT INTO Categories (CategoryID, CategoryName)
VALUES (1, 'Electronics'), (2, 'Accessories');
INSERT INTO Products (ProductID, ProductName, Price, Stock, CategoryID)
VALUES
(1, 'Laptop', 1200.00, 10, 1),
(2, 'Mouse', 25.50, 50, 2),
(3, 'Keyboard', 45.00, 30, 1);
--13. Explain the differences between PRIMARY KEY and UNIQUE KEY.
/*
Use PRIMARY KEY for your main unique identifier.
Use UNIQUE KEY for other fields that must not have duplicates (like usernames or emails).
*/
--14. Add a CHECK constraint to the Products table ensuring Price > 0.
ALTER TABLE Products
ADD CONSTRAINT CHK_Price_Positive
CHECK (Price > 0);
--15. Modify the Products table to add a column Stock (INT, NOT NULL).
ALTER TABLE Products
DROP CONSTRAINT DF__Products__Stock__2A6B46EF;
ALTER TABLE Products
DROP COLUMN Stock;
ALTER TABLE Products
ADD Stock INT NOT NULL DEFAULT 0;
--16. Use the ISNULL function to replace NULL values in Price column with a 0.
SELECT 
    ProductID,
    ProductName,
    ISNULL(Price, 0) AS Price,
    Stock,
    CategoryID
FROM Products;
--17. Describe the purpose and usage of FOREIGN KEY constraints in SQL Server.
/*
A FOREIGN KEY is a constraint used to link two tables together. It enforces a relationship between the column in one table (child) and the PRIMARY KEY (or UNIQUE) column in another table (parent).
*/

--Hard-Level Tasks (10)--

--18. Write a script to create a Customers table with a CHECK constraint ensuring Age >= 18.
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Age INT NOT NULL,
    Email VARCHAR(100),
    CONSTRAINT CHK_Customer_Age CHECK (Age >= 18)
);
INSERT INTO Customers (CustomerID, FullName, Age, Email)
VALUES (1, 'Joe Biden', 25, 'jb@example.com');
-- This will fail due to the CHECK constraint
INSERT INTO Customers (CustomerID, FullName, Age, Email)
VALUES (2, 'Young User', 17, 'young@example.com');
--19. Create a table with an IDENTITY column starting at 100 and incrementing by 10.
CREATE TABLE Orders (
    OrderID INT IDENTITY(100, 10) PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    OrderDate DATE DEFAULT GETDATE()
);
INSERT INTO Orders (CustomerName) VALUES ('John Doe');
INSERT INTO Orders (CustomerName) VALUES ('Joe Biden');
--20. Write a query to create a composite PRIMARY KEY in a new table OrderDetails.
CREATE TABLE OrderDetails (
    OrderID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    CONSTRAINT PK_OrderDetails PRIMARY KEY (OrderID, ProductID)
);
--21. Explain the use of COALESCE and ISNULL functions for handling NULL values.
/*
ISNULL(expression, replacement_value)
What It Does:
Replaces NULL with a specified value.
Returns the data type of the first argument.

COALESCE(expression1, expression2, ..., expressionN)
 What It Does:
Returns the first non-NULL value in the list.
Can take multiple arguments.
Returns the highest precedence data type among the inputs.
*/
--22. Create a table Employees with both PRIMARY KEY on EmpID and UNIQUE KEY on Email.
CREATE TABLE Employees (
    EmpID INT NOT NULL,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Position VARCHAR(50),
    PRIMARY KEY (EmpID),
    UNIQUE (Email)
);
--23. Write a query to create a FOREIGN KEY with ON DELETE CASCADE and ON UPDATE CASCADE options.
-- Parent table
-- Parent table
CREATE TABLE Departments (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(100)
);

-- Child table with FOREIGN KEY constraint
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    Name VARCHAR(100),
    DeptID INT,
    FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);