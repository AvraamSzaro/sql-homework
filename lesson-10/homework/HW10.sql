DROP TABLE IF EXISTS Employees;

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    DepartmentID INT,
    Salary DECIMAL(10, 2),
    HireDate DATE,
    ManagerID INT,
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)
);

INSERT INTO Employees (EmployeeID, Name, DepartmentID, Salary, HireDate, ManagerID) VALUES
(1, 'John Doe', 1, 55000.00, '2020-01-01', NULL),  
(2, 'Jane Smith', 2, 65000.00, '2019-03-15', 1),
(3, 'Mary Johnson', 3, 45000.00, '2021-05-10', 2),
(4, 'James Brown', 5, 60000.00, '2018-07-22', 1),
(5, 'Patricia Davis', 4, 70000.00, '2017-08-30', 4),
(6, 'Michael Miller', 2, 75000.00, '2020-12-12', 2),
(7, 'Linda Wilson', 3, 48000.00, '2016-11-02', 3),
(8, 'David Moore', 4, 85000.00, '2021-09-01', 5),
(9, 'Elizabeth Taylor', 1, 60000.00, '2019-05-18', 1),
(10, 'William Anderson', 2, 64000.00, '2020-04-10', 2),
(11, 'Susan Thomas', 3, 47000.00, '2017-01-25', 3),
(12, 'Joseph Jackson', 4, 78000.00, '2016-09-30', 5),
(13, 'Karen White', 1, 59000.00, '2018-06-10', 9),
(14, 'Steven Harris', 2, 71000.00, '2021-07-15', 6),
(15, 'Nancy Clark', 3, 45000.00, '2020-02-20', 7),
(16, 'George Lewis', 4, 80000.00, '2019-11-10', 8),
(17, 'Betty Lee', 5, 55000.00, '2017-04-05', 4),
(18, 'Samuel Walker', 2, 72000.00, '2021-03-22', 6),
(19, 'Helen Hall', 3, 49000.00, '2018-10-16', 7),
(20, 'Charles Allen', 4, 90000.00, '2015-08-11', 12),
(21, 'Betty Young', 1, 53000.00, '2020-05-17', 9),
(22, 'Frank King', 2, 67000.00, '2021-02-02', 10),
(23, 'Deborah Scott', 3, 47000.00, '2019-07-09', 11),
(24, 'Matthew Green', 4, 76000.00, '2021-01-15', 16),
(25, 'Sandra Adams', 1, 54000.00, '2020-06-21', 21),
(26, 'Paul Nelson', 2, 71000.00, '2018-12-03', 10),
(27, 'Margaret Carter', 3, 46000.00, '2020-08-19', 19),
(28, 'Anthony Mitchell', 4, 82000.00, '2021-04-10', 16),
(29, 'Lisa Perez', 1, 60000.00, '2021-03-05', 21),
(30, 'Christopher Roberts', 2, 69000.00, '2019-09-24', 22),
(31, 'Jessica Gonzalez', 3, 47000.00, '2017-12-13', 23),
(32, 'Brian Moore', 5, 85000.00, '2018-11-05', 17),
(33, 'Dorothy Evans', 1, 59000.00, '2019-06-11', 25),
(34, 'Matthew Carter', 2, 70000.00, '2020-01-29', 26),
(35, 'Rachel Martinez', 3, 51000.00, '2021-06-06', 27),
(36, 'Daniel Perez', 4, 83000.00, '2021-07-01', 28),
(37, 'Catherine Roberts', 1, 60000.00, '2020-09-19', 29),
(38, 'Ronald Murphy', 2, 68000.00, '2017-02-04', 30),
(39, 'Angela Jenkins', 3, 52000.00, '2018-04-23', 31),
(40, 'Gary Wright', 4, 87000.00, '2021-01-10', 36),
(41, 'Kevin Turner', 6, 55000.00, '2022-02-14', NULL), 
(42, 'Laura Phillips', 7, 62000.00, '2023-05-22', 41),
(43, 'Eric Collins', 8, 58000.00, '2020-10-30', 41),
(44, 'Megan Edwards', 9, 70000.00, '2019-11-25', 41);

DROP TABLE IF EXISTS Departments;

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);

INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'Sales'),
(2, 'Human Resources'),
(3, 'IT'),
(4, 'Marketing'),
(5, 'Finance');

DROP TABLE IF EXISTS Customers;

--1. Create Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(50),
    Address VARCHAR(255),
    City VARCHAR(100),
    State VARCHAR(100),
    PostalCode VARCHAR(20),
    Country VARCHAR(100)
);

--2. Insert 40 Rows into Customers Table
INSERT INTO Customers (CustomerID, FirstName, LastName, Email, Phone, Address, City, State, PostalCode, Country) VALUES
(1, 'John', 'Doe', 'johndoe@gmail.com', '555-1234', '123 Elm St', 'New York', 'NY', '10001', 'USA'),
(2, 'Jane', 'Smith', 'janesmith@yahoo.com', '555-2345', '456 Oak St', 'Los Angeles', 'CA', '90001', 'USA'),
(3, 'Alice', 'Johnson', 'alicej@outlook.com', '555-3456', '789 Pine St', 'Toronto', 'ON', 'M4B1B3', 'Canada'),
(4, 'Bob', 'Brown', 'bobbrown@hotmail.com', '555-4567', '101 Maple St', 'Vancouver', 'BC', 'V5K0A1', 'Canada'),
(5, 'Charlie', 'Davis', 'charliedavis@gmail.com', '555-5678', '202 Birch St', 'Sydney', 'NSW', '2000', 'Australia'),
(6, 'David', 'Martinez', 'davidm@live.com', '555-6789', '303 Cedar St', 'Melbourne', 'VIC', '3000', 'Australia'),
(7, 'Emily', 'Garcia', 'emilyg@yahoo.com', '555-7890', '404 Redwood St', 'London', 'England', 'SW1A 1AA', 'UK'),
(8, 'Frank', 'Hernandez', 'frankh@outlook.com', '555-8901', '505 Willow St', 'Manchester', 'England', 'M1 1AE', 'UK'),
(9, 'Grace', 'Lopez', 'gracel@gmail.com', '555-9012', '606 Aspen St', 'Birmingham', 'England', 'B1 1AA', 'UK'),
(10, 'Helen', 'Gonzalez', 'heleng@yahoo.com', '555-0123', '707 Fir St', 'Berlin', 'BE', '10117', 'Germany'),
(11, 'Irene', 'Perez', 'irenep@hotmail.com', '555-1234', '808 Maple Ave', 'Munich', 'BY', '80331', 'Germany'),
(12, 'Jack', 'Wilson', 'jackw@live.com', '555-2345', '909 Oak Ave', 'Hamburg', 'HH', '20095', 'Germany'),
(13, 'Kim', 'Anderson', 'kima@gmail.com', '555-3456', '111 Pine Ave', 'Paris', 'Île-de-France', '75001', 'France'),
(14, 'Liam', 'Thomas', 'liamt@yahoo.com', '555-4567', '222 Cedar Ave', 'Lyon', 'Auvergne-Rhône-Alpes', '69001', 'France'),
(15, 'Megan', 'Taylor', 'megant@outlook.com', '555-5678', '333 Redwood Ave', 'Marseille', 'Provence-Alpes-Côte Azur', '13001', 'France'),
(16, 'Nathan', 'Moore', 'nathanm@hotmail.com', '555-6789', '444 Willow Ave', 'Tokyo', 'TK', '100-0001', 'Japan'),
(17, 'Olivia', 'Jackson', 'oliviaj@gmail.com', '555-7890', '555 Birch Ave', 'Osaka', 'OS', '530-0001', 'Japan'),
(18, 'Paul', 'White', 'paulw@yahoo.com', '555-8901', '666 Maple Blvd', 'Kyoto', 'KY', '600-8001', 'Japan'),
(19, 'Quincy', 'Lee', 'quincyl@outlook.com', '555-9012', '777 Oak Blvd', 'Seoul', 'SO', '04547', 'South Korea'),
(20, 'Rachel', 'Harris', 'rachelh@hotmail.com', '555-0123', '888 Pine Blvd', 'Busan', 'BU', '48058', 'South Korea'),
(21, 'Sam', 'Clark', 'samc@gmail.com', '555-1234', '999 Cedar Blvd', 'Incheon', 'IC', '22382', 'South Korea'),
(22, 'Tina', 'Allen', 'tinaallen@yahoo.com', '555-2345', '1010 Redwood Blvd', 'Mexico City', 'CMX', '01000', 'Mexico'),
(23, 'Ursula', 'Scott', 'ursulas@outlook.com', '555-3456', '1111 Willow Blvd', 'Guadalajara', 'JAL', '44100', 'Mexico'),
(24, 'Victor', 'Adams', 'victora@hotmail.com', '555-4567', '1212 Birch Blvd', 'Monterrey', 'NLE', '64000', 'Mexico'),
(25, 'Walter', 'Baker', 'walterb@live.com', '555-5678', '1313 Oak Blvd', 'New York', 'NY', '10001', 'USA'),
(26, 'Xander', 'Nelson', 'xandern@gmail.com', '555-6789', '1414 Cedar Blvd', 'Los Angeles', 'CA', '90001', 'USA'),
(27, 'Yvonne', 'Carter', 'yvonnec@yahoo.com', '555-7890', '1515 Maple Dr', 'Chicago', 'IL', '60601', 'USA'),
(28, 'Zane', 'Mitchell', 'zanem@outlook.com', '555-8901', '1616 Redwood Dr', 'Houston', 'TX', '77001', 'USA'),
(29, 'Anna', 'Roberts', 'annar@hotmail.com', '555-9012', '1717 Willow Dr', 'Sydney', 'NSW', '2000', 'Australia'),
(30, 'Ben', 'King', 'benk@live.com', '555-0123', '1818 Birch Dr', 'Melbourne', 'VIC', '3000', 'Australia'),
(31, 'Chloe', 'Green', 'chloeg@gmail.com', '555-1234', '1919 Oak Dr', 'Toronto', 'ON', 'M4B1B3', 'Canada'),
(32, 'Daniel', 'Evans', 'daniele@yahoo.com', '555-2345', '2020 Cedar Dr', 'Vancouver', 'BC', 'V5K0A1', 'Canada'),
(33, 'Ella', 'Collins', 'ellac@outlook.com', '555-3456', '2121 Redwood Dr', 'London', 'England', 'SW1A 1AA', 'UK'),
(34, 'Finn', 'Morris', 'finnm@hotmail.com', '555-4567', '2222 Willow St', 'Manchester', 'England', 'M1 1AE', 'UK'),
(35, 'Grace', 'Lee', 'gracel@live.com', '555-5678', '2323 Birch St', 'Berlin', 'BE', '10117', 'Germany'),
(36, 'Holly', 'Martinez', 'hollym@gmail.com', '555-6789', '2424 Oak St', 'Munich', 'BY', '80331', 'Germany'),
(37, 'Ian', 'Robinson', 'ianr@yahoo.com', '555-7890', '2525 Cedar St', 'Warsaw', 'WA', '00-001', 'Poland'),
(38, 'Jasmine', 'Walker', 'jasminew@outlook.com', '555-8901', '2626 Redwood St', 'Lisbon', 'LI', '1100-148', 'Portugal'),
(39, 'Kyle', 'Young', 'kyley@hotmail.com', '555-9012', '2727 Willow St', 'Pittsburgh', 'PA', '15201','USA'),
(40, 'Liam', 'Harris', 'liamh@live.com', '555-0123', '2828 Birch St', 'Richmond', 'VA', '23220','USA');

DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS Orders;

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT NULL,
    OrderDate DATE,
    Quantity INT,
    TotalAmount DECIMAL(10, 2)
);

-- Insert 40 rows into Orders with randomized IDs and NULL ProductIDs for some
INSERT INTO Orders VALUES
(102, 15, 2, '2023-05-14', 1, 800.00),
(205, 8, 3, '2024-09-07', 2, 800.00),
(311, 22, 4, '2022-11-22', 1, 250.00),
(421, 33, 5, '2021-03-30', 3, 150.00),
(523, 40, NULL, '2025-07-19', 1, 30.00),
(610, 19, 7, '2022-08-25', 2, 300.00),
(728, 14, 8, '2024-06-10', 1, 200.00),
(812, 27, 9, '2021-12-04', 4, 40.00),
(915, 6, 10, '2023-02-18', 1, 10.00),
(1003, 31, NULL, '2025-09-27', 2, 360.00),
(1108, 12, 12, '2023-10-11', 1, 500.00),
(1205, 29, 13, '2024-04-03', 1, 25.00),
(1354, 4, 14, '2022-07-29', 2, 60.00),
(1411, 9, 15, '2021-01-22', 3, 135.00),
(1533, 23, NULL, '2025-11-15', 1, 80.00),
(1622, 36, 17, '2022-10-08', 1, 60.00),
(1710, 1, 18, '2023-06-21', 2, 40.00),
(1845, 20, 19, '2021-09-13', 5, 50.00),
(1908, 37, 20, '2025-03-05', 2, 50.00),
(2042, 10, 21, '2024-08-14', 1, 60.00),
(2157, 13, 22, '2022-12-01', 1, 100.00),
(2268, 35, 23, '2023-09-09', 1, 15.00),
(2349, 7, 24, '2021-07-18', 2, 180.00),
(2481, 17, NULL, '2025-06-23', 3, 15.00),
(2594, 5, 26, '2023-03-12', 4, 100.00),
(2633, 26, 27, '2022-04-07', 1, 450.00),
(2782, 39, 28, '2024-11-30', 1, 600.00),
(2845, 24, 29, '2021-02-25', 1, 500.00),
(2903, 2, 30, '2025-05-28', 2, 240.00),
(3011, 16, 31, '2023-08-20', 1, 350.00),
(3152, 21, 32, '2022-01-17', 1, 450.00),
(3227, 38, 33, '2025-09-10', 1, 40.00),
(3368, 11, 34, '2021-04-04', 2, 100.00),
(3419, 3, 35, '2024-07-15', 3, 120.00),
(3551, 18, 36, '2022-10-31', 1, 60.00),
(3684, 32, 37, '2023-12-22', 1, 35.00),
(3749, 28, 38, '2021-06-06', 2, 110.00),
(3872, 25, NULL, '2025-02-01', 1, 40.00),
(3911, 30, 40, '2023-11-26', 3, 120.00),
(4057, 22, 1, '2024-03-09', 1, 1200.00);

DROP TABLE IF EXISTS Payments;

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY,
    OrderID INT NULL,
    PaymentDate DATE,
    Amount DECIMAL(10, 2),
    PaymentMethod VARCHAR(50),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Insert 30 payments, some without matching orders
INSERT INTO Payments VALUES
(501, 102, '2023-05-15', 800.00, 'Credit Card'),
(502, 205, '2024-09-08', 800.00, 'PayPal'),
(503, 311, '2022-11-23', 250.00, 'Bank Transfer'),
(504, NULL, '2024-01-05', 500.00, 'Cash'),
(505, 421, '2021-03-31', 150.00, 'Credit Card'),
(506, 610, '2022-08-26', 300.00, 'Debit Card'),
(507, 728, '2024-06-11', 200.00, 'PayPal'),
(508, NULL, '2023-12-20', 75.00, 'Bank Transfer'),
(509, 915, '2023-02-19', 10.00, 'Cash'),
(510, 1003, '2025-09-28', 360.00, 'Credit Card'),
(511, 1108, '2023-10-12', 500.00, 'PayPal'),
(512, 1205, '2024-04-04', 25.00, 'Debit Card'),
(513, 1354, '2022-07-30', 60.00, 'Credit Card'),
(514, NULL, '2024-02-17', 1200.00, 'Wire Transfer'), 
(515, 1411, '2021-01-23', 135.00, 'Bank Transfer'),
(516, NULL, '2023-06-29', 150.00, 'PayPal'), 
(517, 1622, '2022-10-09', 60.00, 'Cash'),
(518, 1710, '2023-06-22', 40.00, 'Debit Card'),
(519, 1845, '2021-09-14', 50.00, 'Credit Card'),
(520, NULL, '2025-01-18', 95.00, 'Bank Transfer'); 

DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Suppliers;
-- Create Suppliers Table
CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY,
    SupplierName VARCHAR(100),
    ContactName VARCHAR(100),
    Email VARCHAR(150)
);

INSERT INTO Suppliers (SupplierID, SupplierName, ContactName, Email) VALUES
(1, 'Tech Distributors', 'Alice Johnson', 'alice@techdist.com'),
(2, 'Gadget Supplies', 'Bob Smith', 'bob@gadgetsupplies.com'),
(3, 'Office Essentials', 'Charlie Davis', 'charlie@officeessentials.com'),
(4, 'Furniture Hub', 'Diana Adams', 'diana@furniturehub.com'),
(5, 'Clothing Mart', 'Ethan Clark', 'ethan@clothingmart.com'),
(6, 'Car Parts', 'Tom Hanks', 'tom@carparts.com'),
(7, 'Toys', 'John Adams', 'john@toysff.com');

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10, 2),
    Category VARCHAR(50),
    StockQuantity INT,
    SupplierID INT,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

INSERT INTO Products (ProductID, ProductName, Price, Category, StockQuantity, SupplierID) VALUES
(1, 'Laptop', 1200.00, 'Electronics', 30, 1),
(2, 'Smartphone', 800.00, 'Electronics', 50, 1),
(3, 'Tablet', 400.00, 'Electronics', 40, 1),
(4, 'Monitor', 250.00, 'Electronics', 60, 1),
(5, 'Keyboard', 50.00, 'Accessories', 100, 2),
(6, 'Mouse', 30.00, 'Accessories', 120, 2),
(7, 'Chair', 150.00, 'Furniture', 80, 4),
(8, 'Desk', 200.00, 'Furniture', 75, 4),
(9, 'Pen', 5.00, 'Stationery', 300, 3),
(10, 'Notebook', 10.00, 'Stationery', 500, 3),
(11, 'Printer', 180.00, 'Electronics', 25, 1),
(12, 'Camera', 500.00, 'Electronics', 40, 1),
(13, 'Flashlight', 25.00, 'Tools', 200, 2),
(14, 'Shirt', 30.00, 'Clothing', 150, 5),
(15, 'Jeans', 45.00, 'Clothing', 120, 5),
(16, 'Jacket', 80.00, 'Clothing', 70, 5),
(17, 'Shoes', 60.00, 'Clothing', 100, 5),
(18, 'Hat', 20.00, 'Accessories', 50, 2),
(19, 'Socks', 10.00, 'Clothing', 200, 5),
(20, 'T-Shirt', 25.00, 'Clothing', 150, 5),
(21, 'Lamp', 60.00, 'Furniture', 40, 4),
(22, 'Coffee Table', 100.00, 'Furniture', 35, 4),
(23, 'Book', 15.00, 'Stationery', 250, 3),
(24, 'Rug', 90.00, 'Furniture', 60, 4),
(25, 'Cup', 5.00, 'Accessories', 500, 2),
(26, 'Bag', 25.00, 'Accessories', 300, 2),
(27, 'Couch', 450.00, 'Furniture', 15, 4),
(28, 'Fridge', 600.00, 'Electronics', 20, 1),
(29, 'Stove', 500.00, 'Electronics', 15, 1),
(30, 'Microwave', 120.00, 'Electronics', 25, 1),
(31, 'Air Conditioner', 350.00, 'Electronics', 10, 1),
(32, 'Washing Machine', 450.00, 'Electronics', 15, 1),
(33, 'Dryer', 400.00, 'Electronics', 10, 1),
(34, 'Hair Dryer', 30.00, 'Accessories', 100, 2),
(35, 'Iron', 40.00, 'Electronics', 50, 1),
(36, 'Coffee Maker', 50.00, 'Electronics', 60, 1),
(37, 'Blender', 35.00, 'Electronics', 40, 1),
(38, 'Juicer', 55.00, 'Electronics', 30, 1),
(39, 'Toaster', 40.00, 'Electronics', 70, 1),
(40, 'Dishwasher', 500.00, 'Electronics', 20, 1);

DROP TABLE IF EXISTS Categories;

-- Create Categories Table
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY,
    CategoryName VARCHAR(50) UNIQUE
);

-- Insert Unique Categories
INSERT INTO Categories (CategoryName) VALUES 
('Electronics'),
('Accessories'),
('Furniture'),
('Stationery'),
('Tools'),
('Clothing');

UPDATE P 
SET P.Category = C.CategoryID
FROM Products P  JOIN Categories C ON P.Category=C.CategoryName

UPDATE Products
SET Category = 10
WHERE Category = 4  

ALTER TABLE Products
ALTER COLUMN Category INT NULL

DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Courses;

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(100),
    Age INT,
    Major VARCHAR(50)
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    Instructor VARCHAR(100)
);

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY IDENTITY,
    StudentID INT,
    CourseID INT,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

INSERT INTO Students (StudentID, Name, Age, Major) VALUES
(1, 'Alice Johnson', 20, 'Computer Science'),
(2, 'Bob Smith', 21, 'Mathematics'),
(3, 'Charlie Brown', 22, 'Physics'),
(4, 'David Wilson', 19, 'Engineering'),
(5, 'Emma Davis', 20, 'Biology'),
(6, 'Frank Moore', 23, 'Business'),
(7, 'Grace Taylor', 21, 'Mathematics'),
(8, 'Henry Anderson', 20, 'Economics'),
(9, 'Isabella Thomas', 22, 'Chemistry'),
(10, 'Jack White', 19, 'Computer Science'),
(11, 'Karen Harris', 20, 'Mathematics'),
(12, 'Liam Martin', 21, 'Engineering'),
(13, 'Mia Clark', 22, 'Biology'),
(14, 'Noah Lewis', 20, 'Physics'),
(15, 'Olivia Walker', 19, 'Business'),
(16, 'Paul Hall', 22, 'Computer Science'),
(17, 'Quinn Young', 21, 'Economics'),
(18, 'Rachel King', 20, 'Chemistry'),
(19, 'Samuel Allen', 23, 'Engineering'),
(20, 'Taylor Scott', 21, 'Mathematics'),
(21, 'Ursula Green', 20, 'Biology'),
(22, 'Victor Adams', 22, 'Physics'),
(23, 'Wendy Baker', 19, 'Business'),
(24, 'Xavier Cooper', 20, 'Computer Science'),
(25, 'Yvonne Nelson', 21, 'Mathematics'),
(26, 'Zachary Carter', 22, 'Engineering'),
(27, 'Amelia Wright', 20, 'Biology'),
(28, 'Benjamin Mitchell', 19, 'Physics'),
(29, 'Charlotte Perez', 22, 'Business'),
(30, 'Daniel Roberts', 21, 'Economics'),
(31, 'Eleanor Stewart', 20, 'Chemistry'),
(32, 'Frederick Reed', 23, 'Engineering'),
(33, 'Gabriella Howard', 21, 'Mathematics'),
(34, 'Harrison Bell', 20, 'Biology'),
(35, 'Ivy Collins', 22, 'Physics'),
(36, 'Jason Murphy', 19, 'Business'),
(37, 'Kylie Foster', 21, 'Computer Science'),
(38, 'Lucas Jenkins', 20, 'Economics'),
(39, 'Madeline Perry', 22, 'Chemistry'),
(40, 'Nathan Griffin', 19, 'Engineering');

INSERT INTO Courses (CourseID, CourseName, Instructor) VALUES
(1, 'Math 101', 'Dr. Adams'),
(2, 'Physics 101', 'Dr. Brown'),
(3, 'Biology 101', 'Dr. Carter'),
(4, 'Computer Science 101', 'Dr. Davis'),
(5, 'Business 101', 'Dr. Evans');

INSERT INTO Enrollments (StudentID, CourseID) VALUES
(1, 1), (2, 1), (7, 1), (11, 1), (20, 1), (25, 1), (33, 1),
(3, 2), (9, 2), (14, 2), (22, 2), (28, 2), (35, 2),
(5, 3), (13, 3), (21, 3), (27, 3), (34, 3),
(10, 4), (16, 4), (24, 4), (30, 4), (37, 4),
(6, 5), (15, 5), (23, 5), (29, 5), (36, 5);

DROP TABLE IF EXISTS Sales;

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    CustomerID INT,
    SaleDate DATE,
    SaleAmount DECIMAL(10, 2)
);

INSERT INTO Sales (SaleID, ProductID, CustomerID, SaleDate, SaleAmount) VALUES
(1, 1, 1, '2023-01-01', 150.00),
(2, 2, 2, '2023-01-02', 200.00),
(3, 3, 3, '2023-01-03', 250.00),
(4, 4, 4, '2023-01-04', 300.00),
(5, 5, 5, '2023-01-05', 350.00),
(6, 6, 6, '2023-01-06', 400.00),
(7, 7, 7, '2023-01-07', 450.00),
(8, 8, 8, '2023-01-08', 500.00),
(9, 9, 9, '2023-01-09', 550.00),
(10, 10, 10, '2023-01-10', 600.00),
(11, 1, 1, '2023-01-11', 150.00),
(12, 2, 2, '2023-01-12', 200.00),
(13, 3, 3, '2023-01-13', 250.00),
(14, 4, 4, '2023-01-14', 300.00),
(15, 5, 5, '2023-01-15', 350.00),
(16, 6, 6, '2023-01-16', 400.00),
(17, 7, 7, '2023-01-17', 450.00),
(18, 8, 8, '2023-01-18', 500.00),
(19, 9, 9, '2023-01-19', 550.00),
(20, 10, 10, '2023-01-20', 600.00),
(21, 1, 2, '2023-01-21', 150.00),
(22, 2, 3, '2023-01-22', 200.00),
(23, 3, 4, '2023-01-23', 250.00),
(24, 4, 5, '2023-01-24', 300.00),
(25, 5, 6, '2023-01-25', 350.00),
(26, 6, 7, '2023-01-26', 400.00),
(27, 7, 8, '2023-01-27', 450.00),
(28, 8, 9, '2023-01-28', 500.00),
(29, 9, 10, '2023-01-29', 550.00),
(30, 10, 1, '2023-01-30', 600.00),
(31, 1, 2, '2023-02-01', 150.00),
(32, 2, 3, '2023-02-02', 200.00),
(33, 3, 4, '2023-02-03', 250.00),
(34, 4, 5, '2023-02-04', 300.00),
(35, 5, 6, '2023-02-05', 350.00),
(36, 6, 7, '2023-02-06', 400.00),
(37, 7, 8, '2023-02-07', 450.00),
(38, 8, 9, '2023-02-08', 500.00),
(39, 9, 10, '2023-02-09', 550.00),
(40, 10, 1, '2023-02-10', 600.00);
/*Using the Employees and Departments tables, write a query to return the names and salaries of employees whose salary is greater than 50000,
along with their department names.
🔁 Expected Columns: EmployeeName, Salary, DepartmentName*/
SELECT
	E.Name,
	E.Salary,
	D.DepartmentName
FROM Employees E
JOIN Departments D
ON E.DepartmentID=D.DepartmentID
WHERE E.Salary>50000;
/*Using the Customers and Orders tables, write a query to display customer names and order dates for orders placed in the year 2023.
🔁 Expected Columns: FirstName, LastName, OrderDate*/
SELECT 
	C.FirstName,
	C.LastName,
	O.OrderDate
FROM Customers C
JOIN Orders O
ON C.CustomerID=O.CustomerID
WHERE YEAR(O.OrderDate)=2023;
/*Using the Employees and Departments tables, write a query to show all employees along with their department names.
Include employees who do not belong to any department.
🔁 Expected Columns: EmployeeName, DepartmentName*/
SELECT
	E.Name,
	D.DepartmentName
FROM Employees E
FULL JOIN Departments D
ON E.DepartmentID=D.DepartmentID;
/*Using the Products and Suppliers tables, write a query to list all suppliers and the products they supply.
Show suppliers even if they don’t supply any product.
🔁 Expected Columns: SupplierName, ProductName*/
SELECT
	S.SupplierName,
	P.ProductName
FROM Products P
FULL JOIN Suppliers S
ON P.SupplierID=S.SupplierID;
/*Using the Orders and Payments tables, write a query to return all orders and their corresponding payments. 
Include orders without payments and payments not linked to any order.
🔁 Expected Columns: OrderID, OrderDate, PaymentDate, Amount*/
SELECT
	ISNULL(O.OrderID, P.OrderID) AS OrderID,
	O.OrderDate,
	P.PaymentDate,
	P.Amount
FROM Orders O
FULL JOIN Payments P
ON O.OrderID=P.OrderID;
/*Using the Employees table, write a query to show each employee's name along with the name of their manager.
🔁 Expected Columns: EmployeeName, ManagerName*/
SELECT
	E.Name EN,
	M.Name MN
FROM Employees E
JOIN Employees M
ON E.ManagerID=M.EmployeeID;
/*Using the Students, Courses, and Enrollments tables, write a query to list the names of students who are enrolled in the course named 'Math 101'.
🔁 Expected Columns: StudentName, CourseName*/
SELECT
	S.Name,
	C.CourseName
FROM Enrollments E
JOIN Students S
ON E.StudentID=S.StudentID
JOIN Courses C
ON E.CourseID=C.CourseID
WHERE C.CourseName='Math 101'
/*Using the Customers and Orders tables, write a query to find customers who have placed an order with more than 3 items. Return their name and the quantity they ordered.
🔁 Expected Columns: FirstName, LastName, Quantity*/
SELECT
	C.FirstName,
	C.LastName,
	O.Quantity
FROM Customers C
JOIN Orders O
ON C.CustomerID=O.CustomerID
WHERE O.Quantity>3;
/*Using the Employees and Departments tables, write a query to list employees working in the 'Human Resources' department.
🔁 Expected Columns: EmployeeName, DepartmentName*/
SELECT
	E.Name,
	D.DepartmentName
FROM Employees E
JOIN Departments D
ON E.DepartmentID=D.DepartmentID
WHERE D.DepartmentName='Human Resources';
/*Using the Employees and Departments tables, write a query to return department names that have more than 5 employees.
🔁 Expected Columns: DepartmentName, EmployeeCount*/
SELECT
	D.DepartmentName,
	COUNT(E.EmployeeID) MORETHAN5
FROM Employees E
JOIN Departments D
ON E.DepartmentID=D.DepartmentID
GROUP BY D.DepartmentName
HAVING COUNT(E.EmployeeID)>5;
/*Using the Products and Sales tables, write a query to find products that have never been sold.
🔁 Expected Columns: ProductID, ProductName*/
SELECT
	P.ProductID,
	P.ProductName
FROM Products P
LEFT JOIN Sales S
ON P.ProductID = S.ProductID
WHERE S.SaleID IS NULL;
/*Using the Customers and Orders tables, write a query to return customer names who have placed at least one order.
🔁 Expected Columns: FirstName, LastName, TotalOrders*/
SELECT
	C.FirstName,
	C.LastName,
	O.Quantity
FROM Customers C
INNER JOIN Orders O
ON C.CustomerID=O.CustomerID
WHERE O.Quantity>=1;
/*Using the Employees and Departments tables, write a query to show only those records where both employee and department exist (no NULLs).
🔁 Expected Columns: EmployeeName, DepartmentName*/
SELECT
	E.Name,
	D.DepartmentName
FROM Employees E
INNER JOIN Departments D
ON E.DepartmentID=D.DepartmentID;
/*Using the Employees table, write a query to find pairs of employees who report to the same manager.
🔁 Expected Columns: Employee1, Employee2, ManagerID*/
SELECT 
	E1.Name AS Employee1, 
	E2.Name AS Employee2, 
	E1.ManagerID
FROM Employees E1
JOIN Employees E2
ON E1.ManagerID = E2.ManagerID 
AND E1.EmployeeID < E2.EmployeeID
ORDER BY Employee1, Employee2;
/*Using the Orders and Customers tables, write a query to list all orders placed in 2022 along with the customer name.
🔁 Expected Columns: OrderID, OrderDate, FirstName, LastName*/
SELECT
	O.OrderID,
	O.OrderDate,
	C.FirstName,
	C.LastName
FROM Orders O
JOIN Customers C
ON O.CustomerID=C.CustomerID
WHERE YEAR(O.OrderDate)=2022;
/*Using the Employees and Departments tables, write a query to return employees from the 'Sales' department whose salary is above 60000.
🔁 Expected Columns: EmployeeName, Salary, DepartmentName*/
SELECT 
	E.Name,
	E.Salary,
	D.DepartmentName
FROM Employees E
JOIN Departments D
ON E.DepartmentID=D.DepartmentID
WHERE D.DepartmentName='Sales'
AND E.Salary>60000;
/*Using the Orders and Payments tables, write a query to return only those orders that have a corresponding payment.
🔁 Expected Columns: OrderID, OrderDate, PaymentDate, Amount*/
SELECT 
	O.OrderID,
	O.OrderDate,
	P.PaymentDate,
	P.Amount
FROM Orders O
JOIN Payments P
ON O.OrderID=P.OrderID;
/*Using the Products and Orders tables, write a query to find products that were never ordered.
🔁 Expected Columns: ProductID, ProductName*/
SELECT
	P.ProductID,
	P.ProductName
FROM Products P
LEFT JOIN Orders O
ON P.ProductID=O.ProductID
WHERE O.OrderID IS NULL;
/*Using the Employees table, write a query to find employees whose salary is greater than the average salary in their own departments.
🔁 Expected Columns: EmployeeName, Salary*/
SELECT 
	E.Name AS EmployeeName,
	E.Salary
FROM Employees E
WHERE E.Salary > (
	SELECT AVG(Salary)
	FROM Employees
	WHERE DepartmentID = E.DepartmentID
);
/*Using the Orders and Payments tables, write a query to list all orders placed before 2020 that have no corresponding payment.
🔁 Expected Columns: OrderID, OrderDate*/
SELECT *
FROM Orders O
LEFT JOIN Payments P
ON O.OrderID=P.OrderID
WHERE YEAR(O.OrderDate)<2020
AND P.PaymentID IS NULL;
/*Using the Products and Categories tables, write a query to return products that do not have a matching category.
🔁 Expected Columns: ProductID, ProductName*/
SELECT 
	P.ProductID,
	P.ProductName
FROM Products P
LEFT JOIN Categories C
ON P.Category = C.CategoryID
WHERE C.CategoryID IS NULL;
/*Using the Employees table, write a query to find employees who report to the same manager and earn more than 60000.
🔁 Expected Columns: Employee1, Employee2, ManagerID, Salary*/
SELECT
	E1.Name E1NAME,
	E2.Name E2NAME,
	E1.ManagerID,
	E1.Salary
FROM Employees E1
JOIN Employees E2
ON E1.ManagerID=E2.ManagerID
AND E1.EmployeeID<E2.EmployeeID
AND E1.Salary>60000
AND E2.Salary>60000;
/*Using the Employees and Departments tables, write a query to return employees who work in departments which name starts with the letter 'M'.
🔁 Expected Columns: EmployeeName, DepartmentName*/
SELECT
	E.Name,
	D.DepartmentName
FROM Employees E
JOIN Departments D
ON E.DepartmentID=D.DepartmentID
WHERE D.DepartmentName LIKE 'M%';
/*Using the Products and Sales tables, write a query to list sales where the amount is greater than 500, including product names.
🔁 Expected Columns: SaleID, ProductName, SaleAmount*/
SELECT
	S.SaleID,
	P.ProductName,
	S.SaleAmount
FROM Products P
JOIN Sales S
ON P.ProductID=S.ProductID
WHERE S.SaleAmount>500;
/*Using the Students, Courses, and Enrollments tables, write a query to find students who have not enrolled in the course 'Math 101'.
🔁 Expected Columns: StudentID, StudentName*/
SELECT 
	S.StudentID,
	S.Name
FROM Students S
WHERE S.StudentID NOT IN (
	SELECT E.StudentID
	FROM Enrollments E
	JOIN Courses C ON E.CourseID = C.CourseID
	WHERE C.CourseName = 'Math 101'
);
/*Using the Orders and Payments tables, write a query to return orders that are missing payment details.
🔁 Expected Columns: OrderID, OrderDate, PaymentID*/
SELECT 
	O.OrderID,
	O.OrderDate,
	P.PaymentID
FROM Orders O
LEFT JOIN Payments P
ON O.OrderID=P.OrderID
WHERE P.PaymentID IS NULL;
/*Using the Products and Categories tables, write a query to list products that belong to either the 'Electronics' or 'Furniture' category.
🔁 Expected Columns: ProductID, ProductName, CategoryName*/
SELECT
	P.ProductID,
	P.ProductName,
	C.CategoryName
FROM Products P
INNER JOIN Categories C
ON P.Category=C.CategoryID
WHERE C.CategoryName='Electronics'
OR C.CategoryName='Furniture';

























