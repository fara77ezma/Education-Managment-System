
-- Inserting sample data for the "students" table
INSERT INTO students (student_id, name, department) VALUES
    (1, 'John Doe', 'Computer Science'),
    (2, 'Jane Smith', 'Engineering'),
    (3, 'Bob Johnson', 'Mathematics');

-- Inserting sample data for the "courses" table
INSERT INTO courses (course_id, course_name) VALUES
    (101, 'Introduction to Programming'),
    (102, 'Database Management'),
    (103, 'Linear Algebra');

-- Inserting sample data for the "Enrollment" table
INSERT INTO Enrollment (student_id, course_id) VALUES
    (1, 101),
    (1, 102),
    (2, 101),
    (3, 103);

-- Inserting sample data for the "transcripts" table
INSERT INTO transcripts (transcript_id, grade, status, student_id, course_id) VALUES
    (1, 85, 'completed', 1, 101),
    (2, 90, 'completed', 1, 102),
    (3, NULL, 'ongoing', 2, 101),
    (4, NULL, 'ongoing', 3, 103);

-- Inserting sample data for the "grades" table
INSERT INTO grades (grade_id, grade, assignment_name, student_id, course_id) VALUES
    (1, 88, 'Midterm Exam', 1, 101),
    (2, 95, 'Final Exam', 1, 102),
    (3, 82, 'Midterm Exam', 2, 101);

-- Inserting sample data for the "attendances" table
INSERT INTO attendances (attendance_id, session_name, session_date, status, student_id, course_id) VALUES
    (1, 'Session 1', '2024-03-02', 'present', 1, 101),
    (2, 'Session 2', '2024-03-02', 'absent', 2, 101),
    (3, 'Session 3', '2024-03-02', 'present', 3, 103);

-- Inserting sample data for the "course_announcements" table
INSERT INTO course_announcements (announcement_id, post_date, announcement_text, course_id) VALUES
    (1, '2024-03-01', 'Important announcement for Introduction to Programming', 101),
    (2, '2024-03-02', 'Database Management class canceled', 102);



-- Count the number of students in the "Type the course name you want" course

SELECT COUNT("student_id") AS "Number of Students","name" FROM "courses" JOIN "Enrollment"
ON "course_name"='Introduction to Programming'
AND "courses"."course_id" ="Enrollment"."course_id"
GROUP BY "courses"."course_id"

-- List students in the "Type the course name you want" course

SELECT "name" FROM "courses" JOIN "Enrollment"
ON "course_name"='Introduction to Programming'
AND "courses"."course_id" ="Enrollment"."course_id"
JOIN "students" ON "Enrollment"."student_id"="students"."student_id"

-- List courses enrolled by 'Type the name you want'

SELECT "course_name" FROM "courses" JOIN "Enrollment"
ON "name"='John Doe'
AND "courses"."course_id" ="Enrollment"."course_id"
JOIN "students" ON "Enrollment"."student_id"="students"."student_id"

-- List course name, assignment name, and grade for 'Type the name you want'

SELECT "course_name","assignment_name","grade" FROM "courses","grades"
WHERE "courses"."course_id"="grades"."course_id"
AND "student_id" = (
    SELECT "student_id" FROM "students" WHERE "name" = 'John Doe'
);

-- List ongoing courses for 'Type the name you want'

SELECT "course_name","grade" FROM "transcripts"
JOIN "courses" ON "courses"."course_id" = "transcripts"."course_id"
AND "status" = 'ongoing'
AND "student_id" =(
SELECT "student_id" FROM "students" WHERE "name" = 'Jane Smith'
);



-- List names and session dates for students with 'present' status in attendance

SELECT "name","session_date"  FROM "attendances"
JOIN "students" ON "status"='present'
AND "attendances"."student_id" = "students"."student_id"
ORDER BY "name"

-- List the course announcements for each course

SELECT "course_name","announcement_text","post_date" FROM "course_announcements"
JOIN "courses" ON "courses"."course_id" = "course_announcements"."course_id"


-- List courses for students with ongoing status in transcripts

SELECT  "name",  "course_name"
FROM"students" JOIN "transcripts"
ON "transcripts"."student_id" = "students"."student_id"
JOIN "courses"
ON "transcripts"."course_id" = "courses"."course_id"
AND "status" ='ongoing'

-- List courses with no enrollments

SELECT "course_name" FROM "courses"
JOIN "Enrollment"
ON "courses"."course_id" = "Enrollment" . "course_id"
GROUP BY "Enrollment" . "course_id"
HAVING COUNT ("Enrollment" . "course_id") = 0

-- List the latest course announcements for each course

SELECT "course_name","announcement_text","post_date" FROM "courses"
JOIN "course_announcements"
ON "course_announcements"."course_id" ="courses" ."course_id"
AND "post_date" = (
    SELECT MAX("post_date") FROM "course_announcements"
    WHERE "course_id" ="courses" ."course_id"
)

-- Retrieve average grades for courses

SELECT * FROM "average_grade_for_courses"

-- Retrieve top 10 average grades for students

SELECT * FROM "average_grade_for_students"
LIMIT 10


-- Retrieve data from the student grades view

SELECT * FROM "student_grades_view";

-- Retrieve data from the enrolled students view

SELECT * FROM "enrolled_students_view";

-- Retrieve data from the Course Announcements View

SELECT * FROM "course_announcements_view";

-- Retrieve data from the attendance summary view

SELECT * FROM "attendance_summary_view" ;
