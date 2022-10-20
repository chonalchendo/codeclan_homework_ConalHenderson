-- Question 1.
-- How many employee records are lacking both a grade and salary?

SELECT count(*)
FROM employees 
WHERE grade IS NULL AND salary IS NULL

-- Question 2.
-- Produce a table with the two following fields (columns):

-- the department
-- the employees full name (first and last name)
-- Order your resulting table alphabetically by department, and then by last name


SELECT e.department, e.first_name, e.last_name 
FROM employees AS e
ORDER BY department ASC, last_name ASC 


-- Question 3.
-- Find the details of the top ten highest paid employees who have a last_name beginning with ‘A’.

SELECT *
FROM employees AS e
WHERE last_name LIKE 'A%'
ORDER BY salary DESC NULLS LAST
LIMIT 10

-- Question 4.
-- Obtain a count by department of the employees who started work with the corporation in 2003.


SELECT department, count(*)
FROM employees 
WHERE start_date BETWEEN '2003-01-01' AND '2003-12-31'
GROUP BY department

-- Question 5.
-- Obtain a table showing department, fte_hours and 
-- the number of employees in each department who work each fte_hours pattern. 
-- Order the table alphabetically by department, and then in ascending order of fte_hours.
-- Hint
-- You need to GROUP BY two columns here.


SELECT e.department, e.fte_hours, count(*)
FROM employees AS e
GROUP BY department, fte_hours 
ORDER BY department ASC, fte_hours ASC


-- Question 6.
-- Provide a breakdown of the numbers of employees enrolled, not enrolled, and 
-- with unknown enrollment status in the corporation pension scheme.

SELECT pension_enrol, count(*)
FROM employees 
GROUP BY pension_enrol 

-- Question 7.
-- Obtain the details for the employee with the highest salary 
-- in the ‘Accounting’ department who is not enrolled in the pension scheme?

SELECT *
FROM employees 
WHERE department = 'Accounting' AND pension_enrol = FALSE
ORDER BY salary DESC NULLS LAST
LIMIT 1

-- Question 8.
-- Get a table of country, number of employees in that country, 
-- and the average salary of employees in that country for any countries 
-- in which more than 30 employees are based. Order the table by average salary descending.


-- Hints
-- A HAVING clause is needed to filter using an aggregate function.

-- You can pass a column alias to ORDER BY.


SELECT country, count(*) AS num_employees_country, round(avg(salary)) AS avg_sal
FROM employees AS e
GROUP BY country
HAVING count(*) > 30
ORDER BY avg_sal DESC 


-- Question 9.
-- Return a table containing each employees first_name, last_name, 
-- full-time equivalent hours (fte_hours), salary, and 
-- a new column effective_yearly_salary which should contain 
-- fte_hours multiplied by salary. 
-- Return only rows where effective_yearly_salary is more than 30000.


SELECT e.first_name , e.last_name , e.fte_hours , e.salary , fte_hours * salary AS effective_yearly_salary
FROM employees AS e
WHERE fte_hours * salary > 30000


-- Question 10
-- Find the details of all employees in either Data Team 1 or Data Team 2
-- Hint
-- name is a field in table `teams

SELECT *
FROM employees AS e
INNER JOIN teams AS t
ON e.team_id = t.id 
WHERE t."name" = 'Data Team 1' OR t."name" = 'Data Team 2'



-- Question 11
-- Find the first name and last name of all employees who lack a local_tax_code.

SELECT e.first_name, e.last_name, pd.local_tax_code  
FROM employees AS e
LEFT JOIN pay_details AS pd
ON e.pay_detail_id = pd.id 
WHERE pd.local_tax_code IS NULL


-- Question 12.
-- The expected_profit of an employee is defined as 
-- (48 * 35 * charge_cost - salary) * fte_hours, 
-- where charge_cost depends upon the team to which the employee belongs. 
-- Get a table showing expected_profit for each employee.


SELECT e.first_name , e.last_name , 
(48 * 35 * CAST(t.charge_cost AS int ) - e.salary) * e.fte_hours AS expected_profit
FROM employees AS e
INNER JOIN teams AS t
ON e.team_id = t.id 


-- Question 13. [Tough]
-- Find the first_name, last_name and salary of the lowest paid employee in Japan 
-- who works the least common full-time equivalent hours across the corporation.”

-- Hint
-- You will need to use a subquery to calculate the mode


SELECT fte_hours, count(*)
FROM employees 
WHERE country = 'Japan'
GROUP BY fte_hours 


SELECT e.first_name , e.last_name , e.salary 
FROM employees AS e
WHERE country = 'Japan' AND fte_hours = '0.75' AND salary IS NOT NULL
ORDER BY salary ASC
LIMIT 1

-- Question 14.
-- Obtain a table showing any departments in which 
-- there are two or more employees lacking a stored first name. 
-- Order the table in descending order of the number of employees 
-- lacking a first name, and then in alphabetical order by department.



SELECT department, count(*)
FROM employees  
WHERE first_name IS NULL
GROUP BY department 
HAVING count(*) > 1
ORDER BY department 


-- Question 15. [Bit tougher]
-- Return a table of those employee first_names shared by more than one employee, 
-- together with a count of the number of times each first_name occurs. 
-- Omit employees without a stored first_name from the table. 
-- Order the table descending by count, and then alphabetically by first_name.


SELECT first_name AS non_distinct_name, count(*) AS name_occurs
FROM employees
WHERE first_name IS NOT NULL
GROUP BY first_name 
HAVING count(first_name) > 1


-- Question 16. [Tough]
-- Find the proportion of employees in each department who are grade 1.

-- Hints
-- Think of the desired proportion for a given department as 
-- the number of employees in that department who are grade 1, 
-- divided by the total number of employees in that department.


-- You can write an expression in a SELECT statement, 
-- e.g. grade = 1. This would result in BOOLEAN values.


-- If you could convert BOOLEAN to INTEGER 1 and 0, you could sum them. 
-- The CAST() function lets you convert data types.


-- In SQL, an INTEGER divided by an INTEGER yields an INTEGER. 
-- To get a REAL value, you need to convert the top, 
-- bottom or both sides of the division to REAL.


SELECT 
    count(id) AS total,
    sum(CAST(grade = 1 AS int)) AS total_grade_1,
    CAST(sum(CAST(grade = 1 AS int)) AS REAL) / CAST(count(id) AS REAL) AS proportion
FROM employees 
GROUP BY Department





-- find the total of people who are grade 1 for each department
-- divide that by the number of people in the department



