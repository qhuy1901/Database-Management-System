SET SERVEROUTPUT ON;
/*1. Write a procedure with parameter is section_id,
return (OUT parameter) course_no, description, cost,
number of student enrolled to this section.
Write a pl/sql block to call this procedure.*/
CREATE OR REPLACE PROCEDURE Cau1 (secid NUMBER, courNo OUT COURSE.COURSE_NO%TYPE,
des OUT course.description%TYPE, co OUT COURSE.COST%TYPE, numOfstudent OUT INT)
AS
BEGIN
    SELECT C.COURSE_NO, DESCRIPTION, COST  INTO courNo , des, co
    FROM COURSE C JOIN SECTION S ON C.COURSE_NO = S.COURSE_NO
    WHERE SECTION_ID = secid;
    
    SELECT COUNT (STUDENT_ID) INTO numOfstudent
    FROM (COURSE C JOIN SECTION S ON C.COURSE_NO = S.COURSE_NO)
       JOIN ENROLLMENT E ON S.SECTION_ID = E.SECTION_ID
    WHERE C.COURSE_NO = courNo;
END;
--Call the procedure
DECLARE
    courNo COURSE.COURSE_NO%TYPE;
    des course.description%TYPE; 
    co COURSE.COST%TYPE; 
    numOfstudent INT;
BEGIN
    Cau1(79, courNo, des, co, numOfstudent);
    DBMS_OUTPUT.PUT_LINE(courNo || ' ' || des || ' ' || co || ' ' || numOfstudent);
END;

/*2. Write a procedure to increase the salary of all the
employees
- If title is Analyst then increase the salary by
10%
- If title is Janitor then increase the salary by
5%.
- If title is Manager or President then increase the
salary by 2%.*/
CREATE OR REPLACE PROCEDURE increase_salary_all_emp
AS 
    CURSOR c_emp IS
    SELECT * FROM EMPLOYEE;
    HSLuong NUMBER;
BEGIN
    FOR emp IN c_emp
    LOOP
        IF(emp.TITLE = 'Analyst') THEN
            HSLuong := 0.1;
        ELSIF(emp.TITLE = 'Janitor') THEN
            HSLuong := 0.05;
        ELSE 
            HSLuong := 0.02;
        END IF;
        UPDATE EMPLOYEE
        SET SALARY = SALARY + SALARY * HSLuong
        WHERE EMPLOYEE_ID = emp.EMPLOYEE_ID;
    END LOOP;
END;
--Call the procedure
BEGIN
   increase_salary_all_emp;
END;
SELECT* FROM EMPLOYEE;

/*3. Write a PL/SQL block with two cursor for loops. The
parent cursor will call the employee_id, name,
salary from the employee table and output one line
with this information. For each employee, the child
cursor will loop through all the employee_change and
outputting the salary, title of this employee.*/
DECLARE
    CURSOR c_emp IS
    SELECT employee_id, name, salary FROM EMPLOYEE;
    
    CURSOR c_emp_change IS
    SELECT * FROM EMPLOYEE_CHANGE;
BEGIN
    FOR emp IN c_emp
    LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || emp.employee_id || ' NAME: ' || emp.NAME  || ' SALARY: ' || emp.SALARY);
        FOR emp_change IN c_emp_change
        LOOP
            IF(emp_change.employee_id = emp.employee_id) THEN
                DBMS_OUTPUT.PUT_LINE(emp_change.salary || ' ' || emp_change.title);
            END IF;
        END LOOP;
    END LOOP;
END;

/*4. Write a trigger: When inserting or updating data of
employee_change table, title of employee is always
converted to lowercase letter.
Write two statements to insert and update data of
employee_change table.*/
CREATE OR REPLACE TRIGGER ins_upd_emp_chnage_trg 
BEFORE INSERT OR UPDATE ON EMPLOYEE_CHANGE
FOR EACH ROW
BEGIN
    :NEW.TITLE := LOWER(:NEW.TITLE);
END;
--Test
SELECT * FROM EMPLOYEE_CHANGE;
UPDATE EMPLOYEE_CHANGE
SET NAME = 'Fred'
WHERE EMPLOYEE_ID = 4;
