-- Normalize StudentClasses

-- Create Common Table Expression with Row Number over Partition to determine duplicate records in table - dupes will be determined by any records with a rn > 1
WITH CTE AS 
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY FirstName, LastName, ClassCompleted, TrainingDate ORDER BY ID) as rn 
FROM dbo.StudentClasses
)

-- Delete duplicates 
DELETE FROM CTE 
WHERE rn > 1

-- b. Get all students who took Algebra 2 before 1/11/2019 with the following columns:  Full name, Training Date. 
-- Writing 2 queries here as I believe the actual ask would be to get all students who took Algebra 2 before 1/11/2021. Will confirm at interview. 

SELECT 
    FirstName + ' ' + LastName as FullName,
    CONVERT(VARCHAR, TrainingDate, 101) as TrainingDate
FROM StudentClasses sc
WHERE sc.TrainingDate < '1/11/2019'
ORDER BY FullName, TrainingDate

SELECT 
    FirstName + ' ' + LastName as FullName,
    CONVERT(VARCHAR, TrainingDate, 101) as TrainingDate
FROM StudentClasses sc
WHERE sc.TrainingDate < '1/11/2021'
ORDER BY FullName, TrainingDate
