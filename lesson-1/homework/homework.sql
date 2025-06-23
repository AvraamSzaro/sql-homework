create Database SchoolDB
use SchoolDB
create table Students (StudentID int primary key, name varchar(50), age int);

/*

SQL Server: A relational database management system by Microsoft.

SSMS (SQL Server Management Studio): A graphical tool to manage SQL Server databases and execute queries.

SQL (Structured Query Language): A language used to query and manipulate databases.


*/

--DQL (Data Query Language): Retrieves data.
SELECT * FROM Students;

--DML (Data Manipulation Language): Modifies data.
INSERT INTO Students VALUES (1, 'Enrique', 49);
UPDATE Students SET Age = 50 WHERE StudentID = 1;
DELETE FROM Students WHERE StudentID = 1;

--DDL (Data Definition Language): Defines database objects.
CREATE TABLE Courses (CourseID INT, Title VARCHAR(50));
ALTER TABLE Students ADD Gender VARCHAR(10);
DROP TABLE Courses;

--DCL (Data Control Language): Controls access.
GRANT SELECT ON Students TO user1;
REVOKE SELECT ON Students FROM user1;

--TCL (Transaction Control Language): Manages transactions.
BEGIN TRANSACTION;
UPDATE Students SET Age = 22 WHERE StudentID = 2;
COMMIT;

INSERT INTO Students (StudentID, name, age)
VALUES (1, 'Trump', 79),
       (2, 'Putin', 71),
       (3, 'Grande', 31);

/*
delete Students
DELETE FROM Students;
wipe everything
TRUNCATE TABLE Students;
*/