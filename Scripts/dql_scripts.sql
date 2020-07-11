############# DQL ###############
### Syntax:
#
# SELECT [ ALL | DISTINCT ]  { * | col_name ,... | aggFun(col_name) }
# FROM table_name alias ,...
#     [ WHERE expr1 ]
#     [ CONNECT BY expr2 [START WITH expr3 ]]
# 	  [ GROUP BY expr4 ] [ HAVING expr5 ]
# 	  [ UNION | INTERSECT | MINUS SELECT …. ]
#     [ ORDER BY expr6 | ASC | DSC ]
#
# * SELECT and FROM are mandatory

SELECT city from customers;

SELECT DISTINCT(city) from customers;

SELECT productLine from products order by productLine;

SELECT productLine, productName from products order by productLine ASC, productName desc ;

# “I need to know which the name and phone number of the customer who are based of Melbourne”
# Select  name and phone number of customer except those based in ‘Melbourne’
SELECT customerName , phone , city from customers where city <> 'Melbourne';

# Select name and phone number of customer who are from ‘Melbourne’
SELECT customerName , phone, city from customers  where city='Melbourne';

# “I need to know which customer bought the vehicles for the following 2005 dates: May 18, April 03, and May 30.”
describe customers;
SELECT orderNumber, customerNumber, orderDate FROM orders WHERE orderDate IN ('2005-05-18', '2005-04-03','2005-05-30');

# “Show me a list of all the orders we’ve taken, except for those posted in October.”
# Select order number and order date from the orders table where the order date does not fall between October 1, 2004, and October 31, 2004
SELECT orderNumber , orderDate from orders where orderDate NOT BETWEEN '2004-10-01' AND '2004-10-31';

# “Which customer do not yet have a assigned with the Sales Representative ? ”
# select a customers from customers table whose salesRepEmployeeNumber is empty
SELECT customerName from customers where salesRepEmployeeNumber IS NULL;

# “I need the identification numbers of all people working in the company who are not VPs ”
# Select employeeNumber and title from the faculty table where the title is not ‘VP’
SELECT DISTINCT(jobTitle) from employees;
SELECT employeeNumber from employees where jobTitle NOT IN ('VP Sales','VP Marketing');
SELECT employeeNumber from employees where jobTitle NOT LIKE '%VP%' ;

# “How many customers were able to indicate which county they live in?”
SELECT COUNT(country) as NumberOfKnownCountries FROM customers;
SELECT COUNT(DISTINCT(country)) as NumberOfKnownCountries FROM customers;
SELECT 'The number of known customer countries: ', COUNT(country) from customers;

# “Show me the total number of Melbourne employees we have in our company.”
SELECT COUNT(*) FROM employees;

# “How many unique city names are there in the customers table?”
SELECT COUNT(DISTINCT city) AS NumberOfUniqueCities FROM customers ;
# SELECT DISTINCT(city) FROM customers;

# How many unique city names are there in the customers table for the country of USA?
SELECT COUNT(DISTINCT city) AS NumberOfUniqueCities FROM customers WHERE country='USA';

# “How much is our current inventory worth?”
# Select the sum of buy price times quantity on hand as TotalInventoryValue from the products table
SELECT SUM(MSRP * quantityInStock) AS TotalInventoryValue FROM products;

# “Calculate a total of all unique sale costs for the products we sell.”
# Select the sum of unique product costs as SumOfUniqueSaleCosts from the OrderDetails table
SELECT SUM(DISTINCT priceEach)  AS SumOfUniqueSaleCosts FROM orderdetails;

# “What is the average item total for order 10101?”
# Select the average of price times quantity ordered as AverageItemTotal from the order details table where order ID is 10101
SELECT orderNumber , priceEach, quantityOrdered from orderdetails where orderNumber=10101;
SELECT AVG(priceEach * quantityOrdered) AS AverageItemTotal from orderdetails where orderNumber=10101;

# “Calculate an average of all unique product prices.”
# Select the average of unique prices as UniqueProductPrices from the products table
SELECT AVG(DISTINCT priceEach) AS UniqueProductPrices FROM orderdetails;

# “What is the lowest wholesale price we charge for a product?”
# Select the minimum wholesale price as LowestProductPrice from the products table
SELECT MIN(MSRP) AS LowestProductPrice FROM products;
SELECT MAX(MSRP) AS LowestProductPrice FROM products;

# “How many different products were ordered on order number 10101, and what was the total cost of that order?”
# Select the unique count of product ID as TotalProductsPurchased and the sum of price times quantity ordered as OrderAmount from the order details table where the order number is 553

SELECT COUNT(DISTINCT productCode) AS TotalProductsPurchased,
       SUM(priceEach * QuantityOrdered) AS OrderAmount
FROM orderdetails WHERE orderNumber = 10101;

#### USING AGG functions in Filters
### Because an aggregate function returns a single value, you can use it as part of a comparison predicate in a search condition. You have to place the aggregate function within a subquery

# “List the products that have a retail price less than or equal to the overall average retail price.”
# Steps
#      1 - calculate the overall average retail price manually and then plug that specific SQL Query into a comparison predicate
#      2 - Select the product name from the products table where the retail price is less than or equal to the overall average retail price in the products table
SELECT AVG(MSRP) FROM products;
SELECT productName FROM products WHERE MSRP <= 100.438727;
SELECT productName FROM products WHERE MSRP <= (SELECT AVG(MSRP) FROM products);

############# Advanced DQL ###############
##### Aggregate Functions - Single and Multiple #####

SELECT productLine, AVG(MSRP) FROM products GROUP BY productLine;

# Expression #3 of SELECT list is not in GROUP BY clause and contains nonaggregated column 'classicmodels.products.productName' which is not functionally dependent on columns in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by
SELECT productLine, AVG(MSRP), productName FROM products GROUP BY productLine;

## ERROR - [42000][1140] In aggregated query without GROUP BY, expression #1 of SELECT list contains nonaggregated column 'classicmodels.products.MSRP'; this is incompatible with sql_mode=only_full_group_by
SELECT MSRP, AVG(MSRP) FROM products ;

## Display all the offices having more than 3 employees
SELECT officeCode, count(*) from employees group by officeCode having count(*) > 3;

## FInd Min , Max and Avg buying Price of productlines , where average buying price is greather than 50
SELECT productLine, avg(buyPrice), max(buyPrice), min(buyPrice) from products group by productLine HAVING Avg(buyPrice) > 50;

## Find Average buying price of all the products who belong to product line Motorcycles or Classic Cars and their average buyprice is greater than 50


##### Joins and SubQueries #####
# display employee number and name along with the office city to which they belong
SELECT employeeNumber, firstName, lastName, city
FROM employees , offices
WHERE employees.officeCode = offices.officeCode;

# display customer name and sales represnatative name along with the office city to which they belong
SELECT customers.customerName, employees.firstName , employees.lastname , offices.city
FROM employees , offices , customers
WHERE employees.employeeNumber = customers.salesRepEmployeeNumber AND employees.officeCode = offices.officeCode;

## what will be the statemnet look like with -  USING and ON ?? # display customer name and sales represnatative name along with the office city to which they belong

## INNER JOIN - ON
# “Show me the product name, product Line, and text description of all products in my database.”
SELECT p.productLine, productName, p.textDescription
FROM products INNER JOIN productlines p
                         ON products.productLine = p.productLine;

# If the matching columns in the two tables have the same name
SELECT p.productLine, productName, textDescription
FROM products INNER JOIN productlines p
                         USING(productLine);

## WHERE CLAUSE with JOIN
SELECT p.productLine, productName, textDescription
FROM products INNER JOIN productlines p
                         ON products.productLine = p.productLine
WHERE productName = '1972 Alfa Romeo GTA'
   OR productName = '1968 Ford Mustang';

# Embedding a SELECT Statement also called a derived table
SELECT  PR.productLine, PR.textDescription,
        RCFiltered.ClassName
FROM
    (SELECT productLine, productName AS ClassName
     FROM products AS RC
     WHERE RC.productName = '1972 Alfa Romeo GTA' OR
             RC.productName = '1968 Ford Mustang') AS RCFiltered
        INNER JOIN productlines AS PR
                   ON RCFiltered.productLine = PR.productLine;

# “Show me the names of all customers and their Order shipped date for each of those orders.”
# “List customers and the sales reepresenatuives they booked.”
# “Display sales agents and the order dates they booked for customers.”
# “Show me the orders that have Ford or chevy.”
# “Find all the customers who ordered a Ford and also ordered a chevy.”

## OUTER JOIN
# “List the products that do not yet have any html description.”
SELECT p.productname, productlines.htmlDescription
FROM productlines
         LEFT OUTER JOIN products p on productlines.productLine = p.productLine
WHERE productlines.htmlDescription IS NULL;

### Right OUTER JOIN
# “List all products and the dates for any orders.”
SELECT p.productName, o.orderNumber
FROM products p
         RIGHT OUTER JOIN orderdetails o on p.productCode = o.productCode;

# “Display all products and the order Numbers they are scheduled to be shipped.”
# “List products not ordered by any customer yet.”
# “Display customers who have no sales rep (employees) in the same ZIP Code.”
# “Display the orderLine Number that do not yet have any product shipped.”
# “List the Ford, chevy, and Alfa Romeo cars Customers and their orders.”



