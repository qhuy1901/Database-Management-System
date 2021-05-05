SET SERVEROUTPUT ON;
/*3. Write a function to calculate how many courses are
enrolled for a given student id.
Write a procedure to print out student’s name for a
given student id.
Write a pl/sql block to call procedure above with
different values of student_id 106, 25. Write the
output of pl/sql block to your file.*/ -- Con y cuoi chua lam duoc
CREATE OR REPLACE FUNCTION HomeWork_calNumberOfCourse(idstu  
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
-- Call the function
BEGIN
    DBMS_OUTPUT.PUT_LINE(HomeWork_calNumberOfCourse(106));
END;


CREATE OR REPLACE PROCEDURE HomeWork_displayStudentName
    (idstu STUDENT.STUDENT_ID%TYPE)
AS
    Name VARCHAR(30);
BEGIN
    SELECT FIRST_NAME || ' ' || LAST_NAME INTO Name
    FROM STUDENT
    WHERE STUDENT_ID = idstu;
    
    DBMS_OUTPUT.PUT_LINE('The name of the ' || idstu || ' student is ' || Name);
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('This student is not exist');
END;
-- Call the procedure
BEGIN
    HomeWork_displayStudentName(106);
    HomeWork_displayStudentName(25);
END;


/*4. Write a function to return the information of a
course (rowtype) with a given course_no.
Write a pl/sql block to call function above and
print out the description, cost, created_by with
different values of course_no: 10, 440. Write the
output of pl/sql block to your file.*/
CREATE OR REPLACE FUNCTION HomeWork_displayCourseInfo(courseNo
COURSE.COURSE_NO%TYPE) RETURN COURSE%ROWTYPE
AS
    courseInfo COURSE%ROWTYPE;
BEGIN
    SELECT * INTO courseInfo
    FROM COURSE
    WHERE COURSE_NO = courseNo;
    RETURN courseInfo;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
END;
--Call the function
DECLARE
    r_courseInfo COURSE%ROWTYPE;
BEGIN
    r_courseInfo := HomeWork_displayCourseInfo(10);
    DBMS_OUTPUT.PUT_LINE('DESCRIPTION: ' || r_courseInfo.DESCRIPTION);
    DBMS_OUTPUT.PUT_LINE('COST: ' || r_courseInfo.COST); 
    DBMS_OUTPUT.PUT_LINE('CREATED_BY: ' || r_courseInfo.CREATED_BY);
END;

DECLARE
    r_courseInfo COURSE%ROWTYPE;
BEGIN
    r_courseInfo := HomeWork_displayCourseInfo(440);
    DBMS_OUTPUT.PUT_LINE('DESCRIPTION: ' || r_courseInfo.DESCRIPTION);
    DBMS_OUTPUT.PUT_LINE('COST: ' || r_courseInfo.COST); 
    DBMS_OUTPUT.PUT_LINE('CREATED_BY: ' || r_courseInfo.CREATED_BY);
END;




    
    