-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database

SELECT * FROM "employees" LIMIT 15;
SELECT * FROM "courses_status" LIMIT 15;

-- Find all records for a given employees
SELECT *
FROM "courses_status"
WHERE "employee_name" = 'Harpreet Singh Minhas';

-- Find all employees with expired induction course
SELECT *
FROM "induction_status"
WHERE "status" = 'expired';

-- Add a new employee
INSERT INTO employees (employee_name, designation, nationality, department, joining_date)
VALUES ('Gyunam Park', 'HSE Engineer', 'S. Korea', 'HSE', '12/01/23');

SELECT * FROM employees ORDER BY employee_id DESC LIMIT 3;

-- Add a new instructor
INSERT INTO instructors (instructor_name)
VALUES ('Ha Manh Bao');

SELECT * FROM instructors ORDER BY instructor_id DESC LIMIT 3;

-- Add a new session
INSERT INTO sessions (session_date, instructor_id, course_id)
VALUES ('2023-12-02', 1, 1);

SELECT * FROM sessions ORDER BY session_id DESC LIMIT 3;

-- Add 1 or more employees to a session
INSERT INTO classes (session_id, employee_id)
VALUES
(661, 1),
(661, 2),
(661, 3);

SELECT * FROM classes ORDER BY session_id DESC LIMIT 5;


-- Soft delete a leaving employee
SELECT * FROM employees LIMIT 5;

UPDATE "employees"
SET "status" = 'inactive'
WHERE "employee_name" = 'Sengpyo Choi';

SELECT * FROM employees LIMIT 5;
