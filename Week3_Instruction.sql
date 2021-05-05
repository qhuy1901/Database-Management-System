--Instruction Con 1 cau chua lm dc
SET SERVEROUTPUT ON
/* 1. Write a pl/sql block to assign value to a variable and print
out the value.*/
DECLARE
    x int := 8;
BEGIN
    DBMS_OUTPUT.PUT_LINE('GIA TRI CUA X LA: ' || x);
END;

/*2. Write a pl/sql block to check number is Odd or Even.*/
DECLARE
    x INT := 46;
BEGIN 
    IF(MOD(x, 2) = 0) THEN
        DBMS_OUTPUT.PUT_LINE(x || ' LA SO CHAN');
    ELSE
        DBMS_OUTPUT.PUT_LINE(x || ' LA SO LE');
    END IF;
END;

/*3. Write a pl/sql block to check a number is greater or lower
than 0.*/
DECLARE
    x INT := -10;
BEGIN
    IF(x >= 0) THEN
        DBMS_OUTPUT.PUT_LINE(x || ' IS GREATER OR EQUAL THAN 0');
    ELSE
        DBMS_OUTPUT.PUT_LINE(x || ' IS LOWER THAN 0');
    END IF;
END;

/* 4. Using database Student Management, write a PL/SQL block to
check how many students are enrolled in course number 25,
section 1. If 15 or more students are enrolled, section 1 of
course number 25 is full. Otherwise, section 1 of course
number 25 is not full. In both cases, a message should be
displayed to the user, indicating whether section 1 is full.*/
DECLARE
    numberOfStudent INT;
BEGIN
    SELECT COUNT(STUDENT_ID) INTO numberOfStudent
    FROM ENROLLMENT E JOIN SECTION S ON E.SECTION_ID = S.SECTION_ID
    WHERE COURSE_NO = 25 AND SECTION_NO = 1;
    
    DBMS_OUTPUT.PUT_LINE('SO LUONG STUDENT DANG KY LA: ' || numberOfStudent);
    IF(numberOfStudent >= 15) THEN
        DBMS_OUTPUT.PUT_LINE('SECTION IS FULL');
    ELSE
        DBMS_OUTPUT.PUT_LINE('SECTION IS NOT FULL');
    END IF;
END;

/* 5. Do question 4 again using a procedure with two parameters:
course number and section number. Write a PL/SQL block to
call the procedure with parameters course number 25, section
1.*/
CREATE OR REPLACE PROCEDURE checkSection(courseNo
SECTION.COURSE_NO%TYPE, sectionNo
SECTION.SECTION_NO%TYPE)
AS
    numberOfStudent INT;
BEGIN
    SELECT COUNT(STUDENT_ID) INTO numberOfStudent
    FROM ENROLLMENT E JOIN SECTION S ON E.SECTION_ID = S.SECTION_ID
    WHERE COURSE_NO = 25 AND SECTION_NO = 1;
    
    DBMS_OUTPUT.PUT_LINE('SO LUONG STUDENT DANG KY LA: ' || numberOfStudent);
    IF(numberOfStudent >= 15) THEN
        DBMS_OUTPUT.PUT_LINE('SECTION IS FULL');
    ELSE
        DBMS_OUTPUT.PUT_LINE('SECTION IS NOT FULL');
    END IF;
END;
--Call the procedure
BEGIN
    checkSection(25, 1);
END;

/*6. Use a numeric FOR loop to calculate a factorial of 10 (10! =
1*2*3...*10). Write a PL/SQL block.*/
DECLARE
    x INT := 10;
    result NUMBER;
BEGIN
    result := 1;
    FOR i IN 1..x LOOP
        result := result * i;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(x || '! = ' || result);
END;

/*7. Write a procedure to calculate the factorial of a number.
Write a PL/SQL block to call this procedure.*/
CREATE OR REPLACE PROCEDURE calculateFactorial(n INT)
AS
    result NUMBER;
BEGIN
    result := 1;
    FOR i IN 1..n LOOP
        result := result * i;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(n || '! = ' || result);
END;
--Call the procedure
BEGIN
    calculatefactorial(10);
END;

/*8. Write a function to calculate the factorial of a
number. Write a PL/SQL block to call this function.*/
CREATE OR REPLACE FUNCTION fFactorial(x INT) RETURN NUMBER
AS
    result NUMBER;
BEGIN
    result := 1;
    FOR i IN 1..x LOOP
        result := result * i;
    END LOOP;
    RETURN result;
END;
--Call the function
DECLARE
    result NUMBER;
BEGIN 
    result := fFactorial(7);
    DBMS_OUTPUT.PUT_LINE(result);
END;

/*9. Write a procedure to calculate and print out the
result of a division. If the denominator is 0 then
adding exception. Write a PL/SQL block to call this
procedure.*/
CREATE OR REPLACE PROCEDURE div(numerator INT, denominator INT)
AS
    result NUMBER;
BEGIN
    result := numerator / denominator;
    DBMS_OUTPUT.PUT_LINE('The result of the division is: ' || result);
    EXCEPTION
        WHEN ZERO_DIVIDE THEN
            DBMS_OUTPUT.PUT_LINE('A number cannot be divied by zero.');
END;
--Calling the procedure
BEGIN
    div(5, 2);
END;

/*10. Write a function to calculate the result of a division.
Write a PL/SQL block to call this function.*/
CREATE OR REPLACE FUNCTION fdiv(numerator INT, denominator INT) RETURN NUMBER
AS
    result NUMBER;
BEGIN
    result := numerator / denominator;
    RETURN result;
    EXCEPTION
        WHEN ZERO_DIVIDE THEN
            RETURN NULL;
END;  
--Calling the fuction
DECLARE
    result NUMBER;
BEGIN
    result := fdiv(4, 0);
    IF(result IS NULL) THEN
        DBMS_OUTPUT.PUT_LINE('A number cannot be divied by zero.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('The result of the division is: ' || result);
    END IF;
END;

/*11.Using database Student Management, write a procedure
to display the student’s name, street_address on the
screen. If no record in the STUDENT table
corresponds to the value of student_id provided by
the user, the exception NO_DATA_FOUND is raised.
Write a PL/SQL block to call this procedure with
parameter is 25, 105.*/
CREATE OR REPLACE PROCEDURE findStudent(idstudent STUDENT.STUDENT_ID%TYPE)
AS
    lname VARCHAR2(50);
    streeadd VARCHAR2(50);
BEGIN
    SELECT LAST_NAME, STREET_ADDRESS INTO lname, streeadd
    FROM STUDENT
    WHERE STUDENT_ID = idstudent;
    DBMS_OUTPUT.PUT_LINE('STUDENT_NAME: ' || lname || ' STUDENT_ADD: ' || streeadd);
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('This student does not exist');
END;
--
BEGIN
    findStudent(105);
END;

/*12. Do the question 11 using fuction to return the
student's record (declare a rowtype variable). Write
a PL/SQL block to call this function and print out
student’s name, address, phone.*/
CREATE OR REPLACE FUNCTION fStudent (idstu
STUDENT.STUDENT_ID%TYPE) RETURN STUDENT%ROWTYPE
AS 
    stuInfo STUDENT%ROWTYPE;
BEGIN
    SELECT * INTO stuInfo
    FROM STUDENT
    WHERE STUDENT_ID = idstu;
    RETURN stuInfo;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
END;
--Call the function
DECLARE 
    stu STUDENT%ROWTYPE;
BEGIN
    stu := fStudent(25);
    DBMS_OUTPUT.PUT_LINE('STUDENT_NAME: ' || stu.last_name || ' STUDENT_ADDRESS: ' || stu.street_address);
END;

DECLARE 
    stu STUDENT%ROWTYPE;
BEGIN
    stu := fStudent(105);
    DBMS_OUTPUT.PUT_LINE('STUDENT_NAME: ' || stu.last_name || ' STUDENT_ADDRESS: ' || stu.street_address);
END;

/*13.Write a procedure to check if the student is
enrolled. If no record in the ENROLLMENT table
corresponds to the value of v_student_id provided by
the user, the exception NO_DATA_FOUND is raised. And
if more than one record in the ENROLLMENT table then
exception TOO_MANY_ROWS is raised.
Write a pl/sql block to call procedure above with
different values of student ID: 102, 103, 319*/
CREATE OR REPLACE PROCEDURE isEnrolled(v_student_id
STUDENT.STUDENT_ID%TYPE) --Chua duoc
AS
    enrollInfo ENROLLMENT%ROWTYPE;
BEGIN
    SELECT * INTO enrollInfo
    FROM ENROLLMENT
    WHERE STUDENT_ID = v_student_id;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('SINH VIEN NAY CHUA EROLL COURSE NAO');
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('SINH VIEN NAY ENROLL NHIEU HON 1 COURSE');
END;
--Calling the procedure
BEGIN
    isEnrolled(319);
END;

/*14.Write a procedure to find full name of the
instructor corresponds to the value of instructor_id
provided by the user.
Write a pl/sql block to call procedure above with
different values of instructor_id: 107, 120*/
CREATE OR REPLACE PROCEDURE findInstructor (idIns
INSTRUCTOR.INSTRUCTOR_ID%TYPE)
AS
    full_name VARCHAR2(30);
BEGIN
    SELECT FIRST_NAME || ' ' || LAST_NAME INTO full_name
    FROM INSTRUCTOR
    WHERE INSTRUCTOR_ID = idIns;
    
    DBMS_OUTPUT.PUT_LINE('The full name of the instructor ' || idIns || ' is ' || full_name);
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('There are no instructor have the ' || idIns || ' id'); 
END;
--Calling the procedure
BEGIN
    findinstructor(120);
    findinstructor(107);
END;

/*15.Write a function to return full name of the
instructor corresponds to the value of instructor_id
provided by the user. Write a PL/SQL block to call
this function.*/
CREATE OR REPLACE FUNCTION fnStructor(idIns
INSTRUCTOR.INSTRUCTOR_ID%TYPE) RETURN VARCHAR2
AS
    full_name VARCHAR2(30);
BEGIN
    SELECT FIRST_NAME || ' ' || LAST_NAME INTO full_name
    FROM INSTRUCTOR
    WHERE INSTRUCTOR_ID = idIns;
    RETURN full_name;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL; 
END; 
--Calling the function
DECLARE
    full_name VARCHAR2(30);
BEGIN
    full_name := fnStructor(107);
    IF(full_name IS NOT NULL) THEN
        DBMS_OUTPUT.PUT_LINE('The full name of the instructor is ' || full_name);
    END IF;
END;

/*16.Write a procedure to find name of a student and how
many courses this user enrolled. Print out the
result on the screen. Write a PL/SQL block to call
this function.*/
CREATE OR REPLACE PROCEDURE findStudentEnroll(idstu
STUDENT.STUDENT_ID%TYPE)
AS
    fname STUDENT.FIRST_NAME%TYPE;
    numberOfCourse INT;
BEGIN
    SELECT FIRST_NAME INTO fname
    FROM STUDENT
    WHERE STUDENT_ID = idstu;
    DBMS_OUTPUT.PUT_LINE('THONG TIN STUDENT: ' || fname);
    
    SELECT COUNT(COURSE_NO) INTO numberOfCourse
    FROM ENROLLMENT E JOIN SECTION S ON E.SECTION_ID = S.SECTION_ID
    WHERE STUDENT_ID = idstu;
    DBMS_OUTPUT.PUT_LINE('SO COURSE MA SINH VIEN NAY DANG KY: ' || numberOfCourse);
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('SINH VIEN NAY KHONG TON TAI');
END;
--Calling the procedure
BEGIN
    findStudentEnroll(120);
END;

/*17.Write a function to calculate how many courses that
student enrolled. Student_id provided by the user.
Write a pl/sql block to call procedure above with
different values of student_id: 109, 530*/
CREATE OR REPLACE FUNCTION fcalculateCourse(idstu
STUDENT.STUDENT_ID%TYPE) RETURN INT
AS
    numberOfCourse INT;
BEGIN
    SELECT COUNT(STUDENT_ID) INTO numberOfCourse
    FROM ENROLLMENT
    WHERE STUDENT_ID = idstu;
    RETURN numberOfCourse;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
END;
--Calling the function
DECLARE
    numberOfCourse INT := fcalculateCourse(530);
BEGIN
    DBMS_OUTPUT.PUT_LINE(numberOfCourse);
END;
    
/*18.Write a procedure to calculate how many students are
registered for a given section of a given course.If
a section of a course has more than 10 students
enrolled in it, an error message is displayed,
indicating that this course has too many students
enrolled (Using RAISE_APPLICATION_ERROR).*/
CREATE OR REPLACE PROCEDURE calNumberOfStudent(courseNo
SECTION.COURSE_NO%TYPE, sectionNo
SECTION.SECTION_NO%TYPE)
AS
    TOO_MANY_STUDENTS EXCEPTION;
    PRAGMA exception_init(TOO_MANY_STUDENTS, -20001);
    numberOfStudent INT;
BEGIN
    BEGIN
        SELECT COUNT(STUDENT_ID) INTO numberOfStudent
        FROM ENROLLMENT E JOIN SECTION S ON E.SECTION_ID = S.SECTION_ID
        WHERE COURSE_NO = courseNo AND SECTION_NO = sectionNo;
        
        IF(numberOfStudent > 10) THEN
            RAISE_APPLICATION_ERROR(-20000, 'Account past due.')LICATION_ERROR(-2001, 'Exception: too many student');
        END IF;
    EXCEPTION
        WHEN TOO_MANY_STUDENTS THEN
            DBMS_OUTPUT.PUT_LINE('This course has too many students enrolled');
    END;  
END;



           
    


    
    

