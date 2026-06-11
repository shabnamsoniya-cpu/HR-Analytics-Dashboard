USE HR_Analytics;
GO

CREATE VIEW vw_AttritionByDept AS
SELECT 
    Department,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionCount,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) 
          / COUNT(*) * 100, 2) AS AttritionRate
FROM HR_Employees
GROUP BY Department;
GO

CREATE VIEW vw_SalaryByRole AS
SELECT 
    JobRole, Department,
    COUNT(*) AS Employees,
    AVG(MonthlyIncome) AS AvgSalary,
    MIN(MonthlyIncome) AS MinSalary,
    MAX(MonthlyIncome) AS MaxSalary
FROM HR_Employees
GROUP BY JobRole, Department;
GO

CREATE VIEW vw_AttritionRisk AS
SELECT 
    EmployeeNumber, JobRole, Department, Age, Gender,
    MonthlyIncome, JobSatisfaction, WorkLifeBalance,
    YearsAtCompany, Attrition,
    CASE 
        WHEN JobSatisfaction = 1 AND WorkLifeBalance = 1 THEN 'High Risk'
        WHEN JobSatisfaction <= 2 OR WorkLifeBalance <= 2 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS AttritionRisk
FROM HR_Employees;
GO

CREATE VIEW vw_SalaryRank AS
SELECT 
    EmployeeNumber, Department, JobRole, MonthlyIncome,
    RANK() OVER (PARTITION BY Department ORDER BY MonthlyIncome DESC) AS SalaryRankInDept,
    AVG(MonthlyIncome) OVER (PARTITION BY Department) AS DeptAvgSalary
FROM HR_Employees;
GO

SELECT name AS ViewName FROM sys.views WHERE name LIKE 'vw_%';