show databases;

use project ;

show tables;
--  all tables --

select * from geography;
select * from gender;
select * from exitcustomer;
select * from customerinfo;
select * from bank_churn;
select * from activecustomer;

-- question no-2 Identify the top 5 customers with the highest Estimated Salary in the last quarter of the year?-- 
select EstimatedSalary from customerinfo order by EstimatedSalary desc limit 5; 

-- question no-3 Calculate the average number of products used by customers who have a credit card. (SQL)-- 
select avg(NumOfProducts) from Bank_churn where HasCrCard = 1;

-- question no - 5 Compare the average credit score of customers who have exited and those who remain. (SQL)-- 
SELECT
    AVG(CASE WHEN Exited = 1 THEN CreditScore END) AS avg_credit_score_exited,
    AVG(CASE WHEN Exited = 0 THEN CreditScore END) AS avg_credit_score_remained
FROM Bank_Churn;

-- question no-6 Which gender has a higher average estimated salary, and how does it relate to the number of active accounts? (SQL)-- 
SELECT
    g.GenderCategory AS Gender,
    AVG(c.EstimatedSalary) AS AverageSalary,
    COUNT(CASE WHEN bc.IsActiveMember = 1 THEN 1 END) AS ActiveAccounts
FROM
    CustomerInfo c
JOIN
    Gender g ON c.GenderID = g.GenderID
LEFT JOIN
    Bank_churn bc ON c.CustomerID = bc.CustomerID
GROUP BY
    g.GenderCategory;




-- question no-7 Segment the customers based on their credit score and identify the segment with the highest exit rate. (SQL)--
SELECT
    CreditScore,AVG(CAST(IsActiveMember AS DECIMAL)) AS ExitRate
FROM Bank_Churn
GROUP BY CreditScore
ORDER BY ExitRate DESC;

-- question no-8 Find out which geographic region has the highest number of active customers with a tenure greater than 5 years. (SQL)-- 
SELECT
    c.GeographyID,
    COUNT(*) AS NumActiveCustomers
FROM Bank_churn AS b
LEFT JOIN customerinfo AS c ON b.customerId = c.customerId
WHERE b.tenure > 5 AND b.IsActiveMember = 1
GROUP BY c.GeographyID
ORDER BY NumActiveCustomers DESC
LIMIT 1;

-- question no-10 For customers who have exited, what is the most common number of products they have used?-- 
SELECT
    NumOfProducts,
    COUNT(*) AS Frequency
FROM Bank_churn
WHERE Exited = 1 -- Selecting customers who have exited
GROUP BY NumOfProducts
ORDER BY Frequency DESC;

-- question no- 15 Using SQL, write a query to find out the gender-wise average income of males and females -- 
-- in each geography id. Also, rank the gender according to the average value. (SQL)-- 
SELECT 
    c.GeographyID,
    g.GenderCategory AS Gender,
    AVG(c.EstimatedSalary) AS AverageIncome,
    RANK() OVER(PARTITION BY c.GeographyID ORDER BY AVG(c.EstimatedSalary) DESC) AS GenderRank
FROM 
    Customerinfo c
JOIN 
    Gender g ON c.GenderID = g.GenderID
GROUP BY 
    c.GeographyID, g.GenderCategory
ORDER BY 
    c.GeographyID, GenderRank;

-- 16. Using SQL, write a query to find out the average tenure of the people who have exited
--  in each age bracket (18-30, 30-50, 50+).-- 
SELECT 
    CASE 
        WHEN age BETWEEN 18 AND 30 THEN '18-30'
        WHEN age BETWEEN 31 AND 50 THEN '31-50'
        ELSE '50+'
    END AS AgeBracket,
    AVG(Tenure) AS AverageTenure
FROM 
    Customerinfo c
JOIN 
    Bank_Churn b ON c.CustomerID = b.CustomerID
WHERE 
    b.Exited = 1 
GROUP BY 
    CASE 
        WHEN age BETWEEN 18 AND 30 THEN '18-30'
        WHEN age BETWEEN 31 AND 50 THEN '31-50'
        ELSE '50+'
    END;
    
    -- question no - 20 20. According to the age buckets find the number of customers who have a credit card. -- 
    -- also retrieve those buckets that have a lesser than average number of credit cards per bucket-- 
    
SELECT 
CASE 
        WHEN c.Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN c.Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN c.Age BETWEEN 36 AND 45 THEN '36-45'
        ELSE '46+'
    END AS age_bucket,
    COUNT(DISTINCT bc.CustomerID) AS num_customers_with_credit_card
FROM Bank_churn bc
JOIN CustomerInfo c ON bc.CustomerID = c.CustomerID
WHERE bc.CreditScore IS NOT NULL
GROUP BY age_bucket;

-- Question no- 23. Without using “Join”, can we get the “ExitCategory” from the ExitCustomers 
-- table to the Bank_Churn table? If yes do this using SQL.-- 
SELECT 
    bc.*,
    (SELECT ec.ExitCategory 
     FROM exitcustomer ec 
     WHERE ec.ExitID = bc.Exited
    ) AS ExitCategory
FROM 
    Bank_Churn bc;

---- Question no-25 Write the query to get the customer IDs, their last name, -- 
-- and whether they are active or not for the customers whose surname ends with “on”.-- 
SELECT 
    c.CustomerID,
    c.Surname,
    b.IsActiveMember
FROM 
    CustomerInfo as c
LEFT JOIN Bank_Churn as b
ON c.CustomerID = b.CustomerID
WHERE 
    Surname LIKE '%on';

-- Subjective Solution start here-- 

-- Question no -9 Utilize SQL queries to segment customers based on demographics and account details.-- 
SELECT 
    CI.CustomerId,
    CI.Age,
    CI.EstimatedSalary,
    G.GeographyLocation AS Geography,
    BC.Balance,
    BC.CreditScore,
    BC.IsActiveMember,
    BC.Tenure
FROM 
    CustomerInfo CI
JOIN 
    Bank_Churn BC 
    ON CI.CustomerId = BC.CustomerId
JOIN 
    Geography G 
    ON CI.GeographyID = G.GeographyID
WHERE 
    CI.Age >= 30 AND CI.Age <= 40
    AND BC.CreditScore >650
    AND BC.Balance > 10000;







