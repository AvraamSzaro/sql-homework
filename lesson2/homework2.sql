create database homework2
use homework2
create table Employees (EmpID int, name varchar(50), salary decimal(10,2))
insert into Employees (EmpID, name, salary) values (1, 'Neal', 80200000.25);
insert into Employees (EmpID, name, salary) values 
	(2, 'Mozzie', 67200000.65),
	(3, 'Peter', 56475000.78);
select * from Employees

drop table Employees

update Employees
set salary = '7000'
where EmpID = 1
delete from Employees
/*
delete - removes specific rows from a table (table remains, rollback available)
	e.g. delete from Employees where EmpID=2
truncate - removes all rows from ea table quickly (table remains, no rollback)
	e.g. truncate table Employees
drop - deletes the entire table (structure + data, no rollback(permanent))
	e.g. drop table Employees
*/
ALTER TABLE Employees
ALTER COLUMN name VARCHAR(100)

ALTER TABLE Employees
ADD Department VARCHAR(50)

ALTER TABLE Employees
ALTER COLUMN salary FLOAT;


drop table Employees

create table Employees (EmpID int, name varchar(50), salary decimal(10,2))
alter table Employees
add Department varchar(50)

select * from Employees
insert into Employees (EmpID, name, salary, Department) values
	(458, 'Izzy', 4565.44, 'IT'),
	(12, 'Bernard', 7854.25, 'Business'),
	(88, 'Fergo', 645.85, 'Finance'),
	(11, 'Richard', 154.75, 'Tourism'),
	(22, 'Selena', 6666.55, 'Music');
update Employees
set Department = 'Management' where salary>5000;
delete from Employees

alter table Employees
drop column Department;
EXEC sp_rename 'Employees', 'StaffMembers';
DROP TABLE StaffMembers;





create table Products (ProductID int Primary Key, ProductName VARCHAR(20), Category VARCHAR(20), Price DECIMAL(20,5));
select * from Products;
ALTER TABLE Products
ADD CONSTRAINT chk_price_positive CHECK (Price > 0);


alter table Products
add StockQuantity int default 50;

EXEC sp_rename 'Products.Category', 'ProductCategory', 'COLUMN';

INSERT INTO Products (ProductID, ProductName, ProductCategory, Price, StockQuantity)
VALUES (1, 'Laptop', 'Electronics', 1200.00, 30);

INSERT INTO Products (ProductID, ProductName, ProductCategory, Price, StockQuantity)
VALUES (2, 'Desk Chair', 'Furniture', 150.00, 45);

INSERT INTO Products (ProductID, ProductName, ProductCategory, Price, StockQuantity)
VALUES (3, 'Water Bottle', 'Accessories', 12.50, 100);

INSERT INTO Products (ProductID, ProductName, ProductCategory, Price, StockQuantity)
VALUES (4, 'Smartphone', 'Electronics', 899.99, 20);

INSERT INTO Products (ProductID, ProductName, ProductCategory, Price, StockQuantity)
VALUES (5, 'Notebook', 'Stationery', 2.99, 200);

select * from Products;

SELECT *
INTO Products_Backup
FROM Products;

select * from Products_Backup

EXEC sp_rename 'Products', 'Inventory';
select * from Inventory;

alter table inventory
alter column price float;

ALTER TABLE Inventory
DROP CONSTRAINT chk_price_positive;

ALTER TABLE Inventory
ALTER COLUMN Price FLOAT;

ALTER TABLE Inventory
ADD CONSTRAINT chk_price_positive CHECK (Price > 0);


CREATE TABLE Inventory_New (
    ProductCode INT IDENTITY(1000, 5) PRIMARY KEY,
    ProductID INT,
    ProductName VARCHAR(100),
    ProductCategory VARCHAR(50),
    Price FLOAT,
    StockQuantity INT
);


INSERT INTO Inventory_New (ProductID, ProductName, ProductCategory, Price, StockQuantity)
SELECT ProductID, ProductName, ProductCategory, Price, StockQuantity
FROM Inventory;

DROP TABLE Inventory;

EXEC sp_rename 'Inventory_New', 'Inventory';