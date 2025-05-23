USE ITJUNCTION;

--Problem Statements :-
--Write a SQL which will explode the above data into single unit level records as shown below


CREATE TABLE Order_Table(
 ORDER_ID varchar(10),
 PRODUCT_ID varchar(10),
 QUANTITY int);

INSERT INTO Order_Table(ORDER_ID,PRODUCT_ID,QUANTITY)
VALUES('odr1','prd1',5),('odr2','prd2',1),('odr3','prd3',3);

SELECT * FROM ORDER_TABLE


--Problem Statement :-  Employee Table has four columns namely EmpID , EmpName, Salary and DeptID
--Write a SQL  to find all Employees who earn more than the average salary in their corresponding department.

CREATE Table Employee
(
EmpID INT,
EmpName Varchar(30),
Salary Float,
DeptID INT
)

INSERT INTO Employee VALUES(1001,'Mark',60000,2)
INSERT INTO Employee VALUES(1002,'Antony',40000,2)
INSERT INTO Employee VALUES(1003,'Andrew',15000,1)
INSERT INTO Employee VALUES(1004,'Peter',35000,1)
INSERT INTO Employee VALUES(1005,'John',55000,1)
INSERT INTO Employee VALUES(1006,'Albert',25000,3)
INSERT INTO Employee VALUES(1007,'Donald',35000,3)

SELECT * FROM EMPLOYEE

--STEP-1
SELECT 
DeptID , AVG(SALARY) AS AVG_SALARY
FROM EMPLOYEE
GROUP BY DeptID

--STEP-2
SELECT
A.EmpID, A.EmpName, A.Salary, A.DeptID,
B.AVG_SALARY
FROM EMPLOYEE AS A
LEFT JOIN
(SELECT 
DeptID , AVG(SALARY) AS AVG_SALARY
FROM EMPLOYEE
GROUP BY DeptID) AS B
ON A.DeptID = B.DeptID
WHERE A.Salary > B.AVG_SALARY;


--BY WINDOW FUNCTION

SELECT
EmpID, EmpName, Salary, AVG_SALARY
FROM
(SELECT EmpID, EmpName, Salary, DeptID,
AVG(SALARY) OVER(PARTITION BY DeptID) AS AVG_SALARY
FROM EMPLOYEE) AS A
WHERE SALARY > AVG_SALARY;

--Team Table has two columns namely ID and TeamName and it contains 4 TeamsName.
--Problem Statements :- Write a SQL which will fetch total schedule of matches between each Team vs opposite team

Create Table Team(
ID INT,
TeamName Varchar(50)
);

INSERT INTO Team VALUES(1,'India'),(2,'Australia'),(3,'England'),(4,'NewZealand');

SELECT * FROM TEAM;

--STEP-1
SELECT A.ID,A.TEAMNAME,B.ID,B.TEAMNAME
FROM TEAM AS A
INNER JOIN
TEAM AS B
ON A.ID < B.ID

--STEP-2
WITH CTE AS (
    SELECT A.ID AS ID1, A.TEAMNAME AS TEAM1,
           B.ID AS ID2, B.TEAMNAME AS TEAM2
    FROM TEAM AS A
    INNER JOIN TEAM AS B
        ON A.ID < B.ID
)
SELECT CONCAT(TEAM1, ' VS ', TEAM2) AS MATCHS
FROM CTE;


--Table Match_Result has three columns  namely Team_1, Team_2 and Result.
--Problem Statements :- Write SQL to display total number of matches played, 
--matches won, matches tied and matches lost for each team


Create Table Match_Result (
Team_1 Varchar(20),
Team_2 Varchar(20),
Result Varchar(20)
)

Insert into Match_Result Values('India', 'Australia','India');
Insert into Match_Result Values('India', 'England','England');
Insert into Match_Result Values('SouthAfrica', 'India','India');
Insert into Match_Result Values('Australia', 'England',NULL);
Insert into Match_Result Values('England', 'SouthAfrica','SouthAfrica');
Insert into Match_Result Values('Australia', 'India','Australia');

SELECT * FROM MATCH_RESULT;

with matches as 
(
SELECT team_1 as Team,Result from Match_Result
UNION ALL
SELECT team_2,result from Match_Result
)
SELECT 
	Team,
	COUNT(1)  matchs,
	SUM(case when Result = Team then 1 else 0 end)  wins,
	SUM(case when Result IS NULL then 1 else 0 end)  ties,
	SUM(case when Result != Team then 1 else 0 end)  loss
FROM matches
GROUP BY Team;


-- Transaction_Table has four columns  namely  AccountNumber, TransactionTime, 
-- TransactionID and Balance

--Problem Statements :- Write SQL to get the most recent / latest balance, 
--and TransactionID for each AccountNumber

Create Table Transaction_Table
(
AccountNumber int,
TransactionTime DateTime,
TransactionID int,
Balance int
)


Insert into Transaction_Table Values (550,'2020-05-12 05:29:44.120' ,1001,2000)
Insert into Transaction_Table Values (550,'2020-05-15 10:29:25.630' ,1002,8000)
Insert into Transaction_Table Values (460,'2020-03-15 11:29:23.620' ,1003,9000)
Insert into Transaction_Table Values (460,'2020-04-30 11:29:57.320' ,1004,7000)
Insert into Transaction_Table Values (460,'2020-04-30 12:32:44.233' ,1005,5000)
Insert into Transaction_Table Values (640,'2020-02-18 06:29:34.420' ,1006,5000)
Insert into Transaction_Table Values (640,'2020-02-18 06:29:37.120' ,1007,9000)

SELECT * FROM Transaction_Table;

--STEP-1
SELECT
AccountNumber,
MAX(TransactionTime) AS RECENT_TRANSACTION
FROM Transaction_Table
GROUP BY AccountNumber

--STEP-2
SELECT A.AccountNumber, A.RECENT_TRANSACTION, B.TransactionID, B.Balance
FROM
(SELECT
AccountNumber,
MAX(TransactionTime) AS RECENT_TRANSACTION
FROM Transaction_Table
GROUP BY AccountNumber) AS A
LEFT JOIN
Transaction_Table AS B
ON A.RECENT_TRANSACTION=B.TransactionTime;


--Input :- SalesTable has four columns  namely  ID, Product ,
--SalesYear and QuantitySold

--Problem Statements :- Write SQL to get the total Sales in year 1998,1999
--and 2000 for all the products as shown below.


create table salestbl (
id int identity (1,1), 
product varchar(20), 
salesyear int, 
QuantitySold int)

insert into salestbl (product, salesyear, QuantitySold)
values ('Laptop', 1998, 2500), ('Laptop', 1999, 3600),
('Laptop', 2000, 4200),
('Keyboard', 1998, 2300), ('Keyboard',1999, 3600), ('Keyboard', 2000, 5000),
('Mouse', 1998, 6000), ('Mouse', 1999, 3400), ('Mouse', 2000, 4600)

SELECT * FROM salestbl;

--STEP-1
SELECT
    ID,
    [PRODUCT],
    [1998],
    [1999],
    [2000]
FROM
    salestbl
PIVOT (
    SUM(QuantitySold) FOR SALESYEAR IN ([1998], [1999], [2000])
) AS A;

--STEP-2
WITH CTE AS (
    SELECT
        ID,
        [PRODUCT],
        [1998],
        [1999],
        [2000]
    FROM
        salestbl
    PIVOT (
        SUM(QuantitySold) FOR SALESYEAR IN ([1998], [1999], [2000])
    ) AS A
)
SELECT
    [PRODUCT],
    SUM([1998]) AS [Total_Sales_1998],
    SUM([1999]) AS [Total_Sales_1999],
    SUM([2000]) AS [Total_Sales_2000]
FROM CTE
GROUP BY [PRODUCT];

Create Table Inventory(
ProdName Varchar(20),
ProductCode Varchar(15),
Quantity int,
InventoryDate Date)

Insert Into Inventory values('Keyboard','K1001',20,'2020-03-01');
Insert Into Inventory values('Keyboard','K1001',30,'2020-03-02');
Insert Into Inventory values('Keyboard','K1001',10,'2020-03-03');
Insert Into Inventory values('Keyboard','K1001',40,'2020-03-04');
Insert Into Inventory values('Laptop','L1002',100,'2020-03-01');
Insert Into Inventory values('Laptop','L1002',60,'2020-03-02');
Insert Into Inventory values('Laptop','L1002',40,'2020-03-03');
Insert Into Inventory values('Monitor','M5005',30,'2020-03-01');
Insert Into Inventory values('Monitor','M5005',20,'2020-03-02');

SELECT * FROM Inventory;

SELECT
ProdName,ProductCode,Quantity,InventoryDate,
SUM(Quantity) OVER(PARTITION BY ProductCode ORDER BY Quantity) AS TOTAL_SUM
FROM Inventory;

--If i need Running total then we need to paas that measure column in order by
--based on which we need running total
--Here its Quantity, It can be Sales, Amount etc


--Printing All alphabets

--Anchor Query----------------
--This is the base case of the recursion.
--It provides the initial result set to start the recursion.
--It runs only once.

--Recursive Query-------------
--This part refers back to the CTE itself.
--It runs repeatedly on the results of the previous iteration.
--Each run adds more rows to the final result until no new rows are returned.

WITH Alphabet AS
(
SELECT CHAR(ASCII('A')) Letter 
UNION ALL
SELECT CHAR(ASCII(Letter)+1)
FROM Alphabet
WHERE Letter <> 'Z'
)
SELECT * FROM Alphabet

--Hope i will do more tommorow
