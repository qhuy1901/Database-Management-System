/*1. Display the user id for employee 23.*/
SELECT USERID
FROM S_EMP
WHERE ID = 23;

/*2. Display the first name, last name, and department number of the
employees in departments 10 and 50 in alphabetical order of last name.
Merge the first name and last name together, and title the column
Employees. (Use ‘||’ to merge columns).*/
SELECT FIRST_NAME || ' ' || LAST_NAME Employees, DEPT_ID
FROM S_EMP
WHERE DEPT_ID IN (10, 50)
ORDER BY LAST_NAME

/*3. Display all employees whose last names contain an “s”.*/
SELECT *
FROM S_EMP
WHERE UPPER(LAST_NAME) LIKE '%S%'

/*4. Display the user ids and start date of employees hired between May
5,1990 and May 26, 1991. Order the query results by start date
ascending order.*/
SELECT USERID, START_DATE
FROM S_EMP
WHERE START_DATE BETWEEN '05-MAY-1990' AND '26-MAY-1991'
ORDER BY START_DATE DESC

SELECT USERID, START_DATE
FROM S_EMP
WHERE START_DATE BETWEEN TO_DATE('05-05-1990','dd-mm-yyyy') AND TO_DATE('26-05-1991','dd-mm-yyyy')
ORDER BY START_DATE DESC

/*5. Write a query to show the last name and salary of all employees who
are not making between 1000 and 2500 per month.*/
SELECT LAST_NAME, SALARY
FROM S_EMP
WHERE SALARY NOT BETWEEN 1000 AND 2500

/*6. List the last name and salary of employees who earn more than 1350
who are in department 31, 42, or 50. Label the last name column
Employee Name, and label the salary column Monthly Salary.*/
SELECT LAST_NAME "Employ Name", SALARY "Monthly Salary"
FROM S_EMP
WHERE SALARY > 1350 AND DEPT_ID IN (31,42,50)

/*7. Display the last name and start date of every employee who was hired
in 1991.*/
SELECT LAST_NAME, START_DATE
FROM S_EMP
WHERE EXTRACT(YEAR FROM START_DATE) = 1991

/*8. Display the employee number, last name, and salary increased by 15%
and expressed as a whole number*/
SELECT ID, LAST_NAME, SALARY * 1.15 "WHOLE_NUMBER"
FROM S_EMP

/*9. Display the employee last name and title in parentheses for all
employees. The report should look like the output below.
EMPLOYEE
----------------------------------------------------
Biri(Warehouse Manager)
Catchpole(Warehouse Manager)
Chang(Stock Clerk)
Dancs(Stock Clerk)
Dumas(Sales Representative)
*/
SELECT LAST_NAME || '(' || TITLE || ')' EMPLOYEE
FROM S_EMP

/*10.Display the product name for products that have “ski” in the name.*/
SELECT NAME
FROM S_PRODUCT
WHERE LOWER(NAME) LIKE '%ski%'

/*11.For each employee, calculate the number of months between today and
the date the employee was hired. Order your result by the number of
months employed. Round the number of months up to the closest whole
number. (use the MONTHS_BETWEEN and ROUND function).*/
SELECT ID, LAST_NAME, ROUND(MONTHS_BETWEEN (SYSDATE, START_DATE), 2) NUMBER_OF_MONTHS
FROM S_EMP
ORDER BY NUMBER_OF_MONTHS

/*12.Display the highest and lowest order totals in the S_ORD. Label the
columns Highest and Lowest, respectively.*/
SELECT MAX(TOTAL)HIGHEST, MIN(TOTAL) LOWEST
FROM S_ORD

/*13.Display the product name, product number, and quantity ordered of all
items in order number 101. Label the quantity column ORDERED.*/
SELECT P.NAME, P.ID, SUM(QUANTITY)
FROM S_PRODUCT P JOIN S_ITEM I ON P.ID = I.PRODUCT_ID
WHERE ORD_ID = 101
GROUP BY  P.NAME, P.ID

/*14.Display the customer number and the last name of their sales
representative. Order the list by last name.*/
SELECT C.ID, E.LAST_NAME
FROM S_CUSTOMER C JOIN S_EMP E ON C.SALES_REP_ID = E.ID

/*15.Display the customer number, customer name, and order number of all
customers and their orders. Display the customer number and name,
even if they have not placed an order.*/
SELECT C.ID, C.NAME, O.ID
FROM S_CUSTOMER C LEFT JOIN S_ORD O ON C.ID = O.CUSTOMER_ID

/*16.Display all employees by last name and employee number along with
their manager’s last name and manager number.*/
SELECT S1.LAST_NAME, S1.ID, S2.LAST_NAME, S2.ID
FROM S_EMP S1 JOIN S_EMP S2 ON S1.MANAGER_ID = S2.ID

/*17.Display all customers and the product number and quantities they
ordered for those customers whose order totaled more than 100000.*/
SELECT C.ID, C.NAME, P.ID, SUM(QUANTITY)
FROM S_CUSTOMER C, S_ORD O, S_PRODUCT P, S_ITEM I
WHERE C.ID = O.CUSTOMER_ID AND O.ID = I.ORD_ID AND I.PRODUCT_ID = P.ID
GROUP BY C.ID, C.NAME, P.ID
HAVING SUM(QUANTITY) > 100000
