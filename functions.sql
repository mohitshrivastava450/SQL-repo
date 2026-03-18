#date,maths and string functions are in group by file

#wasq to fetch 3 and 4 highest credit limit customer(cno,cname,address)
select customernumber,concat(contactfirstname," ",contactlastname) as fullname,creditlimit from customers
order by creditLimit desc limit 2 offset 2;

#wasq to fetch empno,ename,jobtitle and officecode only 1,2,3,4 lastname end with son order byfirstname in alpha order
select employeenumber,concat(firstname," ",lastname) as empfullname,jobtitle,officecode
from employees where officeCode in(1,2,3,4) and lastname like "%son" order by firstname;

#wasq to fetch cname,total order value of each productline in 2003, 2004 sort by order year
select customername,sum(quantityordered*priceeach) as tov,productline
from customers
join orders using(customernumber)  join orderdetails using(ordernumber) join products using(productcode)
where year(orderdate) in (2003,2004) group by customerName,productLine;

create table sales1(sales_employee varchar(50) not null,fiscal_year int not null,sale decimal(14,2) not null,primary key(sales_employee,fiscal_year));

insert into sales1(sales_employee,fiscal_year,sale)
values('Bob',2016,100),('Bob',2017,150),('Bob',2018,200),
('Alice',2016,150),('Alice',2017,100),('Alice',2018,200),
('John',2016,200),('John',2017,150),('John',2018,250);
select * from sales1;

#min,max,sum

select  * sum (sale ) over (partition by fiscal_year) as ts,
    max(sale ) over (partition by fiscal_year) as max_sale,
     sum (sale ) over (partition by fiscal_year) as min_sale,
      sum (sale ) over (partition by fiscal_year) as ts,
       sum (sale ) over (partition by fiscal_year) as ts;
   
   
   
   
   #wasq to fetch total ordervalue by each productline using window function;
   
   select  productline ,sum(quantityordered*priceeach) over (partition by productline) as total_ordervalue 
   from orderdetails od inner join products p using (productcode);
   
   # wasq to fetch avg msrp of each productline;
   # also fetch max , min msrp using window
   select productline ,avg(msrp) over (partition by productline) as avg_msrp,
   min(msrp) over (partition by productline) as min_msrp,
   max(msrp) over (partition by productline) as max_msrp 
   from products;
   
   #Row Number
   
   #wasq to fetch top 5 high performance product by each product category 
   #(to find the top 5 products by productline that have  the highest inventry)
   
   with inventory as (select productline , productname , quantityinstock, 
   row_number() over (partition by productline 
   order by quantityinstock desc) as r_n from products)
   select * from inventory where r_n <=5;
   
   create table t (id int primary key auto_increment , name varchar(50));
   start transaction;
   insert into T(NAME) values ("a"),("b"),("b"),("c"),("c"),("c"),("d");
   select * from t;
   rollback;
   START transaction;
with duplicate as(
select id,name,row_number() over (partition by name order by id asc) as r_n
from t)
delete from t using t inner join duplicate
on t.id=duplicate.id
where r_n>1;

set @num=0;
set sql_safe_updates=0;
update t set id=@num:=@num+1;

#dense rank

#wasq to rank sales employees by sales amount every year
select *,dense_rank() over (partition by fiscal_year order by sale desc) as dr from sales1;

#wasq to find top 3 customers who have placed most order display cname and count of order placed
with cte as(select customername,dense_rank() over (order by count(*) desc) as crank,
count(*) as ordercount from customers join orders using(customernumber) join orderdetails using(ordernumber) group by customername)
select * from cte where crank<=3;

#retreive a product that has been ordered the least number of times display the product code, product name and the no. of times it has been ordered
with cte as (select productcode,productname,dense_rank() over (order by count(*) asc) as orank,count(*) as ordercount from orderdetails
 join products using(productcode)
group by 1,2)select * from cte where orank=1;

#retreive top 5 customers along with their tov across all order
with cte as(select customername,sum(quantityordered*priceeach) as totalordervalue,
dense_rank() over (order by sum(quantityordered*priceeach) desc) as crank
from customers join orders using(customernumber) join orderdetails using(ordernumber) group by 1)
select * from cte where crank<=5;

#wasq to fetch total order value of combination of each productline and each year(top 3 product)
with cte as(select productline,year(orderdate) as orderyear,productName,
dense_rank() over (partition by productline,year(orderdate) order by sum(quantityordered*priceeach) desc) as crank,sum(quantityOrdered*priceeach)
as totlordervalue
from orderdetails join products using(productcode) join orders using(ordernumber) group by 1,2,3)
select * from cte where crank<=3;

#Percent Rank

#wasq to fetch total order value of each productline 
select productline,sum(quantityordered*priceeach) as totalordervalue,
round(percent_rank() over ( order by sum(quantityordered*priceeach) asc),2) as prank
 from orderdetails
join products using(productcode) group by 1;

#wasq to fetch percent rank of product lines by  order value in each year
select productline,year(orderdate) as orderyear,sum(quantityordered*priceeach) as totalordervalue,
round(percent_rank() over  (partition by year(orderdate) order by sum(quantityordered*priceeach) ),2) as prank from orderdetails
join products using(productcode) join orders using(ordernumber) group by 1,2;

#value window function
#lag function
#lag(colname/expression,offset,default-value) over ()

#wasq to compare sales of a year with previous one of each employee
select *,lag(sale,1,0) over (partition by sales_employee order by fiscal_year asc) as previous_sale from sales1;

#find sales difference of current and previous year
with sales_difference as(select *,lag(sale,1,0) over (partition by sales_employee order by fiscal_year asc) as previous_sale from sales1)
select *,sale-previous_sale as sale_diff  from sales_difference;

#find percent of sales difference
with sales_difference as(select *,lag(sale,1,0) over (partition by sales_employee order by fiscal_year asc) as previous_sale from sales1)
select *,sale-previous_sale as sale_diff,((sale-previous_sale)/previous_sale)*100  from sales_difference;

#wasq to compare total order value of each productline of each year  with previous one
select productline,year(orderdate) as orderyear,sum(quantityordered*priceeach) as totalorddervalue,lag(sum(quantityordered*priceeach),1,0)
over (partition by productline order by year(orderdate) asc ) as previous_tov from products join orderdetails
 using(productcode) join orders using(ordernumber) group by 1,2;
 
 #For each customer’s order, find the order amount along with the previous order’s amount.
 select customernumber,ordernumber,orderdate,amount,lag(amount,1,0) 
 over (partition by customerNumber order by orderdate asc) as previousorderamount from customers join orders using(customernumber) join payments
 using(customernumber) group by 1,2,3,4;

#For each order, show the order date and the previous order date of the same customer.
select customernumber,ordernumber,orderdate,lag(orderdate,1,0) over (partition by customerNumber order by orderdate asc) as previousorderdate
from  orders group by 1,2;

#For each payment, display the payment amount and the previous payment amount made by that customer.
select customernumber,paymentDate,amount,lag(amount,1,0) over (partition by customernumber order by paymentDate asc) as previouspaymentdate
from payments group by 1,2,3;

#lead
#For each order, find the order date and the next order date of the same customer.
select customernumber,ordernumber,orderdate,lead(orderdate,1,0) over (partition by customernumber order by orderdate asc)
as nextdate from customers join orders using(customernumber) group by 1,2;

#For each customer, show the order value and the next order’s value.
select customernumber,ordernumber,orderdate,quantityordered*priceeach as ordervalue,lead(quantityordered*priceeach,1,0)
 over (partition by customernumber order by orderdate asc)as nextordervalue from customers join orders using(customernumber)
 join orderdetails using(ordernumber) ;


#For each payment, display the payment amount and the next payment amount made by that customer.
select customernumber,paymentDate,amount,lead(amount,1,0) over (partition by customernumber order by paymentdate asc) as nextpayment
from customers join payments using(customernumber)  ;


#FIRST_VALUE – Practice Questions

#For each order, show the order date along with the first purchase date of that customer.
select customernumber,ordernumber,orderdate,first_value(orderdate) over (partition by customernumber order by orderdate asc) as firstpdate
from customers join orders using(customernumber) ;

#For each customer, list the orders along with the first product they ever ordered.
select customernumber,orderdate,productname,first_value(productname) over (partition by customernumber order by orderdate asc) as firstorder
from customers join orders using(customernumber) join orderdetails using(ordernumber) join products using(productcode);

#For each payment, show the payment amount along with the first payment amount of that customer
select customernumber,paymentdate,amount,first_value(amount) over (partition by customernumber order by paymentdate asc) as firstpayment
from customers join payments using(customernumber); 

#NTILE FUNCTION
#wasq to divide the total sales by productline in each year into 3 groups.
with cte as(select productline,year(orderdate) as orderyear,sum(quantityordered*priceeach) as totalsales from orders
join orderdetails using(ordernumber) join products using(productcode) group by 1,2)
select *,ntile(3) over (partition by  orderyear ) as ntilefunc  from cte ;




 