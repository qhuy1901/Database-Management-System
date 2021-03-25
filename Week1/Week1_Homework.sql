/*18.Display the full name of all employees with no manager.*/
SELECT FIRST_NAME || ' ' || LAST_NAME FULL_NAME
FROM S_EMP
WHERE MANAGER_ID IS NULL

/*19.Alphabetically display all products having a name beginning with Pro.*/
SELECT NAME
FROM S_PRODUCT
WHERE NAME LIKE 'Pro%'
ORDER BY NAME 

/*20.Display all product names and short descriptions (short_desc) for all
descriptions containing the word bicycle.*/
SELECT NAME, SHORT_DESC 
FROM S_PRODUCT
WHERE LOWER(SHORT_DESC) LIKE '%bicycle%'
SELECT * FROM S_PRODUCT

/*21.Determine the number of managers without listing them.*/
SELECT COUNT(DISTINCT MANAGER_ID)
FROM S_EMP

SELECT * FROM S_EMP

/*22.Display the product number and number of times it was ordered,
labeled Times Ordered. Only show those products that have been
ordered at least three times. Order the data by the number of products
ordered.*/ 
SELECT P.ID, COUNT(P.ID) "Times Ordered"
FROM S_PRODUCT P JOIN S_ITEM I ON P.ID = I.PRODUCT_ID 
GROUP BY P.ID
HAVING COUNT(P.ID) >= 3
ORDER BY "Times Ordered" 

/*23.Retrieve the region number, region name, and the number of
departments within each region*/
SELECT R.ID, R.NAME, COUNT(D.ID) "Number of departments"
FROM S_REGION R JOIN S_DEPT D ON R.ID = D.REGION_ID
GROUP BY R.ID, R.NAME

/*24.Display the customer name and the number of orders for each
customer.*/
SELECT C.NAME, COUNT(C.ID) "Number of orders"
FROM S_CUSTOMER C JOIN S_ORD O ON C.ID = O.CUSTOMER_ID
GROUP BY C.NAME

/*25.Display the employee number, first name, last name, and user name for
all employees with salaries above the average salary.*/
SELECT ID, FIRST_NAME, LAST_NAME, USERID
FROM S_EMP
WHERE SALARY > (SELECT AVG(SALARY) FROM S_EMP)

/*26.Display the employee number, first name, and last name for all
employees with a salary above the average salary and that work with
any employee with a last name that contains a “t”.*/
SELECT ID, FIRST_NAME, LAST_NAME, USERID
FROM S_EMP
WHERE SALARY > (SELECT AVG(SALARY) FROM S_EMP)
AND DEPT_ID IN(     SELECT DEPT_ID
                    FROM  S_EMP
                    WHERE LOWER(LAST_NAME) LIKE '%t%')

/*27.Write a query to display the minimum and maximum salary for each
job type ordered alphabetically.*/
SELECT TITLE, MIN(SALARY)"Minimum salary" , MAX(SALARY)"Maxnimum salary"
FROM S_EMP
GROUP BY TITLE
ORDER BY TITLE
