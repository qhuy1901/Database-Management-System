SET SERVEROUTPUT ON;
/*1. Write a procedure to calculate factorial of a number
and return the value to parameter of procedure:
- Factorial (in val, out result)*/
CREATE OR REPLACE PROCEDURE Factorial1(val IN INT, 
result OUT NUMBER)
AS
    kq INT := 1;
BEGIN
    FOR i IN 1..val
    LOOP
        kq := kq * i;
    END LOOP;
    result := kq;
END;

--Call the procedure
DECLARE
    num INT := 5;
    kq NUMBER;
BEGIN
    DBMS_OUTPUT.PUT(num || '! = ');
    Factorial1(num, kq);
    DBMS_OUTPUT.PUT_LINE(kq);
END;

/*- Factorial (inout val)*/
CREATE OR REPLACE PROCEDURE factorial2(val IN OUT INT)
AS
    kq INT := 1;
BEGIN
    FOR i IN 1..val
    LOOP
        kq := kq * i;
    END LOOP;
    val := kq;
END;
--Call PROCEDURE
DECLARE
    num INT := 5;
BEGIN
    DBMS_OUTPUT.PUT(num || '! = ');
    factorial2(num);
    DBMS_OUTPUT.PUT_LINE(num);
END;

/*2. Write a procedure to find name, address of a student
and output these values to the parameters of the
procedure. Write a pl/sql block to call this
procedure with parameter is 114 and print out these
values on the screen.*/
CREATE OR REPLACE PROCEDURE find_student(id NUMBER,
stuname OUT VARCHAR2, stuadd OUT VARCHAR2)
AS
BEGIN
    SELECT FIRST_NAME || ' ' || LAST_NAME, STREET_ADDRESS INTO stuname, stuadd
    FROM STUDENT
    WHERE STUDENT_ID = id;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('This student is not exist');
END;
--Call the procedure
DECLARE 
    name VARCHAR2(100);
    address VARCHAR2(200);
BEGIN
    find_student(114, name, address);
    DBMS_OUTPUT.PUT_LINE('NAME: ' || name);
    DBMS_OUTPUT.PUT_LINE('ADDRESS: ' || address);
END;

/*3. Write a procedure to print out name, address of a
student and how many courses this student is
enrolled. Use procedure above (question 2) to get
information about name and address of this student.
Write a pl/sql block to call this procedure with
parameter is 106.*/
CREATE OR REPLACE PROCEDURE print_studentInfo(idstu INT)
AS
    name VARCHAR(50); 
    address VARCHAR(50);
    numberOfCourse INT;
BEGIN
    find_student(idstu, name, address);
    SELECT COUNT(COURSE_NO) INTO numberOfCourse
    FROM ENROLLMENT E JOIN SECTION S ON E.SECTION_ID = S.SECTION_ID
    WHERE STUDENT_ID = idstu;
    DBMS_OUTPUT.PUT_LINE('NAME: ' || name);
    DBMS_OUTPUT.PUT_LINE('ADDRESS: ' || address);
    DBMS_OUTPUT.PUT_LINE('NUMBER OF COURSES: ' || numberOfCourse);
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('This student is not exist');
END;
--Call the procedure
BEGIN 
    print_studentInfo(106);
END;

/*4. Write a procedure to update salary of an employee.
The procedure have 3 parameter: emp_id, amount
(default value is 100), extra (default value is 50).
Write a PL/SQL block to call this procedure to
increase salary of employee id =2.
Write a PL/SQL block to call this procedure to
increase salary of employee id =3, amount is 250.*/
CREATE OR REPLACE PROCEDURE increase_salary (emp_id INT,
amount NUMBER DEFAULT 100, extra NUMBER DEFAULT 50)
AS
BEGIN
    UPDATE EMPLOYEE
    SET SALARY = SALARY + amount + extra
    WHERE EMPLOYEE_ID = emp_id;
END;
--Call the procedure
BEGIN
    increase_salary(2);
    increase_salary(3, 250);
END;

/*5. Write a pl/sql block to prints out instructor_id,
salutation, first_name, last_name of all the
instructors. (using cursor)*/
-- Cách 1
BEGIN
    FOR instr IN (SELECT * FROM instructor)
    LOOP
        DBMS_OUTPUT.PUT_LINE(instr.instructor_id || instr.salutation || instr.first_name || instr.last_name);
    END LOOP;
END;
-- Cách 2
DECLARE
    CURSOR c1 IS SELECT * FROM instructor;
BEGIN
    FOR instr IN c1
    LOOP
        DBMS_OUTPUT.PUT_LINE(instr.instructor_id || instr.salutation || instr.first_name);
    END LOOP;
END;

/*6. Write a procedure to display all the information of
the employees whose salary is greater than the value
provided by the user.
Write a pl/sql block to call this procedure with
parameter is 900.*/
CREATE OR REPLACE PROCEDURE display_imployeeInfo(salary INT)
AS
    CURSOR c1 IS SELECT * FROM EMPLOYEE;
BEGIN
    FOR emp IN c1
    LOOP
        IF(emp.SALARY > salary) THEN
            DBMS_OUTPUT.PUT_LINE(emp.EMPLOYEE_ID || emp.NAME || emp.TITLE|| emp.SALARY);
        END IF;
    END LOOP;
END;

--Cách khác
CREATE OR REPLACE PROCEDURE display_imployeeInfo2(sal INT)
AS
    CURSOR c1 IS SELECT * FROM EMPLOYEE WHERE SALARY > sal;
BEGIN
    FOR emp IN c1
    LOOP
        DBMS_OUTPUT.PUT_LINE(emp.EMPLOYEE_ID || emp.NAME || emp.TITLE|| emp.SALARY);
    END LOOP;
END;

--Call the procedure
BEGIN 
    display_imployeeInfo2(900);
    display_imployeeInfo(900);
END;

/*7. Write a PL/SQL block that will reduce the cost of
all courses by 5% for courses having an enrollment
of eight students or more. Use a cursor FOR loop
that will update the course table.*/
CREATE OR REPLACE PROCEDURE reduce_cost
AS
    CURSOR c1 IS
    SELECT COURSE_NO, COUNT(STUDENT_ID) numberOfStudent
    FROM ENROLLMENT E JOIN SECTION S ON E.SECTION_ID = S.SECTION_ID 
    GROUP BY COURSE_NO;
BEGIN
    FOR co IN c1
    LOOP
        IF (co.numberOfStudent >= 8) THEN
            UPDATE COURSE
            SET COST = COST - COST * 0.05
            WHERE COURSE_NO = co.course_no;
        END IF;
    END LOOP;
END;
--
BEGIN 
    reduce_cost;
END;

/*8. Write a PL/SQL block with two cursor for loops. The
parent cursor will call the student_id, first_name,
and last_name from the student table for students
with a student_id less than 110 and output one line
with this information. For each student, the child
cursor will loop through all the courses that the 
student is enrolled in, outputting the course_no and
the description.*/
DECLARE
    CURSOR student_cursor IS
    SELECT *
    FROM STUDENT 
    WHERE STUDENT_ID < 110;
    
    CURSOR student_course_cursor (stuid NUMBER) IS 
    SELECT c.COURSE_NO, c.DESCRIPTION
    FROM (COURSE C JOIN SECTION S ON C.COURSE_NO = S.COURSE_NO)
            JOIN ENROLLMENT E ON E.SECTION_ID = S.SECTION_ID
    WHERE E.STUDENT_ID = stuid;   
BEGIN
    FOR stu IN student_cursor
    LOOP
        DBMS_OUTPUT.PUT_LINE(stu.student_id || ' : ' || stu.FIRST_NAME || ' '|| stu.LAST_NAME);
        FOR cour IN student_course_cursor(stu.student_id)
        LOOP
            DBMS_OUTPUT.PUT_LINE(CHR(9) || cour.DESCRIPTION);
        END LOOP;
    END LOOP;
END;

/*9. Write a function to check a course, if the course
exists then return 1 (yes) else return 0 (no).
(compare the description of this course)
Write a procedure to insert data into course table.
Before inserting data, check this course whether
exists or not.*/
CREATE OR REPLACE FUNCTION isExistCourse(des VARCHAR2) RETURN INT
AS
    CURSOR cur_course IS SELECT DESCRIPTION FROM COURSE;
BEGIN
    FOR cour IN cur_course
    LOOP
        IF(des = cour.DESCRIPTION) THEN
            RETURN 1;
        END IF;
    END LOOP;
    RETURN 0;
END;

CREATE OR REPLACE PROCEDURE insert_course(courseNo NUMBER, des VARCHAR2)
AS
BEGIN
    IF(isExistCourse(des) = 0) THEN
        INSERT INTO COURSE VALUES (courseNo, des, 1195,NULL,'DSCHERER',TO_DATE('29-MAR-2007 20:14:33','DD-MON-YYYY HH24:MI:SS'),'ARISCHER',TO_DATE('05-APR-2007 20:14:33','DD-MON-YYYY HH24:MI:SS'));  
    ELSE
        DBMS_OUTPUT.PUT_LINE('Cannot insert new course because this course is exist');
    END IF;
END;
-- Call the procedure
BEGIN
    insert_course(131, 'No-SQL Database');
END;
select * from course
INSERT INTO course VALUES (11,'Concepts',1195,NULL,'DSCHERER',TO_DATE('29-MAR-2007 20:14:33','DD-MON-YYYY HH24:MI:SS'),'ARISCHER',TO_DATE('05-APR-2007 20:14:33','DD-MON-YYYY HH24:MI:SS'));  

/*10. Write a function that returns all instructors
(return a ref cursor)
Write a PL/SQL block that prints out these
instructors (instructor_id, first_name, last_name,
street_address).*/
CREATE OR REPLACE FUNCTION get_instructors RETURN SYS_REFCURSOR
AS
    c_instructors SYS_REFCURSOR;
BEGIN 
    OPEN c_instructors FOR
    SELECT instructor_id, first_name, last_name, street_address
    FROM INSTRUCTOR;
    RETURN c_instructors;
END;

DECLARE
    c_instructors SYS_REFCURSOR;
    l_inst_id INSTRUCTOR.INSTRUCTOR_ID%TYPE;
    l_inst_first_name INSTRUCTOR.FIRST_NAME%TYPE;
    l_inst_last_name INSTRUCTOR.LAST_NAME%TYPE;
    l_street_address INSTRUCTOR.STREET_ADDRESS%TYPE;
BEGIN
    c_instructors := get_instructors;
    
    LOOP 
        FETCH c_instructors 
        INTO l_inst_id, l_inst_first_name, l_inst_last_name, l_street_address;
        EXIT WHEN c_instructors%notfound;
        
        DBMS_OUTPUT.PUT_LINE(l_inst_id || ' ' || l_inst_first_name || ' '|| l_inst_last_name || ' ' || l_street_address);
    END LOOP;
    
    CLOSE c_instructors;
END;
    
--TRIGGER
/*11. Write a trigger:
When inserting data into employee table,
created_date is the sysdate.
When updating data of employee table, modified_date
is the sysdate.*/
CREATE OR REPLACE TRIGGER trg_insert_employee
BEFORE INSERT OR UPDATE ON EMPLOYEE
FOR EACH ROW
BEGIN
    IF(INSERTING) THEN
        :NEW.CREATED_DATE := SYSDATE;
    ELSIF (UPDATING) THEN
        :NEW.MODIFIED_DATE := SYSDATE;
    END IF;
END;
--Test
INSERT INTO EMPLOYEE (EMPLOYEE_ID, NAME, SALARY, TITLE)
VALUES (21, 'hellen', 200000, 'CIO');
UPDATE EMPLOYEE SET NAME='MICHEL' WHERE EMPLOYEE_ID=21;
SELECT * FROM EMPLOYEE 

/*12. Write a trigger: when updating name, salary, title
of an employee in employee table, old data of this
employee will be inserted into employee_change
table.*/
CREATE OR REPLACE TRIGGER trg_update_employee_TO_employee_change
AFTER UPDATE OF name, salary, title ON EMPLOYEE
FOR EACH ROW
BEGIN 
    INSERT INTO EMPLOYEE_CHANGE 
    VALUES(:OLD.EMPLOYEE_ID, :OLD.NAME, :OLD.SALARY, :OLD.TITLE);
END;
--Test
SELECT * FROM EMPLOYEE_CHANGE
SELECT * FROM EMPLOYEE
UPDATE EMPLOYEE
SET SALARY = SALARY - 1
WHERE EMPLOYEE_ID = 4;

/*13. Write a trigger to guarantee that: Salary of a new
employee cannot below 100.*/
CREATE OR REPLACE TRIGGER check_salary_of_new_emp_TRG
BEFORE INSERT ON EMPLOYEE
FOR EACH ROW
BEGIN
    IF(:NEW.SALARY < 100) THEN
        RAISE_APPLICATION_ERROR(-20000, 'SALARY CANNOT BELOW 100');
    END IF;
END;
--Test
Insert into EMPLOYEE (EMPLOYEE_ID,NAME,SALARY,TITLE)
values (5,'Micheal',50,'Analyst');

/*14. Write a trigger: when inserting data into employee
table, the first letter of name of employee will be
capitalized (initcap)*/
CREATE OR REPLACE TRIGGER initcap_name_emp_trg 
BEFORE INSERT ON EMPLOYEE
FOR EACH ROW
BEGIN
    :NEW.NAME := INITCAP(:NEW.NAME);
END;
--Test
SELECT * FROM EMPLOYEE
INSERT INTO EMPLOYEE (EMPLOYEE_ID, NAME, SALARY, TITLE)
VALUES (23, 'marco', 200000, 'Analyst');
    