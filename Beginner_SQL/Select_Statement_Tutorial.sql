-- WHERE CLAUSE, GROUP BY, HAVING vs WHERE, LIMIT, ALIASING, JOINS

SELECT * FROM parks_and_recreation.employee_demographics;
SELECT * FROM parks_and_recreation.employee_salary;
SELECT * FROM parks_and_recreation.parks_departments;


SELECT first_name,
last_name, 
birth_date,
age,
(age + 10) * 10 + 10
FROM parks_and_recreation.employee_demographics;

SELECT DISTINCT first_name, gender FROM parks_and_recreation.employee_demographics;


-- WHERE Clause

SELECT * FROM employee_salary WHERE first_name = 'leslie' ;
SELECT * FROM employee_salary WHERE salary <= 50000 ;
SELECT * FROM employee_demographics WHERE gender = 'female';
SELECT * FROM employee_demographics WHERE gender != 'female';
SELECT * FROM employee_demographics WHERE birth_date > '1985-01-01';


-- Locical Operators  (AND OR NOT)

SELECT * FROM employee_demographics WHERE gender = 'male' AND birth_date > '1985-01-01';
SELECT * FROM employee_demographics WHERE gender = 'male' or birth_date > '1985-01-01';
SELECT * FROM employee_demographics WHERE NOT gender = 'male' or birth_date > '1985-01-01';
SELECT * FROM employee_demographics WHERE (first_name = 'Leslie' AND age = 44) OR age > 55 ;


-- Like Statement (% and _)

SELECT * FROM employee_demographics WHERE first_name LIKE 'Jer%' ;
SELECT * FROM employee_demographics WHERE first_name LIKE '%er%' ;
SELECT * FROM employee_demographics WHERE first_name LIKE 'Jer%' ;
SELECT * FROM employee_demographics WHERE first_name LIKE 'A__' ;
SELECT * FROM employee_demographics WHERE first_name LIKE 'A___%' ;
SELECT * FROM employee_demographics WHERE birth_date LIKE '1989%' ;


-- GROUP BY
SELECT gender FROM employee_demographics GROUP BY gender ;
SELECT gender, AVG (age) FROM employee_demographics GROUP BY gender ;
SELECT occupation, salary FROM employee_salary GROUP BY occupation, salary ;
SELECT gender, AVG (age) FROM employee_demographics GROUP BY gender ;
SELECT gender, AVG (age), MAX(age), MIN(age) FROM employee_demographics GROUP BY gender ;
SELECT gender, AVG (age), MAX(age), MIN(age), COUNT(age) FROM employee_demographics GROUP BY gender ;


-- ORDER BY

SELECT * FROM employee_demographics ORDER BY first_name ;
SELECT * FROM employee_demographics ORDER BY first_name DESC ;
SELECT * FROM employee_demographics ORDER BY gender, age ;
SELECT * FROM employee_demographics ORDER BY age DESC, gender ;
SELECT * FROM employee_demographics ORDER BY 5, 4 ;


-- HAVING vs WHERE

SELECT gender, AVG(age) FROM employee_demographics GROUP BY gender HAVING AVG (age) > 40 ;
SELECT occupation, AVG(Salary) 
FROM employee_salary 
WHERE occupation LIKE '%manager%' 
GROUP BY occupation
HAVING avg(salary) > 75000 ;
 
 
-- Limit
 
SELECT * FROM employee_demographics LIMIT 3 ;
SELECT * FROM employee_demographics ORDER BY age LIMIT 3 ;
SELECT * FROM employee_demographics ORDER BY age DESC LIMIT 3 ;
SELECT * FROM employee_demographics ORDER BY age DESC LIMIT 2, 1 ;


-- Aliasing

SELECT gender, AVG(age) Avg_age FROM employee_demographics GROUP BY gender HAVING Avg_age > 40 ;


-- Joins

SELECT * FROM employee_demographics AS dem 
INNER JOIN employee_salary AS sal
ON dem.employee_id = sal. employee_id ;
SELECT * FROM employee_demographics AS dem
RIGHT JOIN employee_salary AS sal ON dem.employee_id = sal.employee_id ;


-- Self Join

SELECT emp1.employee_id AS emp_santa,
emp1.first_name AS first_name_santa,
emp1.last_name AS last_name_santa,
emp2.employee_id AS emp_name,
emp2.first_name AS first_name_emp,
emp2.last_name AS last_name_emp
FROM employee_salary emp1
JOIN employee_salary emp2
ON emp1.employee_id + 1 = emp2.employee_id ;


-- Joining Multiple tables together

SELECT *
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
INNER JOIN parks_departments pd
	ON sal.dept_id = pd.department_id ;
    
    
-- UNIONS

SELECT first_name , last_name
FROM employee_demographics 
UNION ALL 
SELECT first_name, last_name
FROM employee_salary ;

SELECT first_name , last_name, 'Old Man' AS LABEL 
FROM employee_demographics 
WHERE age > 40 AND gender = 'Male'
UNION
SELECT first_name, last_name, 'Old Lady' AS LABEL
FROM employee_demographics
WHERE age > 40 AND gender = 'Female'
UNION 
SELECT first_name, last_name, 'Higly Paid Employy' AS LABEL
FROM employee_salary
WHERE salary > 70000 ;


-- STRING Functions

SELECT first_name, LENGTH(first_name)
FROM employee_demographics
ORDER BY 2 ;

SELECT first_name, UPPER(first_name) AS Upper_Case_letters
FROM employee_demographics ;

SELECT RTRIM('           sky        ');

SELECT first_name, LEFT(first_name, 4) AS Four_letters
FROM employee_demographics ;

SELECT first_name, UPPER( LEFT(first_name, 4)) AS UPPER_FOUR_LETTERS
FROM employee_demographics ;

SELECT first_name, 
UPPER(LEFT(first_name, 4)) AS First_four,
RIGHT(first_name, 4) AS Last_four,
SUBSTRING(first_name,3,2) AS Middle_letters,
birth_date, 
SUBSTRING(birth_date,6,2) AS Birth_month
FROM employee_demographics ;

SELECT first_name, REPLACE(first_name, 'a','z')
FROM employee_demographics ;

SELECT LOCATE('X','Alexander');

SELECT first_name, LOCATE('an',first_name) AS Location_of_AN
FROM employee_demographics ;

SELECT first_name, last_name,
CONCAT(first_name ,' ',last_name) AS Full_name
FROM employee_demographics ;


-- CASE Statements

SELECT first_name, age,
CASE
	WHEN age <= 30 THEN 'Young'
    WHEN age BETWEEN 31 AND 50 THEN'Old'
    WHEN age >= 50 THEN "On Death's Door"
END AS Age_Category
FROM employee_demographics ;


-- Pay Increase and Bonus
-- < 50000 = 5%
-- > 50000 = 7%
-- Finance = 10% bonus

SELECT first_name, last_name, salary,
CASE
	WHEN salary <= 50000 THEN salary * 1.05
    when salary > 50000 THEN salary * 1.07
END AS New_Salary,
CASE
	WHEN dept_id = 6 THEN salary * 0.1
END AS Bonus
FROM employee_salary ;


-- Subqueries 

SELECT * 
FROM employee_demographics 
WHERE employee_id IN 
(SELECT employee_id
FROM employee_salary
WHERE dept_id = 1) ;

SELECT first_name, salary,
(SELECT AVG(salary)
FROM employee_salary) AS Avg_Salary
FROM employee_salary ;

SELECT AVG(Max_age)
FROM
(SELECT 
gender, 
AVG(age) AS Avg_age,
MAX(age) AS Max_age,
MIN(age) AS Min_age,
COUNT(age) AS Count
FROM employee_demographics
GROUP BY gender)
AS Agg_table ;


-- Window Functions

SELECT gender, AVG(salary) OVER(PARTITION BY gender)
FROM employee_demographics dem
JOIN  employee_salary sal ON dem.employee_id = sal.employee_id ;

SELECT dem.first_name, dem.last_name, gender,
SUM(salary) OVER(PARTITION BY gender) AS Sum_Salary
FROM employee_demographics dem
JOIN employee_salary sal ON dem.employee_id = sal.employee_id ;

SELECT dem.employee_id, dem.first_name, dem.last_name, gender, salary,
SUM(salary) OVER(PARTITION BY gender ORDER BY dem.employee_id) AS Rolling_Total
FROM employee_demographics dem
JOIN employee_salary sal ON dem.employee_id = sal.employee_id ;

SELECT dem.employee_id, 
dem.first_name, dem.last_name, gender, salary, 
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS Row_Num,
RANK() OVER (PARTITION BY gender ORDER BY salary DESC) AS Rank_Num,
DENSE_RANK() OVER (PARTITION BY gender ORDER BY salary DESC) AS Dense_Rank_Num
FROM employee_demographics dem
JOIN employee_salary sal ON dem.employee_id = sal.employee_id ;


-- CTE's 

WITH CTE_Example AS
(SELECT gender, AVG(salary) Avg_sal, MAX(salary) Max_sal, MIN(salary) Min_sal, COUNT(salary) Count_sal
FROM employee_demographics dem
JOIN employee_salary sal ON dem.employee_id = sal.employee_id 
GROUP BY gender)
SELECT AVG(Avg_sal)
FROM CTE_Example ;

WITH CTE_Example (Gender, AVG_Sal, Max_Sal, Min_Sal, Count) AS
(SELECT gender, AVG(salary), MAX(salary) , MIN(salary) , COUNT(salary) 
FROM employee_demographics dem
JOIN employee_salary sal ON dem.employee_id = sal.employee_id 
GROUP BY gender)
SELECT *
FROM CTE_Example ;

WITH CTE_Example AS
(SELECT employee_id, gender, birth_date
FROM employee_demographics
WHERE birth_date > '1985-01-01'),
CTE_Example2 AS
(SELECT employee_id, salary
FROM employee_salary
WHERE salary > 50000)
SELECT *
FROM CTE_Example 
JOIN CTE_Example2 ON CTE_Example.employee_id = CTE_Example2.employee_id ;


-- Temporary Tables

CREATE TEMPORARY TABLE Temp_Table
(First_name VARCHAR (50),
Last_name VARCHAR (50),
Favorite_movie VARCHAR (100)) ;

INSERT INTO Temp_Table
VALUES ('Alex', 'Freberg', 'Lord of the rings: The Two Towers') ;

SELECT * FROM Temp_table ;

CREATE TEMPORARY TABLE Salary_over_50k
SELECT *
FROM employee_salary
WHERE salary >= 50000 
ORDER BY salary ;

SELECT * FROM Salary_over_50k ;


-- Stored Procedures 

CREATE PROCEDURE Large_Salaries()
SELECT *
FROM employee_salary
WHERE salary >= 50000 ;

CALL Large_Salaries () ;

DELIMITER $$
CREATE PROCEDURE Large_Salaries2()
BEGIN
	SELECT *
	FROM employee_salary
	WHERE salary >= 50000 ;
	SELECT *
	FROM employee_salary
	WHERE salary >= 10000 ;
END $$
DELIMITER ;

CALL Large_Salaries2 () ;

DELIMITER $$
CREATE PROCEDURE Large_Salarie4(huggymuffin INT)
BEGIN
	SELECT salary
	FROM employee_salary 
    WHERE employee_id = huggymuffin ;
END $$
DELIMITER ;

CALL Large_Salarie4(1) ;


-- Trigers and Events

DELIMITER $$ 
CREATE TRIGGER employee_insert
	AFTER INSERT ON employee_salary
    FOR EACH ROW 
BEGIN
	INSERT INTO employee_demographics (employee_id, first_name, last_name)
    VALUES (NEW .employee_id, NEW.first_name, NEW.last_name) ;
END $$
DELIMITER ;			

INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES (13, 'Jean-Palphio','Saperstein','Exntertainment 720 CEO',1000000,NULL) ;


-- EVENTS

DELIMITER $$
CREATE EVENT delete_retirees
ON SCHEDULE EVERY 30 SECOND
DO 
BEGIN
	DELETE 
	FROM employee_demographics
	where age >= 60 ;
END $$
DELIMITER ;

SHOW VARIABLES LIKE 'event%' ;






