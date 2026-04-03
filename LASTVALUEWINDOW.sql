CREATE TABLE overtime (
    employee_name VARCHAR(50) NOT NULL,
    department VARCHAR(50) NOT NULL,
    hours INT NOT NULL,
     PRIMARY KEY (employee_name,department)
);
INSERT INTO overtime(employee_name, department, hours)
VALUES('Diane Murphy','Accounting',37),
('Mary Patterson','Accounting',74),
('Jeff Firrelli','Accounting',40),
('William Patterson','Finance',58),
('Gerard Bondur','Finance',47),
('Anthony Bow','Finance',66),
('Leslie Jennings','IT',90),
('Leslie Thompson','IT',88),
('Julie Firrelli','Sales',81),
('Steve Patterson','Sales',29),
('Foon Yue Tseng','Sales',65),
('George Vanauf','Marketing',89),
('Loui Bondur','Marketing',49),
('Gerard Hernandez','Marketing',66),
('Pamela Castillo','SCM',96),
('Larry Bott','SCM',100),
('Barry Jones','SCM',65);

select * from overtime;

select *,first_value(employee_name) over (order by hours ) as least_hour from overtime;

select *,first_value(employee_name) over (partition by department order by hours) as least_hour from overtime;

select *,last_value(employee_name) over 
(order by hours range between unbounded preceding and unbounded following) as highest_hour from overtime;

select *,last_value(employee_name) over (partition by department order by hours
 range between unbounded preceding and unbounded following) as highest_hour from overtime;

#wasq to fetch each customers order along with their latest order date(cno,orderno,orderdate).
select customernumber,ordernumber,orderdate,last_value(orderdate) over
 (partition by customernumber order by orderdate range between unbounded preceding and unbounded following)
as latestorderdate from customers join orders using(customernumber) ;

#show each payment along with last payment amount.
select customername,amount,last_value(amount) over (order by paymentdate range between unbounded preceding and unbounded following)
as latest_pay_amount from payments join customers using(customernumber);

#show all the products of an order along with the last product code in that order.
select ordernumber,productname,productcode,last_value(productcode) over
(partition by ordernumber range between unbounded preceding and unbounded following) as Last_product_code from products join
orderdetails using(productcode) join orders using(ordernumber);

#wasq that shows cumulative sales per customer by orderdate
select customernumber,orderdate,sum(quantityordered*priceeach) over 
(partition by customernumber order by orderdate rows between unbounded preceding and current row) as cumulativesales
from customers join orders using(customernumber) join orderdetails using(ordernumber);

#for each customer calculate the avg of last 3 orders (including current)
select customernumber,orderdate,avg(quantityordered*priceeach) over 
(partition by customernumber order by orderdate rows between 2 preceding and current row) as avgsales
from customers join orders using(customernumber) join orderdetails using(ordernumber);


#wasq that track last 2 payments plus current payment per customer by paymentdate
select customernumber,paymentdate,sum(amount) over (partition by customernumber order by paymentdate rows between 2 preceding and current row)
as totalpay from payments;

#wasq to fetch second and third highest sold product of each productline
with cte as (select productline,productname,sum(quantityordered*priceeach) as sales,
dense_rank() over(partition by productline order by sum(quantityordered*priceeach) desc) as productrank from products
join orderdetails using(productcode) group by 1,2)select * from cte where productrank in(2,3);

#with subquery
select productline,productname,productrank from
(select productline,productname,sum(quantityordered*priceeach) as sales,
dense_rank() over(partition by productline order by sum(quantityordered*priceeach) desc) as productrank from products
join orderdetails using(productcode) group by 1,2) as highest_selling_product 
where productrank in(2,3);

#wasq to fetch employees name who located in the usa 
select concat(firstname," ",lastname) as empfullname from employees
where officeCode in (select officeCode from offices where country="USA");

#wasq to fetch customername who as the highest payment (customerno,checkno,amount)
select customername,customernumber,checknumber,amount from
(select customerNumber,checkNumber,amount,dense_rank() over ( order by amount desc) as crank from
 payments group by 1,2) as highestpay join customers using(customernumber)  where crank in (1);

#find the customer whose payment are greater than average payment
select customername from customers where customerNumber in
(select customernumber from payments where amount>(select avg(amount) from payments));

#find the customer who have not placed any order using subquery
select customername from customers where customerNumber not in(
select customernumber from orders);

#wasq to fetch cx who bought products in 2003 into 3 groups platinum 100k gold(btw 10 to 100) and
 #silver(< 10k) return cx grp and no. of cx in each group?
 select customername,amount,customergroup from
 (select customername,amount,dense_rank() over (order by amount desc) as payrank,if(amount>100000,"platinum",if(amount>=10000,"gold","silver"))
 as customergroup from customers join payments using(customernumber) where year(paymentdate)=2003) as cgroup ;
 
 # wasq to fetch top 5 products by total sales in year 2003 also fetch the productname?
 select productname, ts , productrank , pyear from
 (
 select productname, sum(quantityordered*priceeach) as ts , year(orderdate) as pyear ,
 dense_rank() over ( order by sum(quantityordered*priceeach )desc)
 as productrank
 from products p inner join orderdetails od using (productcode) inner join orders o
 using(ordernumber)
  group by 1 , 3
  having pyear in  (2003)
 ) as d1
 where productrank<=5 ;
 