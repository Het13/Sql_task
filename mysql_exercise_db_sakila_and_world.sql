-- SQL Practice - Part 1

-- Use “Sakila” database for the following questions

-- Q1 Display all tables available in the database “sakila” 

show tables;


-- Q2 Display structure of table “actor”. (4 row)  

desc actor;  


-- Q3 Display the schema which was used to create table “actor” and view the complete schema using the viewer. (1 row) 

show create table actor;


-- Q4 Display the first and last names of all actors from the table actor. (200 rows) 

select 
	first_name, 
    last_name 
from 
	actor;


-- Q5 Which actors have the last name ‘Johansson’. (3 rows) 

select 
	first_name 
from 
	actor 
where 
	last_name = 'JOHANSSON';


-- Q6 Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name. (200 rows) 

select 
	upper(concat(first_name, ' ', last_name)) as actor_name 
from 
	actor; 


-- Q7 You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, 
-- "Joe." What is one query would you use to obtain this information? (1 row)

select 
	actor_id, 
    	first_name, 
    	last_name 
from 
	actor 
where 
	first_name = 'JOE';

 
-- Q8 Which last names are not repeated? (66 rows)

select 
	last_name 
from 
	actor 
where 
	last_name in (
		select 
			last_name 
		from 
			actor 
		group by 
			last_name 
		having 
			count(last_name) =1
	);


-- Q9 List the last names of actors, as well as how many actors have that last 

select 
	last_name,
    count(last_name) as count
from 
	actor 
group by 
	last_name;


-- Q10 Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables “staff” and “address”. (2 rows)

select 
	staff.first_name, 
	staff.last_name, 
    address.address 
from 
	staff 
	inner join address on staff.address_id = address.address_id;





-- Use “world” database for the following questions
 
-- Q1 Display all columns and 10 rows from table “city”.(10 rows) 

select * from city LIMIT 10;


-- Q2 Modify the above query to display from row # 16 to 20 with all columns. (5 rows) 

select * from city LIMIT 5 OFFSET 16;


-- Q3 How many rows are available in the table city. (1 row)-4079. 

select count(*) from city;


-- Q4 Using city table find out which is the most populated city. 
-- ('Mumbai (Bombay)', '10500000') 

select 
	name, 
	population 
from 
	city 
where 
	population = (
		select 
			max(population) 
		from 
			city
		);


-- Q5 Using city table find out the least populated city. 
-- ('Adamstown', '42') 

select 
	name, 
    population 
from 
	city 
where 
	population = (
		select 
			min(population) 
		from 
			city
		);


-- Q6 Display name of all cities where population is between 670000 to 700000. (13 rows) 

select 
	name 
from 
	city 
where 
	population between 670000 and 700000;


-- Q7 Find out 10 most populated cities and display them in a decreasing order i.e. most populated city to appear first. 

select 
	name 
from 
	city 
order by 
	population desc 
limit 10;


-- Q8 Order the data by city name and get first 10 cities from city table. 

select 
	name 
from 
	city 
order by 
	name 
limit 10;


-- Q9 Display all the districts of USA where population is greater than 3000000, from city table. (6 rows)

select 
	district 
from 
	city 
where 
	CountryCode = 'USA' 
    and population >= 3000000;

 
-- Q10 What is the value of name and population in the rows with ID =5, 23, 432 and 2021. Pl. write a single query to display the same. (4 rows). 

select 
	name, 
    population 
from 
	city 
where 
	id in (5, 23, 432, 2021); 



-- SQL Practice – Part 2

-- Use “Sakila” database for the following questions

-- Q1 Which actor has appeared in the most films? (‘107', 'GINA', 'DEGENERES', '42') 

select 
	actor.actor_id,
	actor.first_name,
	actor.last_name,
	count(film_actor.actor_id) 
from 
	film_actor 
   	inner join actor where actor.actor_id = film_actor.actor_id
group by 
	film_actor.actor_id 
order by 
	count(film_actor.actor_id) desc 
limit 1;

	
-- Q2 What is the average length of films by category? (16 rows) 

select 
	category_id, 
	avg(length) as avg_length
from 
	film_category 
	join film on film.film_id = film_category.film_id 
group by 
	category_id 
order by 
	avg(length);


-- Q3 Which film categories are long? (5 rows) 

select 
	sum(film.length) as Length,
    category.name
from
	film
    inner join film_category on film_category.film_id = film.film_id
    inner join category on category.category_id = film_category.category_id
group by 
	category.name
order by 
	sum(film.length) desc
limit 5;


-- Q4 How many copies of the film “Hunchback Impossible” exist in the inventory system? (6) 

select 
	count(film_id) 
from 
	inventory 
group by 
	film_id 
having 
	film_id in(
		select film_id from film where title = 'Hunchback Impossible'
	);


-- Q5 Using the tables “payment” and “customer” and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name (599 rows) 

select 
	sum(payment.amount) as total_paid,
	concat(customer.first_name, ' ' , customer.last_name) as name
from 
	customer
	inner join payment on payment.customer_id = customer.customer_id
group by
	name
order by
	name;


-- Use “world” database for the following questions 

-- Q1 Write a query in SQL to display the code, name, continent and GNP for all the countries whose country name last second word is 'd’, using “country” table. (22 rows) 

select 
	code, 
    name, 
    continent, 
    gnp 
from 
	country 
where 
	name like "%d_";


-- Q2 Write a query in SQL to display the code, name, continent and GNP of the 2nd and 3rd highest GNP from “country” table. (Japan & Germany) 

select 
	code, 
    name, 
    continent, 
    gnp 
from 
	country 
order by 
	gnp desc 
limit 2 offset 1;



-- Execute the following commands to create 2 new tables and insert records 
-- 
-- Table structure for table `departments` 
-- 
CREATE TABLE IF NOT EXISTS `departments` ( 
`DEPARTMENT_ID` decimal(4,0) NOT NULL DEFAULT '0', 
`DEPARTMENT_NAME` varchar(30) NOT NULL, 
`MANAGER_ID` decimal(6,0) DEFAULT NULL, 
`LOCATION_ID` decimal(4,0) DEFAULT NULL, 
PRIMARY KEY (`DEPARTMENT_ID`), 
KEY `DEPT_MGR_FK` (`MANAGER_ID`), 
KEY `DEPT_LOCATION_IX` (`LOCATION_ID`) 
) ; 
-- 
-- Dumping data for table `departments` 
-- 
INSERT INTO `departments` (`DEPARTMENT_ID`, `DEPARTMENT_NAME`, `MANAGER_ID`, `LOCATION_ID`) VALUES 
('10', 'Administration', '200', '1700'), 
('20', 'Marketing', '201', '1800'), 
('30', 'Purchasing', '114', '1700'), 
('40', 'Human Resources', '203', '2400'), 
('50', 'Shipping', '121', '1500'), 
('60', 'IT', '103', '1400'), 
('70', 'Public Relations', '204', '2700'), 
('80', 'Sales', '145', '2500'), 
('90', 'Executive', '100', '1700'), 
('100', 'Finance', '108', '1700'), 
('110', 'Accounting', '205', '1700'), 
('120', 'Treasury', '0', '1700'), 
('130', 'Corporate Tax', '0', '1700'), 
('140', 'Control And Credit', '0', '1700'), 
('150', 'Shareholder Services', '0', '1700'), 
('160', 'Benefits', '0', '1700'), 
('170', 'Manufacturing', '0', '1700'), 
('180', 'Construction', '0', '1700'), 
('190', 'Contracting', '0', '1700'), 
('200', 'Operations', '0', '1700'), 
('210', 'IT Support', '0', '1700'), 
('220', 'NOC', '0', '1700'), 
('230', 'IT Helpdesk', '0', '1700'), 
('240', 'Government Sales', '0', '1700'), 
('250', 'Retail Sales', '0', '1700'), 
('260', 'Recruiting', '0', '1700'), 
('270', 'Payroll', '0', '1700'); 
-- -------------------------------------------------------- 


-- Table structure for table `employees` 
-- 
CREATE TABLE IF NOT EXISTS `employees` ( 
`EMPLOYEE_ID` decimal(6,0) NOT NULL DEFAULT '0', 
`FIRST_NAME` varchar(20) DEFAULT NULL, 
`LAST_NAME` varchar(25) NOT NULL, 
`EMAIL` varchar(25) NOT NULL, 
`PHONE_NUMBER` varchar(20) DEFAULT NULL, 
`HIRE_DATE` date NOT NULL, 
`JOB_ID` varchar(10) NOT NULL, 
`SALARY` decimal(8,2) DEFAULT NULL, 
`COMMISSION_PCT` decimal(2,2) DEFAULT NULL, 
`MANAGER_ID` decimal(6,0) DEFAULT NULL, 
`DEPARTMENT_ID` decimal(4,0) DEFAULT NULL, 
PRIMARY KEY (`EMPLOYEE_ID`), 
UNIQUE KEY `EMP_EMAIL_UK` (`EMAIL`), 
KEY `EMP_DEPARTMENT_IX` (`DEPARTMENT_ID`), 
KEY `EMP_JOB_IX` (`JOB_ID`), 
KEY `EMP_MANAGER_IX` (`MANAGER_ID`), 
KEY `EMP_NAME_IX` (`LAST_NAME`,`FIRST_NAME`) 
) ; 
-- 
-- Dumping data for table `employees` 
-- 
INSERT INTO `employees` (`EMPLOYEE_ID`, `FIRST_NAME`, `LAST_NAME`, `EMAIL`, `PHONE_NUMBER`, `HIRE_DATE`, `JOB_ID`, `SALARY`, `COMMISSION_PCT`, `MANAGER_ID`, `DEPARTMENT_ID`) VALUES 
('100', 'Steven', 'King', 'SKING', '515.123.4567', '1987-06-17', 'AD_PRES', '24000.00', '0.00', '0', '90'), 
('101', 'Neena', 'Kochhar', 'NKOCHHAR', '515.123.4568', '1987-06-18', 'AD_VP', '17000.00', '0.00', '100', '90'), 
('102', 'Lex', 'De Haan', 'LDEHAAN', '515.123.4569', '1987-06-19', 'AD_VP', '17000.00', '0.00', '100', '90'), 
('103', 'Alexander', 'Hunold', 'AHUNOLD', '590.423.4567', '1987-06-20', 'IT_PROG', '9000.00', '0.00', '102', '60'), 
('104', 'Bruce', 'Ernst', 'BERNST', '590.423.4568', '1987-06-21', 'IT_PROG', '6000.00', '0.00', '103', '60'), 
('105', 'David', 'Austin', 'DAUSTIN', '590.423.4569', '1987-06-22', 'IT_PROG', '4800.00', '0.00', '103', '60'), 
('106', 'Valli', 'Pataballa', 'VPATABAL', '590.423.4560', '1987-06-23', 'IT_PROG', '4800.00', '0.00', '103', '60'), 
('107', 'Diana', 'Lorentz', 'DLORENTZ', '590.423.5567', '1987-06-24', 'IT_PROG', '4200.00', '0.00', '103', '60'), 
('108', 'Nancy', 'Greenberg', 'NGREENBE', '515.124.4569', '1987-06-25', 'FI_MGR', '12000.00', '0.00', '101', '100'), 
('109', 'Daniel', 'Faviet', 'DFAVIET', '515.124.4169', '1987-06-26', 'FI_ACCOUNT', '9000.00', '0.00', '108', '100'), 
('110', 'John', 'Chen', 'JCHEN', '515.124.4269', '1987-06-27', 'FI_ACCOUNT', '8200.00', '0.00', '108', '100'), 
('111', 'Ismael', 'Sciarra', 'ISCIARRA', '515.124.4369', '1987-06-28', 'FI_ACCOUNT', '7700.00', '0.00', '108', '100'), 
('112', 'Jose Manuel', 'Urman', 'JMURMAN', '515.124.4469', '1987-06-29', 'FI_ACCOUNT', '7800.00', '0.00', '108', '100'), 
('113', 'Luis', 'Popp', 'LPOPP', '515.124.4567', '1987-06-30', 'FI_ACCOUNT', '6900.00', '0.00', '108', '100'),

('114', 'Den', 'Raphaely', 'DRAPHEAL', '515.127.4561', '1987-07-01', 'PU_MAN', '11000.00', '0.00', '100', '30'), 
('115', 'Alexander', 'Khoo', 'AKHOO', '515.127.4562', '1987-07-02', 'PU_CLERK', '3100.00', '0.00', '114', '30'), 
('116', 'Shelli', 'Baida', 'SBAIDA', '515.127.4563', '1987-07-03', 'PU_CLERK', '2900.00', '0.00', '114', '30'), 
('117', 'Sigal', 'Tobias', 'STOBIAS', '515.127.4564', '1987-07-04', 'PU_CLERK', '2800.00', '0.00', '114', '30'); 

-- Q1 Write a query to display Employee id and First Name of an employee whose dept_id = 100. (Use:Sub-query)(6 rows) 

select 
	EMPLOYEE_ID, 
	FIRST_NAME 
from 
	employees 
where 
	DEPARTMENT_ID in (
		select DEPARTMENT_ID from employees where DEPARTMENT_ID = 100
    );


-- Q2. Write a query to display the dept_id, maximum salary, of all the departments whose maximum salary is greater than the average salary. (USE: SUB-QUERY) (11 rows)

select 
	department_id,
	max(salary) as maximum_salary
from employees 
group by department_id 
having 
	max(salary) >(
		select avg(salary) from employees 
        );


 
-- Q3 Write a query to display department name and, department id of the employees whose salary is less than 35000. .(USE:SUB-QUERY)(11 rows) 

select 
	department_name, 
	department_id 
from departments 
where 
	department_id in (
		select department_id from employees where salary<35000
	);
