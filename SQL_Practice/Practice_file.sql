CREATE DATABASE Practice ;
USE Practice ;

select * FROM students ;
select * from enrollments ;
select * from courses;

SELECT first_name, age FROM students ;
SELECT * FROM students WHERE age > 22 ;
SELECT * FROM students WHERE gender = 'M' AND age > 22 ;
SELECT * FROM students WHERE age < 21 OR gender = 'F' ;
SELECT * FROM students WHERE age BETWEEN 21 and 23 ;
SELECT * FROM students WHERE age IN (21, 23) ;
SELECT * FROM students WHERE first_name LIKE 'R%' ;
SELECT * FROM students WHERE first_name LIKE '%ee%' ;

SELECT gender, COUNT(*) FROM students GROUP BY gender ;
SELECT gender, COUNT(*) FROM students GROUP BY gender HAVING COUNT(*) > 4 ;
SELECT * FROM students ; 
SELECT * FROM students ORDER BY age DESC LIMIT 3 ;
SELECT first_name AS Name, age AS Student_age FROM students ;

SELECT s.first_name, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

SELECT s.first_name, c.course_name, e.marks
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id WHERE marks > 85;

SELECT c.course_name, AVG(e.marks) AS Avg_marks
FROM enrollments e 
JOIN courses c ON e.course_id = c.course_id
GROUP BY c.course_name ;

SELECT s.first_name, s.last_name, c.course_name, e.marks 
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id WHERE e.marks > ( SELECT AVG(marks) FROM enrollments);

SELECT 
    s.first_name, 
    e.marks,
    RANK() OVER (ORDER BY e.marks DESC) AS Student_Rank
FROM students s
JOIN enrollments e ON s.student_id = e.student_id;

SELECT s.first_name, c.course_name, RANK() OVER (ORDER BY e.marks DESC) AS Student_Rank 
FROM students s 
JOIN enrollments e ON s.student_id = e.student_id 
JOIN courses c ON e.course_id = c.course_id  
GROUP BY c.course_id ;

SELECT 
    s.first_name,
    c.course_name,
    e.marks,
    RANK() OVER (PARTITION BY c.course_name ORDER BY e.marks DESC) AS Student_Rank
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

SELECT s.first_name, c.course_name, e.marks, AVG(e.marks) OVER (PARTITION BY c.course_name) AS Avg_course_Marks
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id ;

SELECT 
    s.first_name,
    c.course_name
FROM students s
LEFT JOIN enrollments e 
    ON s.student_id = e.student_id
LEFT JOIN courses c 
    ON e.course_id = c.course_id;

SELECT 
    s.first_name AS Student_Name
FROM students s
LEFT JOIN enrollments e 
    ON s.student_id = e.student_id
WHERE e.student_id IS NULL;

SELECT 
    s.first_name AS student_name,
    c.course_name
FROM students s
INNER JOIN enrollments e 
    ON s.student_id = e.student_id
INNER JOIN courses c 
    ON e.course_id = c.course_id;
    
SELECT s.first_name AS student_name, c.course_name, e.marks 
FROM students s
INNER JOIN enrollments e 
    ON s.student_id = e.student_id
INNER JOIN courses c 
    ON e.course_id = c.course_id
WHERE e.marks > 80 ;

SELECT 
    c.course_name,
    AVG(e.marks) AS avg_marks
FROM students s
JOIN enrollments e 
    ON s.student_id = e.student_id
JOIN courses c 
    ON e.course_id = c.course_id
WHERE e.marks > 80
GROUP BY c.course_name;

SELECT 
    s.first_name AS student_name,
    c.course_name,
    e.marks,
    AVG(e.marks) OVER (PARTITION BY c.course_name) AS avg_marks
FROM students s
JOIN enrollments e 
    ON s.student_id = e.student_id
JOIN courses c 
    ON e.course_id = c.course_id
WHERE e.marks > 80;

SELECT 
    s.first_name AS student_name,
    c.course_name,
    e.marks,
    AVG(e.marks) OVER (PARTITION BY c.course_name) AS avg_marks,
    
    CASE 
        WHEN e.marks > AVG(e.marks) OVER (PARTITION BY c.course_name) 
            THEN 'Above Avg'
        ELSE 'Below Avg'
    END AS performance_label
FROM students s
JOIN enrollments e 
    ON s.student_id = e.student_id
JOIN courses c 
    ON e.course_id = c.course_id;
    
SELECT *
FROM (
    SELECT 
        s.first_name AS student_name,
        c.course_name,
        e.marks,
        AVG(e.marks) OVER (PARTITION BY c.course_name) AS avg_marks
    FROM students s
    JOIN enrollments e 
        ON s.student_id = e.student_id
    JOIN courses c 
        ON e.course_id = c.course_id
) t
WHERE t.marks > t.avg_marks;

WITH data AS (
    SELECT 
        s.first_name AS student_name,
        c.course_name,
        e.marks,
        AVG(e.marks) OVER (PARTITION BY c.course_name) AS avg_marks
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN courses c ON e.course_id = c.course_id
)
SELECT *
FROM data
WHERE marks > avg_marks;

SELECT 
    c.course_name AS Course_name,
    COUNT(e.student_id) AS Total_students,
    AVG(e.marks) AS Avg_marks,
    MAX(e.marks) AS Highest_marks,
    MIN(e.marks) AS Lowest_marks
FROM enrollments e
JOIN courses c 
    ON e.course_id = c.course_id
GROUP BY c.course_name;

SELECT 
    s.first_name AS student_name,
    COUNT(e.course_id) AS number_of_courses
FROM students s
JOIN enrollments e 
    ON s.student_id = e.student_id
GROUP BY s.first_name;

SELECT 
    s.first_name AS student_name,
    COUNT(e.course_id) AS number_of_courses
FROM students s
LEFT JOIN enrollments e 
    ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name;

SELECT first_name FROM students
UNION 
SELECT course_name FROM courses;

SELECT name
FROM (
    SELECT first_name AS name, 1 AS type FROM students
    UNION
    SELECT course_name AS name, 2 AS type FROM courses
) t
ORDER BY type, name;

SELECT first_name AS name FROM students
UNION ALL
SELECT course_name AS name FROM courses;

SELECT c.course_name, AVG(e.marks) AS avg_marks
FROM courses c
JOIN enrollments e ON e.course_id = c.course_id
GROUP BY c.course_name
HAVING AVG(e.marks) > 85;

SELECT c.course_name, COUNT(e.student_id) AS No_of_Students
FROM enrollments e
JOIN courses c ON e.course_id = c.course_id
GROUP BY c.course_name
HAVING COUNT(e.student_id) > 2;

SELECT s.first_name AS Student_Name, COUNT(e.course_id) AS No_of_Courses
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name ;

SELECT 
    s.first_name AS Student_Name,
    COALESCE(SUM(e.marks), 0) AS Total_Marks
FROM students s
LEFT JOIN enrollments e 
    ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name;

SELECT s.first_name AS Student_Name, COALESCE(SUM(e.marks), 0) AS Total_Marks,
    CASE
        WHEN COALESCE(SUM(e.marks), 0) >= 85 THEN 'Excellent'
        WHEN COALESCE(SUM(e.marks), 0) >= 70 THEN 'Good'
        ELSE 'Needs Improvement'
    END AS Result
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name;

SELECT 
	s.first_name AS Student_Name, 
    c.course_name AS Enrolled_Course,
    e.marks AS Marks,
    CASE
		WHEN e.marks >= 90 THEN 'Top Performer'
        WHEN e.marks BETWEEN 75 AND 89 THEN 'Avg Performer'
        ELSE 'Low Performer'
	END AS Performance_Level
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

SELECT c.course_name AS Course_Name, AVG(marks) AS Avg_Marks,
	CASE
		WHEN AVG(marks) >= 85 THEN 'Easy'
        WHEN AVG(marks) BETWEEN 75 AND 84 THEN 'Moderate'
		ELSE 'Hard'
	END AS Course_Difficulty
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id 
GROUP BY course_name;

SELECT 
    s.first_name AS Student_Name,
    c.course_name,
    e.marks,
    AVG(e.marks) OVER (PARTITION BY c.course_id) AS Course_Avg,
    CASE
        WHEN e.marks > AVG(e.marks) OVER (PARTITION BY c.course_id) THEN 'Best Student'
        WHEN e.marks = AVG(e.marks) OVER (PARTITION BY c.course_id) THEN 'Average Student'
        ELSE 'Needs Improvement'
    END AS Performance
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

SELECT CONCAT(UPPER(first_name), ' ', UPPER(last_name)) AS Full_Name
FROM students;

SELECT first_name, SUBSTRING(first_name, 1, 2) AS Short_Name
FROM students ;

SELECT first_name AS Student_Name, LENGTH(first_name) AS Name_Size
FROM students 
WHERE LENGTH(first_name) > 4;

SELECT c.course_name, COUNT(s.student_id) AS Total_Students
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON c.course_id =  e.course_id 
GROUP BY course_name 
HAVING COUNT(s.student_id) >= 2;

SELECT s.first_name, COUNT(c.course_id) AS No_of_Courses
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN courses c ON c.course_id = e.course_id 
GROUP BY s.student_id, s.first_name;

SELECT s.first_name, COUNT(c.course_id) AS No_of_Courses,
	CASE
		WHEN COUNT(c.course_id) = 0 THEN 'No Courses'
        WHEN COUNT(c.course_id) >= 2 THEN 'Active Learner'
        WHEN COUNT(c.course_id) >=1 THEN 'Beginner'
	END AS Label
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN courses c ON c.course_id = e.course_id 
GROUP BY s.student_id, s.first_name;

SELECT c.course_name, COUNT(e.student_id) AS No_of_Students,
       CASE
           WHEN COUNT(e.student_id) >= 3 THEN 'Popular'
           WHEN COUNT(e.student_id) >= 2 THEN 'Average'
           ELSE 'Low'
       END AS Label
FROM enrollments e
JOIN courses c ON c.course_id = e.course_id
GROUP BY c.course_name;

SELECT 
    s.first_name AS Student_Name,
    c.course_name,
    e.marks,
    CASE
        WHEN e.marks >= 90 THEN 'Excellent'
        WHEN e.marks >= 80 AND e.marks < 90 THEN 'Good'
        ELSE 'Needs Improvement'
    END AS Label
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
INNER JOIN courses c ON e.course_id = c.course_id;

SELECT 
    Full_Name,
    c.course_name,
    t.marks,
    CASE
        WHEN LENGTH(Full_Name) > 10 THEN 'Long Name'
        ELSE 'Short Name'
    END AS Label
FROM (
    SELECT 
        CONCAT(s.first_name, ' ', s.last_name) AS Full_Name,
        e.marks,
        e.course_id
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
) t
JOIN courses c ON t.course_id = c.course_id;

SELECT 
	CONCAT(s.first_name, ' ', s.last_name) AS Full_Name,
    c.course_name,
    e.marks,
    DENSE_RANK() OVER (
    PARTITION BY c.course_name
    ORDER BY e.marks DESC) AS Ranking
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
INNER JOIN courses c ON e.course_id = c.course_id;

SELECT *
FROM (
    SELECT 
        c.course_name,
        s.first_name AS Student_Name,
        e.marks,
        DENSE_RANK() OVER (PARTITION BY c.course_name 
        ORDER BY e.marks DESC) AS Ranking
    FROM students s
    INNER JOIN enrollments e ON s.student_id = e.student_id
    INNER JOIN courses c ON e.course_id = c.course_id
) t
WHERE Ranking <= 2;

SELECT first_name FROM students
UNION
SELECT course_name FROM courses ;

-- Students with courses
SELECT s.first_name AS Student_Name, c.course_name
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
INNER JOIN courses c ON e.course_id = c.course_id
UNION
-- Students without courses
SELECT s.first_name AS Student_Name, NULL AS course_name
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE e.student_id IS NULL;

SELECT COUNT(*)
FROM students s
LEFT JOIN enrollments e 
ON s.student_id = e.student_id;

SELECT first_name AS All_Names FROM students 
UNION 
SELECT course_name AS All_Names FROM courses 
ORDER BY All_Names ;

SELECT s.first_name, c.course_name
FROM students s 
LEFT JOIN enrollments e ON s.student_id = e.student_id
RIGHT JOIN courses c ON c.course_id = e.course_id ;

-- Part 1: Students with courses
SELECT s.first_name AS student_name, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id 
UNION
-- Part 2: Courses with NO students
SELECT NULL AS student_name, c.course_name
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE e.course_id IS NULL;

SELECT *
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id ;

SELECT c.course_name
FROM courses c
LEFT JOIN enrollments e 
ON c.course_id = e.course_id
WHERE e.course_id IS NULL;

SELECT s.first_name, c.course_name
FROM students s 
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON c.course_id = e.course_id 
UNION
SELECT NULL AS student_name, c.course_name
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE e.course_id IS NULL; 

SELECT 
    s.first_name AS student_name,
    e.marks
FROM students s
JOIN enrollments e 
    ON s.student_id = e.student_id
WHERE e.marks > (
    SELECT AVG(marks) 
    FROM enrollments);
    
SELECT 
    s.first_name AS student_name,
    c.course_name,
    e.marks
FROM students s
JOIN enrollments e 
    ON s.student_id = e.student_id
JOIN courses c 
    ON e.course_id = c.course_id
WHERE e.marks > (
    SELECT AVG(e2.marks)
    FROM enrollments e2
    WHERE e2.course_id = e.course_id);
        
SELECT *
FROM 
    (SELECT 
        s.first_name AS student_name,
        c.course_name,
        e.marks,
        AVG(e.marks) OVER (PARTITION BY c.course_name) AS avg_marks
    FROM students s
    JOIN enrollments e 
        ON s.student_id = e.student_id
    JOIN courses c 
        ON e.course_id = c.course_id) t
WHERE marks > avg_marks;

SELECT * 
FROM
	(SELECT c.course_name, AVG(e.marks) AS Avg_marks
	FROM courses c 
    JOIN enrollments e ON e.course_id = c.course_id
    GROUP BY course_name)t
WHERE Avg_marks > 85 ;

SELECT 
	s.first_name AS Student_name, 
    c.course_name, e.marks, 
    DENSE_RANK() OVER (PARTITION BY c.course_name ASC) AS First_student
FROM students s
JOIN enrollments e ON e.student_id = s.student_id
JOIN courses c ON c.course_id = e.course_id ;

SELECT *
FROM 
    (SELECT 
        s.first_name AS student_name,
        c.course_name,
        e.marks,
        DENSE_RANK() OVER (
            PARTITION BY c.course_name 
            ORDER BY e.marks DESC) AS rnk
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN courses c ON e.course_id = c.course_id) t
WHERE rnk = 1;

SELECT *
FROM 
    (SELECT 
        s.first_name AS student_name,
        c.course_name,
        e.marks,
        DENSE_RANK() OVER (
            PARTITION BY c.course_name 
            ORDER BY e.marks DESC) AS rnk
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN courses c ON e.course_id = c.course_id) t
WHERE rnk < 3;

SELECT * 
FROM 
    (SELECT 
        s.first_name AS student_name,
        c.course_name,
        e.marks,
        ROW_NUMBER() OVER (PARTITION BY s.student_id, c.course_id ORDER BY e.marks DESC) AS rn
    FROM students s
    JOIN enrollments e 
        ON s.student_id = e.student_id
    JOIN courses c 
        ON e.course_id = c.course_id) t
WHERE rn = 1;

SELECT s.first_name AS student_name, c.course_name, e.marks
FROM (
    SELECT student_id, course_id, marks,
        ROW_NUMBER() OVER (PARTITION BY student_id, course_id ORDER BY marks DESC) AS rn
    FROM enrollments) e
JOIN students s ON s.student_id = e.student_id
JOIN courses c ON c.course_id = e.course_id
WHERE rn = 1;

WITH ranked_data AS (
    SELECT e.student_id, e.course_id, e.marks,
        ROW_NUMBER() OVER (PARTITION BY e.student_id, e.course_id ORDER BY e.marks DESC) AS rn
    FROM enrollments e)
SELECT s.first_name AS student_name, c.course_name, r.marks
FROM ranked_data r
JOIN students s ON s.student_id = r.student_id
JOIN courses c ON c.course_id = r.course_id
WHERE r.rn = 1 ;

WITH ranked_data AS (
    SELECT e.student_id, e.course_id, e.marks,
        ROW_NUMBER() OVER (PARTITION BY e.student_id, e.course_id ORDER BY e.marks DESC) AS rn
    FROM enrollments e)
SELECT s.first_name AS student_name, c.course_name, r.marks
FROM ranked_data r
JOIN students s ON s.student_id = r.student_id
JOIN courses c ON c.course_id = r.course_id
WHERE r.rn <= 2 ;

