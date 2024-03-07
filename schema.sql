
CREATE TABLE "students" (
   "student_id" INTEGER,
   "name" TEXT NOT NULL,
   "enrollment_date" NUMERIC DEFAULT CURRENT_TIMESTAMP,
   "department" TEXT NOT NULL,
   PRIMARY KEY ("student_id")
);
CREATE TABLE "courses" (
   "course_id" INTEGER,
   "course_name" TEXT NOT NULL,

   PRIMARY KEY ("course_id")
);
CREATE TABLE "Enrollment" (
     "student_id" INTEGER,
     "course_id" INTEGER,
   PRIMARY KEY ("course_id","student_id"),
   FOREIGN KEY ("student_id") REFERENCES "students"("student_id"),
   FOREIGN KEY ("course_id") REFERENCES "courses"("course_id")


);
CREATE TABLE "transcripts" (
   "transcript_id" INTEGER,
    "grade" NUMERIC ,
    "status" TEXT DEFAULT 'ongoing' CHECK  ("status" IN ('completed','ongoing')),
    "student_id" INTEGER,
    "course_id" INTEGER,
    FOREIGN KEY ("student_id") REFERENCES "students"("student_id"),
    FOREIGN KEY ("course_id") REFERENCES "courses"("course_id"),
    PRIMARY KEY ("transcript_id")
);
CREATE TABLE "grades" (
   "grade_id" INTEGER,
    "grade" NUMERIC NOT NULL,
    "assignment_name" TEXT NOT NULL,
    "student_id" INTEGER,
    "course_id" INTEGER,
   FOREIGN KEY ("student_id") REFERENCES "students"("student_id"),
   FOREIGN KEY ("course_id") REFERENCES "courses"("course_id"),
   PRIMARY KEY ("grade_id")
);

CREATE TABLE "attendances" (
   "attendance_id" INTEGER,
    "session_name" TEXT ,
    "session_date" NUMERIC NOT NULL,
    "status" TEXT DEFAULT 'absent' CHECK  ("status" IN ('present','absent')),
    "student_id" INTEGER,
    "course_id" INTEGER,
   FOREIGN KEY ("student_id") REFERENCES "students"("student_id"),
   FOREIGN KEY ("course_id") REFERENCES "courses"("course_id"),
   PRIMARY KEY ("attendance_id")
);


CREATE TABLE "course_announcements" (
   "announcement_id" INTEGER,
    "post_date" NUMERIC NOT NULL,
    "announcement_text" TEXT NOT NULL,
    "course_id" INTEGER,
   FOREIGN KEY ("course_id") REFERENCES "courses"("course_id"),
   PRIMARY KEY ("announcement_id")
);




CREATE INDEX "search_by_course_name" ON "courses" ("course_name");
CREATE INDEX "search_by_student_name" ON "students" ("name");
CREATE INDEX "search_by_transcripts_status" ON "transcripts" ("status");
CREATE INDEX "search_by_attendances_status" ON "attendances" ("status");

CREATE VIEW "attendance_summary_view" AS
SELECT "name" ,COUNT(CASE WHEN "attendances"."status" = 'present' THEN 1 END) AS "Sessions_Attended",
COUNT(CASE WHEN "attendances"."status" = 'absent' THEN 1 END) AS "Sessions_Absent"
FROM "students" JOIN "attendances"
ON "attendances"."student_id" = "students"."student_id"
GROUP BY  "students"."student_id";

CREATE VIEW "average_grade_for_students" AS
SELECT "name",ROUND(AVG("grades"."grade"),2) AS "Average Grade for Students"
FROM"students" JOIN "grades"
ON "grades"."student_id" = "students"."student_id"
GROUP BY "students"."student_id"
ORDER BY "Average Grade for Students" DESC;

CREATE VIEW "average_grade_for_courses" AS
SELECT "course_name",ROUND(AVG("grades"."grade"),2) AS "Average Grade for Courses"
FROM"courses" JOIN "grades"
ON "grades"."course_id" = "courses"."course_id"
GROUP BY "courses"."course_id";


CREATE VIEW "student_grades_view" AS
SELECT "name" AS "Student Name" , "course_name" As "Course Name","grade" AS "Course Grade" FROM "students"
JOIN "grades" ON "students"."student_id"= "grades"."student_id"
JOIN "courses" ON "courses"."course_id" ="grades"."course_id";


CREATE VIEW "enrolled_students_view" AS
SELECT "name" AS "Student Name" , "course_name" As "Course Name" FROM "students"
JOIN "Enrollment" ON "students"."student_id"= "Enrollment"."student_id"
JOIN "courses" ON "courses"."course_id" ="Enrollment"."course_id";

CREATE VIEW "course_announcements_view" AS
SELECT "course_name" As "Course Name","announcement_text" AS "Course Details" ,"post_date" AS "Date of announcement" FROM "course_announcements"
JOIN "courses" ON "courses"."course_id" ="course_announcements"."course_id";

