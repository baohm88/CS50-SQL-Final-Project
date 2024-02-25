-- In this SQL file, write (and comment!) the schema of your database, including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it
-- Represent employees taking the class
CREATE TABLE "employees" (
    "employee_id" INTEGER,
    "employee_name" TEXT NOT NULL,
    "designation" TEXT NOT NULL,
    "nationality" TEXT NOT NULL,
    "department" TEXT NOT NULL,
    "joining_date" NUMERIC NOT NULL DEFAULT TIMESTAMP,
    "status" TEXT NOT NULL CHECK("status" IN ('active', 'inactive')) DEFAULT 'active',
    PRIMARY KEY("employee_id")
);

.import --csv --skip 1 employees.csv employees

-- Represent courses for which employees can register
CREATE TABLE "courses" (
    "course_id" INTEGER,
    "course_title" TEXT NOT NULL,
    PRIMARY KEY("course_id")
);

.import --csv --skip 1 courses.csv courses

-- Represent instructors teaching the class
CREATE TABLE "instructors" (
    "instructor_id" INTEGER,
    "instructor_name" TEXT NOT NULL,
    PRIMARY KEY("instructor_id")
);

.import --csv --skip 1 instructors.csv instructors

-- Represent related details of the session
CREATE TABLE "sessions" (
    "session_id" INTEGER,
    "session_date" DATE NOT NULL,
    "instructor_id" INTEGER NOT NULL,
    "course_id" INTEGER NOT NULL,
    PRIMARY KEY("session_id"),
    FOREIGN KEY("instructor_id") REFERENCES "instructors"("instructor_id"),
    FOREIGN KEY("course_id") REFERENCES "courses"("course_id")
);

.import --csv --skip 1 sessions.csv sessions

-- Represent records of all classes
CREATE TABLE "classes" (
    "session_id" INTEGER NOT NULL,
    "employee_id" INTEGER NOT NULL,
    FOREIGN KEY("session_id") REFERENCES "sessions"("session_id"),
    FOREIGN KEY("employee_id") REFERENCES "employees"("employee_id")
);

.import --csv --skip 1 classes.csv classes

-- Represent ratings of all classes
CREATE TABLE "ratings" (
    "rating_id" INTEGER,
    "session_id" INTEGER NOT NULL,
    "rating" INTEGER NOT NULL,
    PRIMARY KEY("rating_id"),
    FOREIGN KEY("session_id") REFERENCES "sessions"("session_id")
);

.import --csv --skip 1 ratings.csv ratings

-- create view of all records
CREATE VIEW all_records AS
SELECT e.employee_name, c.course_title, s.session_date AS course_date FROM classes AS cl
LEFT JOIN sessions AS s ON CL.session_id = s.session_id
LEFT JOIN courses AS c ON s.course_id = c.course_id
lEFT JOIN employees AS e ON cl.employee_id = e.employee_id
ORDER BY course_date DESC;


-- create view of all employees with induction records
CREATE VIEW induction_records AS
SELECT e.employee_id, e.employee_name, a.course_title AS title, a.course_date FROM employees AS e
FULL JOIN all_records AS a ON e.employee_name = a.employee_name
WHERE title = 'HSE Induction'
GROUP BY e.employee_name;

-- Find all courses given employee name
CREATE VIEW courses_status AS
SELECT *,
CASE
    WHEN course_date < DATE('2022-12-01') THEN 'expired'
    ELSE 'valid'
END AS status
FROM all_records
ORDER BY course_date DESC;

-- Filter only latest induction records
CREATE VIEW induction AS
SELECT employee_name, course_title, MAX(course_date) as completion_date
FROM courses_status
WHERE course_title = 'HSE Induction'
GROUP BY  employee_name;

-- Find latest induction records of all employees without status
CREATE VIEW induction_tb AS
SELECT e.employee_name, i.course_title, i.completion_date FROM employees AS e
LEFT JOIN induction AS i ON e.employee_name = I.employee_name
ORDER BY i.completion_date;

-- Find latest induction records of all employees with status
CREATE VIEW induction_status AS
SELECT *,
CASE
    WHEN completion_date > DATE('2022-12-01') THEN 'valid'
    ELSE 'expired'
END AS status
FROM induction_tb;

-- Create indexes to speed common searches
CREATE INDEX "employee_name_idx" ON "employees"("employee_name");
CREATE INDEX "course_idx" ON "sessions"("session_id, course_id");
CREATE INDEX "course_title_idx" ON "courses"("course_title");

