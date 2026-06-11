-- Step 1: Create Database
CREATE DATABASE HR_Analytics;


USE HR_Analytics;


-- Step 2: Create Table
CREATE TABLE HR_Employees (
    Age                      INT,
    Attrition                VARCHAR(5),
    BusinessTravel           VARCHAR(30),
    DailyRate                INT,
    Department               VARCHAR(50),
    DistanceFromHome         INT,
    Education                INT,
    EducationField           VARCHAR(50),
    EmployeeCount            INT,
    EmployeeNumber           INT PRIMARY KEY,
    EnvironmentSatisfaction  INT,
    Gender                   VARCHAR(10),
    HourlyRate               INT,
    JobInvolvement           INT,
    JobLevel                 INT,
    JobRole                  VARCHAR(50),
    JobSatisfaction          INT,
    MaritalStatus            VARCHAR(15),
    MonthlyIncome            INT,
    MonthlyRate              INT,
    NumCompaniesWorked       INT,
    Over18                   VARCHAR(3),
    OverTime                 VARCHAR(5),
    PercentSalaryHike        INT,
    PerformanceRating        INT,
    RelationshipSatisfaction INT,
    StandardHours            INT,
    StockOptionLevel         INT,
    TotalWorkingYears        INT,
    TrainingTimesLastYear    INT,
    WorkLifeBalance          INT,
    YearsAtCompany           INT,
    YearsInCurrentRole       INT,
    YearsSinceLastPromotion  INT,
    YearsWithCurrManager     INT
);


-- Step 3: Import CSV
BULK INSERT HR_Employees
FROM 'C:\HR_Project\WA_Fn-UseC_-HR-Employee-Attrition.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);


-- Step 4: Verify
SELECT COUNT(*) AS TotalRows FROM HR_Employees;
SELECT TOP 5 * FROM HR_Employees;

--Basic headcount by department
SELECT 
    Department,
    COUNT(*) AS TotalEmployees
FROM HR_Employees
GROUP BY Department
ORDER BY TotalEmployees DESC;


--Attrition count and rate by department
SELECT 
    Department,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionCount,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) 
          / COUNT(*) * 100, 2) AS AttritionRate
FROM HR_Employees
GROUP BY Department
ORDER BY AttritionRate DESC;


--Average salary by job role
SELECT 
    JobRole,
    COUNT(*) AS Employees,
    AVG(MonthlyIncome) AS AvgSalary,
    MIN(MonthlyIncome) AS MinSalary,
    MAX(MonthlyIncome) AS MaxSalary
FROM HR_Employees
GROUP BY JobRole
ORDER BY AvgSalary DESC;


--Gender split across the company
SELECT 
    Gender,
    COUNT(*) AS Count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM HR_Employees), 2) AS Percentage
FROM HR_Employees
GROUP BY Gender;

--RANK employees by salary within each department
SELECT 
    EmployeeNumber,
    Department,
    JobRole,
    MonthlyIncome,
    RANK() OVER (
        PARTITION BY Department 
        ORDER BY MonthlyIncome DESC
    ) AS SalaryRankInDept
FROM HR_Employees
ORDER BY Department, SalaryRankInDept;


--Compare each employee's salary vs their dept average
SELECT 
    EmployeeNumber,
    Department,
    MonthlyIncome,
    AVG(MonthlyIncome) OVER (PARTITION BY Department) AS DeptAvgSalary,
    MonthlyIncome - AVG(MonthlyIncome) OVER (PARTITION BY Department) AS DiffFromAvg
FROM HR_Employees
ORDER BY Department, DiffFromAvg DESC;


--Attrition risk score per employee using CASE WHEN
SELECT 
    EmployeeNumber,
    JobRole,
    Department,
    JobSatisfaction,
    WorkLifeBalance,
    YearsWithCurrManager,
    CASE 
        WHEN JobSatisfaction = 1 AND WorkLifeBalance = 1 THEN 'High Risk'
        WHEN JobSatisfaction <= 2 OR WorkLifeBalance <= 2 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS AttritionRisk
FROM HR_Employees
ORDER BY AttritionRisk;

USE HR_Analytics;
SELECT TOP 5 * FROM HR_Employees;
SELECT COUNT(*) FROM HR_Employees;

