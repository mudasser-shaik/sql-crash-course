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
SELECT city , phone from customers  where city='Melbourne';

# “I need to know which customer bought the vehicles for the following 2005 dates: May 18, April 03, and May 30.”
describe customers;
SELECT orderNumber, orderDate FROM orders WHERE orderDate IN ('2005-05-18', '2005-04-03','2005-05-30')

# “Show me a list of all the orders we’ve taken, except for those posted in October.”
# Select order number and order date from the orders table where the order date does not fall between October 1, 2004, and October 31, 2004
SELECT orderNumber , orderDate from orders where orderDate NOT BETWEEN '2004-10-01' AND '2004-10-31'

# “Which customer do not yet have a assigned with the Sales Representative ? ”
SELECT customerName from customers where salesRepEmployeeNumber IS NULL;

# “I need the identification numbers of all people working in the company who are not VPs ”
# Select employeeNumber and title from the faculty table where the title is not ‘VP’
SELECT DISTINCT(jobTitle) from employees;
SELECT employeeNumber from employees where jobTitle NOT IN ('VP Sales','VP Marketing');
SELECT employeeNumber from employees where jobTitle NOT LIKE '%VP%' ;

# “How many customers were able to indicate which county they live in?”
SELECT COUNT(city) as NumberOfKnownCountries FROM customers;
SELECT 'The number of known customer countries: ', COUNT(city) from customers;

# “Show me the total number of Melbourne employees we have in our company.”
SELECT COUNT(*) FROM employees;

# “How many unique city names are there in the customers table?”
SELECT COUNT(DISTINCT city) AS NumberOfUniqueCities FROM customers ;
# SELECT DISTINCT(city) FROM customers;

# How many unique city names are there in the customers table for the country of USA?
SELECT COUNT(DISTINCT city) AS NumberOfUniqueCities FROM customers WHERE country='USA';

# “How much is our current inventory worth?”
# Select the sum of buy price times quantity on hand as TotalInventoryValue from the products table
SELECT SUM(buyPrice * quantityInStock) AS TotalInventoryValue FROM products;

# “Calculate a total of all unique sale costs for the products we sell.”
# Select the sum of unique product costs as SumOfUniqueSaleCosts from the OrderDetails table
SELECT SUM(DISTINCT buyPrice)  AS SumOfUniqueSaleCosts FROM products;

# “What is the average item total for order 10101?”
# Select the average of price times quantity ordered as AverageItemTotal from the order details table where order ID is 10101
SELECT orderNumber , priceEach, quantityOrdered from orderdetails where orderNumber=10101;
SELECT AVG(priceEach * quantityOrdered) AS AverageItemTotal from orderdetails where orderNumber=10101;

# “Calculate an average of all unique product prices.”
# Select the average of unique prices as UniqueProductPrices from the products table
SELECT AVG(DISTINCT priceEach) AS UniqueProductPrices FROM orderdetails;

# “What is the lowest wholesale price we charge for a product?”
# Select the minimum wholesale price as LowestProductPrice from the products table
SELECT MIN(buyPrice) AS LowestProductPrice FROM products;
SELECT MAX(buyPrice) AS LowestProductPrice FROM products;

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
SELECT productName FROM products WHERE buyPrice <= 196.03;
SELECT productName FROM products WHERE buyPrice <= (SELECT AVG(buyPrice) FROM products);