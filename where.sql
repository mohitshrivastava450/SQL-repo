#where clause
#for filtering record
#select columnlist from tablename
#where search condition
#order by column;

#from --- where ---- select ---- order by

#wasq to fetch customer's detail?
select * from customers;
#for 'usa' data with equality operator =
select * from customers where country ="usa";
select employeenumber,concat(firstname," ",lastname) as employeefullname, jobtitle,officecode from employees where officeCode=1;
select * from customers where creditLimit>5000;
select ordernumber,quantityordered*priceeach as ordervalue from orderdetails where quantityordered*priceeach<=4000 order by ordervalue desc;

#AND OR Logical operators

#fetching empdetails whose officecode is 1 and jobtitle is salesrep;
select * from employees 
where officecode =1 and jobTitle="sales rep"; 
select * from employees 
where officecode =1 or jobTitle="sales rep"; 
#fetching empno,empfullname,officecode,jobtitle of officecode 1,2 and 3
select employeenumber,concat(firstname," ",lastname) as fullname,officecode,jobtitle from employees
where officeCode=1 or officeCode=2 or officeCode=3;

#BETWEEN lowvalue AND highvalue (both low and high are inclusive)
 
 select employeenumber,concat(firstname," ",lastname) as fullname,officecode,jobtitle from employees
where officeCode between 1 and 3;

#IN 
select employeenumber,concat(firstname," ",lastname) as fullname,officecode,jobtitle from employees
where officeCode in (1,3,5);

select * from customers where country in ("usa","japan","france");
select * from orders;
select orderdate,ordernumber,status from orders where orderDate between "2004-01-01" and "2005-12-31";
select * from employees where officecode in (1,2,3) and jobtitle="sales rep";
select * from employees where reportsTo is null;
select customername,customernumber,city,country,creditlimit from customers 
where creditLimit>5000 order by contactLastName,contactFirstName desc;
select * from employees where officeCode not in (1,3);

#distinct (fetches distinct values)
select distinct status from orders;
select distinct country from customers ;

#Like Operators - % and _
#where columnname like pattern
#pattern examples - for startwith  "a%", for end with "%a",for start and end "a%t",for in between "%a%"
#for no. of characters "a__%" (2 characters after a)

select concat(firstname," ",lastname) as empfullname from employees where firstName like "t_m";
select customername from customers where customerName like "%n";
select productname from products where productName like "%1900%";
select customername from customers where customerName like   "%a" or customerName like "%e" or customerName like "%i"
 or customerName like "%o" or customerName like "%u";
 select ordernumber,orderdate,status from orders where orderDate like "2003%" or orderDate like "2004%"  order by orderDate desc;
 
 #limit (for fetching limited records)
 select customername,customernumber,city,country from customers limit 10;
 
 #wasq to fetch customernumber,customername,country and creditlimit from customers (top 3 highest credit limit)
 select customername,customernumber,country,creditlimit from customers order by creditlimit desc limit 3 offset 0;
 
 
 


