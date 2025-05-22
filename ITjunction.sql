CREATE DATABASE ITJUNCTION;

USE ITJUNCTION;

CREATE TABLE [dbo].[Transaction_Tbl](
 [CustID] [int] ,
 [TranID] [int] ,
 [TranAmt] [float] ,
 [TranDate] [date] 
) 

INSERT [dbo].[Transaction_Tbl] ([CustID], [TranID], [TranAmt], [TranDate]) VALUES (1001, 20001, 10000, CAST('2020-04-25' AS Date))
INSERT [dbo].[Transaction_Tbl] ([CustID], [TranID], [TranAmt], [TranDate]) VALUES (1001, 20002, 15000, CAST('2020-04-25' AS Date))
INSERT [dbo].[Transaction_Tbl] ([CustID], [TranID], [TranAmt], [TranDate]) VALUES (1001, 20003, 80000, CAST('2020-04-25' AS Date))
INSERT [dbo].[Transaction_Tbl] ([CustID], [TranID], [TranAmt], [TranDate]) VALUES (1001, 20004, 20000, CAST('2020-04-25' AS Date))
INSERT [dbo].[Transaction_Tbl] ([CustID], [TranID], [TranAmt], [TranDate]) VALUES (1002, 30001, 7000, CAST('2020-04-25' AS Date))
INSERT [dbo].[Transaction_Tbl] ([CustID], [TranID], [TranAmt], [TranDate]) VALUES (1002, 30002, 15000, CAST('2020-04-25' AS Date))
INSERT [dbo].[Transaction_Tbl] ([CustID], [TranID], [TranAmt], [TranDate]) VALUES (1002, 30003, 22000, CAST('2020-04-25' AS Date))

SELECT * FROM Transaction_Tbl;

--Problem Statement:-
--Transatcion_tbl Table has four columns CustID, TranID, TranAmt, and  TranDate. 
--User has to display all these fields along with maximum TranAmt for each CustID and 
--ratio of TranAmt and maximum TranAmt for each transaction.

--STEP-1
SELECT CustID,
MAX(TranAmt) AS MAX_TRANSACTION_AMOUNT
FROM Transaction_Tbl
GROUP BY CUSTID;

--STEP-2
SELECT A.*,
B.MAX_TRANSACTION_AMOUNT,
FORMAT((A.TranAmt/B.MAX_TRANSACTION_AMOUNT),'G2') AS RATIO
FROM
Transaction_Tbl AS A
LEFT JOIN
(SELECT CustID,
MAX(TranAmt) AS MAX_TRANSACTION_AMOUNT
FROM Transaction_Tbl
GROUP BY CUSTID) AS B
ON A.CustID = B.CustID;


CREATE TABLE Emp(
[Group]  varchar(20),
[Sequence]  int )

INSERT INTO Emp VALUES('A',1)
INSERT INTO Emp VALUES('A',2)
INSERT INTO Emp VALUES('A',3)
INSERT INTO Emp VALUES('A',5)
INSERT INTO Emp VALUES('A',6)
INSERT INTO Emp VALUES('A',8)
INSERT INTO Emp VALUES('A',9)
INSERT INTO Emp VALUES('B',11)
INSERT INTO Emp VALUES('C',1)
INSERT INTO Emp VALUES('C',2)
INSERT INTO Emp VALUES('C',3)

--Problem Statement : Write a SQL query to find the maximum and minimum values of continuous ‘Sequence’ in each ‘Group’

SELECT * FROM EMP;

--STEP-1

SELECT
[GROUP],[SEQUENCE],
ROW_NUMBER() OVER (PARTITION BY [GROUP] ORDER BY [SEQUENCE]) AS RANK
FROM EMP;

--STEP-2
SELECT
[GROUP],[SEQUENCE],
ROW_NUMBER() OVER(PARTITION BY [GROUP] ORDER BY [SEQUENCE]) AS RANK,
[SEQUENCE] - ROW_NUMBER() OVER(PARTITION BY [GROUP] ORDER BY [SEQUENCE]) AS SPLIT
FROM EMP;

--STEP-3
SELECT
[GROUP],
MAX([SEQUENCE]) AS MAX_SEQUENCE,
MIN([SEQUENCE]) AS MIN_SEQUENCE
FROM
(SELECT
[GROUP],[SEQUENCE],
ROW_NUMBER() OVER(PARTITION BY [GROUP] ORDER BY [SEQUENCE]) AS RANK,
[SEQUENCE] - ROW_NUMBER() OVER(PARTITION BY [GROUP] ORDER BY [SEQUENCE]) AS SPLIT
FROM EMP) AS A
GROUP BY [GROUP],SPLIT
ORDER BY [GROUP];

--What i need to remember for interview
--In cases when we need grouping not based on given columns , we need to create one column by our self
--And then we can group based on previous and created column.

CREATE TABLE Student(
[Student_Name]  varchar(30),
[Total_Marks]  int ,
[Year]  int)

INSERT INTO Student VALUES('Rahul',90,2010)
INSERT INTO Student VALUES('Sanjay',80,2010)
INSERT INTO Student VALUES('Mohan',70,2010)
INSERT INTO Student VALUES('Rahul',90,2011)
INSERT INTO Student VALUES('Sanjay',85,2011)
INSERT INTO Student VALUES('Mohan',65,2011)
INSERT INTO Student VALUES('Rahul',80,2012)
INSERT INTO Student VALUES('Sanjay',80,2012)
INSERT INTO Student VALUES('Mohan',90,2012)

SELECT * FROM Student;

--Problem Statement:-
--Student Table has three columns Student_Name, Total_Marks and Year.
--User has to write a SQL query to display Student_Name, Total_Marks, Year,
--Prev_Yr_Marks for those whose Total_Marks are greater than or equal to the previous year.

--STEP-1
SELECT
STUDENT_NAME, TOTAL_MARKS , [YEAR],
LAG([TOTAL_MARKS]) OVER(PARTITION BY STUDENT_NAME ORDER BY [YEAR]) AS PRVS_MARKS
FROM STUDENT;

--STEP-2
SELECT
STUDENT_NAME,[YEAR],TOTAL_MARKS,PRVS_MARKS
FROM
(SELECT
STUDENT_NAME, TOTAL_MARKS , [YEAR],
LAG([TOTAL_MARKS]) OVER(PARTITION BY STUDENT_NAME ORDER BY [YEAR]) AS PRVS_MARKS
FROM STUDENT) AS A
WHERE TOTAL_MARKS > PRVS_MARKS OR TOTAL_MARKS = PRVS_MARKS;


CREATE TABLE Emp_Details (
EMPID int,
Gender varchar,
EmailID varchar(30),
DeptID int)


INSERT INTO Emp_Details VALUES (1001,'M','YYYYY@gmaix.com',104)
INSERT INTO Emp_Details VALUES (1002,'M','ZZZ@gmaix.com',103)
INSERT INTO Emp_Details VALUES (1003,'F','AAAAA@gmaix.com',102)
INSERT INTO Emp_Details VALUES (1004,'F','PP@gmaix.com',104)
INSERT INTO Emp_Details VALUES (1005,'M','CCCC@yahu.com',101)
INSERT INTO Emp_Details VALUES (1006,'M','DDDDD@yahu.com',100)
INSERT INTO Emp_Details VALUES (1007,'F','E@yahu.com',102)
INSERT INTO Emp_Details VALUES (1008,'M','M@yahu.com',102)
INSERT INTO Emp_Details VALUES (1009,'F','SS@yahu.com',100)

SELECT * FROM EMP_DETAILS

--Problem Statement:-
--Emp_Details  Table has four columns EmpID, Gender, EmailID and DeptID. 
--User has to write a SQL query to derive another column called Email_List to display 
--all Emailid concatenated with semicolon associated with a each DEPT_ID  as shown below in output Table.

SELECT DEPTID,STRING_AGG(EMAILID,';') AS EMAIL_LIST 
FROM EMP_DETAILS
GROUP BY DEPTID

SELECT DEPTID,STRING_AGG(EMAILID,';') WITHIN GROUP (ORDER BY EMAILID) AS EMAIL_LIST 
FROM EMP_DETAILS
GROUP BY DEPTID

--STRING_AGG is a aggregate function , Helps us in concatinating strings

CREATE TABLE [Order_Tbl](
 [ORDER_DAY] date,
 [ORDER_ID] varchar(10) ,
 [PRODUCT_ID] varchar(10) ,
 [QUANTITY] int ,
 [PRICE] int 
) 

INSERT INTO [Order_Tbl]  VALUES ('2015-05-01','ODR1', 'PROD1', 5, 5)
INSERT INTO [Order_Tbl]  VALUES ('2015-05-01','ODR2', 'PROD2', 2, 10)
INSERT INTO [Order_Tbl]  VALUES ('2015-05-01','ODR3', 'PROD3', 10, 25)
INSERT INTO [Order_Tbl]  VALUES ('2015-05-01','ODR4', 'PROD1', 20, 5)
INSERT INTO [Order_Tbl]  VALUES ('2015-05-02','ODR5', 'PROD3', 5, 25)
INSERT INTO [Order_Tbl]  VALUES ('2015-05-02','ODR6', 'PROD4', 6, 20)
INSERT INTO [Order_Tbl]  VALUES ('2015-05-02','ODR7', 'PROD1', 2, 5)
INSERT INTO [Order_Tbl]  VALUES ('2015-05-02','ODR8', 'PROD5', 1, 50)
INSERT INTO [Order_Tbl]  VALUES ('2015-05-02','ODR9', 'PROD6', 2, 50)
INSERT INTO [Order_Tbl]  VALUES ('2015-05-02','ODR10','PROD2', 4, 10)

SELECT * FROM ORDER_TBL;

--Problem statement-
--(a) Write a SQL to get all the products that got sold on both the days and the number of times the product is sold.
--(b) (b) Write a SQL to get products that was ordered on 02-May-2015 but not on 01-May-2015


SELECT
PRODUCT_ID,
COUNT(PRODUCT_ID) AS [COUNT],
COUNT(DISTINCT ORDER_DAY) AS ORDER_DAY_COUNT
FROM ORDER_TBL
GROUP BY PRODUCT_ID
HAVING COUNT(DISTINCT ORDER_DAY) >1;


SELECT
PRODUCT_ID,
COUNT(PRODUCT_ID) AS [COUNT],
COUNT(DISTINCT ORDER_DAY) AS ORDER_DAY_COUNT
FROM ORDER_TBL
GROUP BY PRODUCT_ID
HAVING COUNT(PRODUCT_ID) =1


--Problem Statements :-
--(a) Write a SQL to get the highest sold Products (Quantity*Price) on both the days

SELECT
A.ORDER_DAY,B.PRODUCT_ID,A.SOLD_AMOUNT
FROM
((SELECT ORDER_DAY , MAX(QUANTITY*PRICE) AS SOLD_AMOUNT
FROM ORDER_TBL GROUP BY ORDER_DAY) AS A
INNER JOIN
(SELECT ORDER_DAY ,PRODUCT_ID ,QUANTITY*PRICE AS SOLD_AMOUNT
FROM ORDER_TBL) AS B
ON A.ORDER_DAY = B.ORDER_DAY AND A.SOLD_AMOUNT = B.SOLD_AMOUNT)


