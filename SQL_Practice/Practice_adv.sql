CREATE DATABASE Practice_adv ;
USE Practice_adv ;

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    city VARCHAR(50),
    registration_date DATE);
    
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50),
    category VARCHAR(50),
    difficulty_level VARCHAR(20));
    
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    marks INT,
    attempt_number INT,
    attempt_date DATE,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id));
    

INSERT INTO students VALUES
(1,'Ravi','Kumar','Hyderabad','2023-01-10'),
(2,'Asha','Sharma','Delhi','2023-02-15'),
(3,'Kiran','Reddy','Hyderabad','2023-03-01'),
(4,'Meena','Iyer','Chennai','2023-01-25'),
(5,'Arjun','Verma','Mumbai','2023-02-10'),
(6,'Pooja','Patel','Ahmedabad','2023-03-05'),
(7,'Rahul','Singh','Delhi','2023-01-20'),
(8,'Sneha','Das','Kolkata','2023-02-28'),
(9,'Vikram','Nair','Kerala','2023-03-10'),
(10,'Neha','Gupta','Delhi','2023-01-30');

INSERT INTO courses VALUES
(101,'SQL','Data','Medium'),
(102,'Python','Data','Medium'),
(103,'Excel','Analytics','Easy'),
(104,'Power BI','Analytics','Medium'),
(105,'Machine Learning','AI','Hard');

INSERT INTO enrollments VALUES
-- Ravi (multiple attempts)
(1,1,101,70,1,'2023-03-01'),
(2,1,101,85,2,'2023-03-10'),
(3,1,102,60,1,'2023-03-05'),

-- Asha
(4,2,102,78,1,'2023-03-02'),
(5,2,102,88,2,'2023-03-12'),

-- Kiran
(6,3,101,90,1,'2023-03-03'),
(7,3,105,65,1,'2023-03-15'),

-- Meena
(8,4,103,88,1,'2023-03-01'),
(9,4,103,91,2,'2023-03-08'),

-- Arjun
(10,5,104,76,1,'2023-03-04'),

-- Pooja
(11,6,102,95,1,'2023-03-06'),
(12,6,105,72,1,'2023-03-18'),

-- Rahul
(13,7,103,80,1,'2023-03-07'),
(14,7,103,85,2,'2023-03-14'),

-- Sneha
(15,8,101,70,1,'2023-03-09'),

-- Vikram
(16,9,104,92,1,'2023-03-11'),
(17,9,104,89,2,'2023-03-20'),

-- Neha
(18,10,102,84,1,'2023-03-13'),
(19,10,102,90,2,'2023-03-21');


select * FROM students ;
select * from enrollments ;
select * from courses;


SELECT 
    s.first_name AS student_name,
    c.course_name,
    e.attempt_date,
    e.marks AS current_marks,
    LAG(e.marks) OVER (
        PARTITION BY e.student_id, e.course_id
        ORDER BY e.attempt_date)
        AS previous_attempt_marks
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses c ON c.course_id = e.course_id;

SELECT 
    s.first_name AS student_name,
    c.course_name,
    e.attempt_date,
    e.marks AS current_marks,
    LEAD(e.marks) OVER (
        PARTITION BY e.student_id, e.course_id
        ORDER BY e.attempt_date)
        AS Next_attempt_marks
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses c ON c.course_id = e.course_id;

SELECT 
    s.first_name AS student_name,
    c.course_name,
    e.attempt_date,
    e.marks,
    SUM(e.marks) OVER(PARTITION BY e.student_id, c.course_name ORDER BY e.attempt_date) AS Cumulative_marks
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses c ON c.course_id = e.course_id
ORDER BY student_name, course_name, attempt_date ;
    
SELECT 
    s.first_name AS student_name,
    c.course_name,
    e.attempt_date,
    e.marks AS current_marks,
    FIRST_VALUE(e.marks) OVER (
        PARTITION BY e.student_id, e.course_id
        ORDER BY e.attempt_date) AS first_attempt_marks,
    LAST_VALUE(e.marks) OVER (
        PARTITION BY e.student_id, e.course_id
        ORDER BY e.attempt_date
        ROWS BETWEEN UNBOUNDED PRECEDING 
        AND UNBOUNDED FOLLOWING) AS latest_attempt_marks
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses c ON c.course_id = e.course_id
ORDER BY student_name, course_name, attempt_date;

WITH attempt_data AS (
    SELECT
        s.first_name AS student_name,
        c.course_name,
        e.marks,
        ROW_NUMBER() OVER (
            PARTITION BY e.student_id, e.course_id
            ORDER BY e.attempt_date) AS attempt_no
    FROM enrollments e
    JOIN students s ON s.student_id = e.student_id
    JOIN courses c ON c.course_id = e.course_id)
SELECT
    student_name,
    course_name,
    MAX(CASE WHEN attempt_no = 1 THEN marks END) AS first_attempt_marks,
    MAX(CASE WHEN attempt_no = 2 THEN marks END) AS second_attempt_marks
FROM attempt_data
GROUP BY student_name, course_name
ORDER BY student_name, course_name;

WITH attempt_data AS (
    SELECT
        s.first_name AS student_name,
        c.course_name,
        e.marks,
        ROW_NUMBER() OVER (
            PARTITION BY e.student_id, e.course_id
            ORDER BY e.attempt_date
        ) AS attempt_no
    FROM enrollments e
    JOIN students s
        ON s.student_id = e.student_id
    JOIN courses c
        ON c.course_id = e.course_id
)
SELECT
    student_name,
    course_name,
    MAX(
        CASE
            WHEN attempt_no = 1 THEN marks
        END
    ) AS first_attempt_marks,

    MAX(
        CASE
            WHEN attempt_no = 2 THEN marks
        END
    ) AS second_attempt_marks,

    ROUND(AVG(marks), 2) AS aggregate_marks

FROM attempt_data

GROUP BY
    student_name,
    course_name

ORDER BY
    student_name,
    course_name;

WITH Student_data AS (
    SELECT 
        s.first_name AS student_name,
        c.course_name,
        ROUND(AVG(e.marks), 2) AS avg_marks
    FROM students s
    JOIN enrollments e 
        ON s.student_id = e.student_id
    JOIN courses c 
        ON e.course_id = c.course_id
    GROUP BY s.student_id, c.course_id
),
Performance_data AS (
    SELECT 
        student_name,
        course_name,
        avg_marks,
        CASE
            WHEN avg_marks >= 85 THEN 'Excellent'
            WHEN avg_marks >= 70 THEN 'Good'
            ELSE 'Needs Improvement'
        END AS performance_label
    FROM Student_data
)
SELECT *
FROM Performance_data
ORDER BY student_name, course_name ;

SELECT
    s.first_name AS student_name,
    s.city
FROM students s
WHERE EXISTS (
    SELECT 1
    FROM enrollments e
    WHERE e.student_id = s.student_id AND e.marks > 85);
      
SELECT first_name
FROM students s
WHERE EXISTS (
	SELECT 1
    FROM enrollments e
    WHERE e.student_id = s.student_id AND course_id = 105) ;

SELECT first_name
FROM students s
WHERE NOT EXISTS (
	SELECT 1
    FROM enrollments e
    WHERE e.student_id = s.student_id AND course_id = 105) ;
    
SELECT s.first_name AS Student_name, c.course_name, e.marks
FROM students s 
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE e.marks >
(SELECT AVG(marks) FROM enrollments) ;

CREATE TEMPORARY TABLE Temp_student_avg AS
	SELECT s.first_name AS Student_name, c.course_name, ROUND(AVG(e.marks), 2) AS avg_marks
	FROM students s 
	JOIN enrollments e ON s.student_id = e.student_id
	JOIN courses c ON e.course_id = c.course_id
	GROUP BY s.student_id, c.course_id
	ORDER BY s.student_id, c.course_name ;

SELECT * FROM Temp_student_avg ;

SELECT *
FROM Temp_student_avg
WHERE avg_marks > 85;

DELIMITER //
CREATE PROCEDURE Student_Avg_Data()
BEGIN
    SELECT *
    FROM Temp_student_avg
    WHERE avg_marks > 85;
END //
DELIMITER ;
    
CALL Student_Avg_Data() ;

DELIMITER //
CREATE PROCEDURE Get_Students_By_Avg(
    IN min_avg_marks DECIMAL(5,2))
BEGIN
    SELECT
        student_name,
        course_name,
        avg_marks
    FROM Temp_student_avg
    WHERE avg_marks > min_avg_marks;
END //
DELIMITER ;

CALL Get_Students_By_Avg(85);
CALL Get_Students_By_Avg(90);
CALL Get_Students_By_Avg(70);


CREATE TABLE enrollment_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    action_time TIMESTAMP);
    
DELIMITER //
CREATE TRIGGER trg_after_enrollment_insert
AFTER INSERT
ON enrollments
FOR EACH ROW
BEGIN
    INSERT INTO enrollment_logs (
        student_id,
        course_id,
        action_time)
    VALUES (
        NEW.student_id,
        NEW.course_id,
        NOW());
END //
DELIMITER ;

INSERT INTO enrollments
VALUES (
    20,
    2,
    101,
    88,
    1,
    '2023-04-01');

INSERT INTO enrollments
VALUES (
    21,
    5,
    105,
    75,
    1,
    '2023-04-01');

SELECT * FROM enrollment_logs;


SET GLOBAL event_scheduler = ON;

DELIMITER //
CREATE EVENT delete_old_logs
ON SCHEDULE EVERY 1 MINUTE
DO
BEGIN
    DELETE FROM enrollment_logs
    WHERE action_time < NOW();
END //
DELIMITER ;