select distinct status from orders;

# Group by

select status,count(*) from orders group by status;

 select status,count(*) as ordercount
 from orders group by status;
 
 select customername,count(*) as ordercount from customers c 
 join orders o on  c.customerNumber=o.customerNumber group by customerName
 order by ordercount desc;
 
 select ordernumber,sum(quantityordered*priceeach) as totalordervalue from orderdetails
 group by orderNumber order by totalordervalue desc;
 
 select pl.productline,sum(od.quantityordered*od.priceeach) as totalordervalue from orderdetails od join products p
 on od.productCode=p.productCode join productlines pl on p.productLine=pl.productLine group by productLine;
 
 select productname,count(*) as count from products group by productname;
 
 select concat(firstname," ",lastname)  as empfullname,count(*) as customercount from employees e join customers c
 on e.employeeNumber=c.salesRepEmployeeNumber group by empfullname;
 
 select  concat(e.firstname," ",e.lastname)  as empfullname,sum(p.amount)as totalsales from employees e join customers c
 on e.employeenumber=c.salesrepemployeenumber join payments p on c.customernumber=p.customernumber
 group by empfullname;
 
 select productline,year(orderdate) as orderyear,sum(quantityordered*priceeach) as totalordervalue from orders  join
 orderdetails using(ordernumber) join products  using(productcode) group by productLine,orderyear;
 
 select year(orderdate) as orderyear,sum(quantityordered*priceeach) as totalsales
 from orders join orderdetails
 using(ordernumber)
 group by orderyear;
 
 select year(orderdate) as orderyear,status,sum(quantityordered*priceeach) as totalsales
 from orders join orderdetails using(ordernumber) group by orderyear,status;
 
 select count(*) as totalorder,year(orderdate) as orderyear from orders 
 group by orderyear;
 
 #wasqtf cxname & total amounnt paid
 select customername,sum(amount) from customers join payments using(customernumber)
 group by customername;
 
 #WASQ to fetch order no.,no. of items sold per order and total sales for each order from orderdetails table.
 select ordernumber,sum(quantityordered) as number_of_items,sum(quantityordered*priceeach)
as total_sales from orderdetails group by ordernumber;

#having
#find orders that have total sales > 10000 AND contain more than 500 items
select ordernumber,sum(quantityordered) as number_of_items,sum(quantityordered*priceeach)
as total_sales from orderdetails group by ordernumber
having total_sales>10000 and number_of_items>500;

 #wasq to find customer name and their order count only fetch the records who have placed more than 4 order
 select customername,count(*) as ordercount from customers join orders using(customernumber)
 group by customername having ordercount>4 order by ordercount desc;
 
 #rollup
 
 #wasq to get total order value  by productline of each year
 #creating new table with the help of select command
 create table sales
 select productLine,sum(quantityordered*priceeach) as totalordervalue,year(orderdate) as orderyear from orderdetails join products
 using(productcode) join orders using(ordernumber) group by productLine,orderyear;
 
select * from sales;

#rollup--provides aggregate values

select productline,year(orderdate) as orderyear,sum(quantityordered*priceeach) as totalordervalue
from orderdetails join products using(productcode) join orders using (ordernumber) group by productLine,orderyear
union select "grandtotal","",sum(quantityordered*priceeach)  from orderdetails;

select productline,year(orderdate) as orderyear,sum(quantityordered*priceeach) as totalordervalue
from orderdetails join products using(productcode) join orders using (ordernumber) group by productLine,orderyear
with rollup;

#wasq to calculate avg buy price of all products
select avg(buyprice) as avgbuyprice from products;
#wasq to calculate avg buy price for each productline
select productline,avg(buyprice) as avgbuyprice from products group by productline;
#wasq to get no. of products for each productline
select productline,count(*) as no_of_products from products group by productLine;
#wasq to fetch total order value of each product
select productname,sum(quantityordered*priceeach) as totalordervalue from orderdetails join products using(productcode) group by productName;
#wasq to get highest price per product line and also fetch minimum
select productLine,max(buyprice) as highestprice,min(buyprice) as lowestprice from products group by 1;
#wasq to fetch sales staff name and the list of customers that each sales staff is incharge of
select concat(firstname,' ',lastname) as staff_name,group_concat( distinct customerName order by customerName desc separator "/") from employees 
join customers on employeeNumber=salesRepEmployeeNumber
group by staff_name;

#wasq to get cxname and their country
select country,group_concat( distinct customerName order by customerName desc separator "/") as customername from customers group by country;

#wasq to get empname and their job title on basis of jobtitle groupconcat empname
select jobtitle,group_concat(concat(firstname," ",lastname)) as empname  from employees group by jobTitle; 
#wasq to get cxname and their totalordervalue in 2004
select customername,sum(quantityordered*priceeach) as totalordervalue from customers join orders using(customernumber)
join orderdetails using(ordernumber) where orderDate like "2004%" group by  customerName;
#wasq to get cname who have salesrep but have not placed any order
select customername from customers   join employees   on salesRepEmployeeNumber=employeeNumber
left join orders using(customernumber)
where orders.customerNumber is null;

#wasq to fetch customername and their ordercount and totalordervalue in 2003,2004
select customername,count(ordernumber)as ordercount,sum(quantityordered*priceeach) as totalordervalue from customers
join orders using(customernumber) join orderdetails using(ordernumber) 
where  orderdate like "2003%" or orderdate like "2004%"
group by customerName;

#wasq to fetch productname and their count in 2005
select productname,count(*) from products join
 orderdetails using(productcode) 
join orders using(ordernumber) where orderdate like "2005%" group by productName;

 #wasq to fetch empname who dont manage any customer
 select concat(firstname," ",lastname) as empname from employees
 left join customers on employeeNumber=salesRepEmployeeNumber
 where salesRepEmployeeNumber is null;
 
 #wasq to fetch cname and their order count
 select customername,count(*) as ordercount from customers join orders using(customernumber) group by customerName;

#control flow functions 
 #CTE(Common Table Expression) Making temporary Table of displayed result
 
 with cte as(select customername,count(*) as ordercount from customers join orders using(customernumber) group by customerName)
 select *,
 case ordercount
 when 1 then "one time customer"
 when 2 then "repeated customer"
 when 3 then "frequent customer"
 else "loyal customer"
 end as customer_type from cte;
 
 #wasq to fetch cname and totalordervalue ,on the basis of totalordervalue create 1 column customer type
 #conditions are if totalordervalue<10000 then silver customer ,if totalordervalue between 10k and 100k then gold customer
 #and if totalordervalue>100k then platinum customer
 with cte as(select customername,sum(quantityordered*priceeach) as totalordervalue from customers join orders using(customernumber)
 join orderdetails using(ordernumber) group by customerName)
 select *,
 case 
 when totalordervalue<10000 then "silver customer"
 when totalordervalue between 10000 and 100000 then "gold customer"
 else "platinum customer"
 end as customer_type from cte;
 select productline,count(*) from products group by productLine;
 #wasq to fetch productline and their count in a single row(solve with case when and if function)
 select 
sum(case when productline="classic cars" then 1 else 0 end) as classic_cars,
 sum(case when productline="motorcycle" then 1 else 0 end) as motorcycle,
 sum(case when productline="planes" then 1 else 0 end) as planes,
 sum(case when productline="ships" then 1 else 0 end) as ships,
 sum(case when productline="trains" then 1 else 0 end) as trains,
 sum(case when productline="trucks and buses" then 1 else 0 end) as trucks_and_buses,
 sum(case when productline="vintage cars" then 1 else 0 end) as vintage_cars
 from products;
 
 
 select 
sum(if(productline="classic cars",1,0)) as classic_cars,
 sum(if(productline="motorcycle",1,0)) as motorcycle,
 sum(if(productline="planes",1,0)) as planes,
 sum(if(productline="ships",1,0)) as ships,
 sum(if(productline="trains",1,0)) as trains,
 sum(if(productline="trucks and buses",1,0)) as trucks_and_buses,
 sum(if(productline="vintage cars",1,0)) as vintage_cars
 from products;
 #customer type with if
 with cte as(select customername,count(*) as ordercount from customers join orders using(customernumber) group by customerName)
 select *,if(ordercount=1,"one time customer",if(ordercount=2,"repeated customer",if(ordercount=3,"freqeunt customer","loyal customer")))
 as customer_type from cte;
 
 #tov customertype with if
 with cte as(select customername,sum(quantityordered*priceeach) as totalordervalue from customers join orders using(customernumber)
 join orderdetails using(ordernumber) group by customerName)
 select *,if(totalordervalue<10000,"silver customer",
 if(totalordervalue between 10000 and 100000,"gold customer"
 ,"platinum customer")) as customer_type from cte;
 
 #FUNCTIONS
 
 #string function
 
 select concat("decode"," ","data"," ","bhopal") as dname;
 select concat_ws(" ","decode","data","bhopal") as dname;
 
 #left(string,length) and right(string,length)
 #wasq to fetch cname whose name starts with vowel and ends with vowel
 select customername from customers where left(customername,1) in("a","e","i","o","u") 
 and right(customername,1) in("a","e","i","o","u");
 
 #substring
 select customername from customers where substring(customername,1,1) in("a","e","i","o","u")
 and substring(customername,-1,1) in("a","e","i","o","u");
 
 
 #upper(string/columnname)
# lower(string/columnname)
#length(string/columnname)
#trim()
#rtrim()
#ltrim()
select upper("decode");
select lower("DECODE");
select length("bhopal");
select trim("   decode     data     ") as a;

select ltrim( "     decode   data") as a ;
select rtrim("   data decode  ");

# reverse (string)
select reverse("bhopal");
select reverse("nitin"); #palandrome
#replace
#replace ("string","oldstring","newstring");
select replace ("70 % off" ,"off", "");

#instr(string,substring)
#return position of substring in a given string
#wasq to fetch productname which consist car keyword?

use dummy;
select productname from products
where instr(productname,"car");
select productname from products
where productname like "%car%";

# wasq to fetch cxname (whos firstname starts with vowel and ends with consonent)

select customername from customers
where substring(customername,1,1) in ("a","e","i","o","u")
and substring(customername,-1,1)  not in ("a","e","i","o","u");
use dummy;

#ifnull(value1,value2) only 2 parameter // coalesce(nvalues......)

# wasq to fetech cxname, city , sate and country from cxtable if the value state  is null then substitue it with 
#na?
select customername , city , ifnull(state,"N/A") as state , country from customers;

select customername , city , coalesce(state,"N/A") as state , country from customers;
create table phone( h int, offi int , oth int);
insert into phone(h,offi,oth)
values (null,91,92),(71,null,72),(null,null,78),
(null,62,85),(null,null,45);

select coalesce(h,offi,oth) as ph from phone;

#DATE FUNCTIONS
select now();
select year(now());
select quarter(now());
select month(now());
select monthname(now());
select day(now());
select dayname(now());
select week(now());

-- wasq to fetch cxname and their ordercount of the year 2004 and 2005 (first  and second quater) ?
select customername,count(*) as ordercount from customers join orders using(customernumber)
join orderdetails using(ordernumber) where year(orderdate) in(2004,2005) and quarter(orderdate) in(1,2)
group by customerName;

# wasq to fetch   cx  their totalordervalue in the year 2003 (monthly)
select customername,month(orderdate) as month,sum(quantityordered*priceeach) as totalordervalue from customers join orders using(customernumber)
join orderdetails using(ordernumber) where year(orderdate)=2003 group by customerName,month;

# wasq to fetch monthname and their totalordervalue in the year 2004 (monthly)
select monthname(orderdate) as month,sum(quantityordered*priceeach) as totalordervalue from  orders 
join orderdetails using(ordernumber) where year(orderdate)=2004 group by month;

#wasq to fetch empfullname and total sales in the year 2003 and 2004
select concat(firstname," ",lastname) as empfullname,sum(quantityordered*priceeach) as totalsales from employees
join customers on employeeNumber=salesRepEmployeeNumber join orders using(customernumber) join orderdetails using(ordernumber)
where year(orderdate) in(2003,2004)
group by empfullname order by empfullname desc;

#wasq to fetch weekly total sales
select week(orderdate) as weeklysales,sum(quantityordered*priceeach) as totalsales from orders
join orderdetails using(ordernumber) group by weeklysales;

select str_to_date("28,10,1990","%d,%m,%Y");
select str_to_date("30/10/1990","%d/%m/%Y");
select str_to_date("160445","%H%i%s");
select str_to_date("2003","%H%i");

select date_format(shippeddate,"%W %D %M %Y") from orders;

#datediff()
#datediff(enddate,startdate)

select ordernumber,shippeddate,orderdate,
datediff(shippeddate,orderdate) as datedifference from orders;

#wasq to fetch orderno,orderdate,requireddate and diff bw orderdate and requireddate
select ordernumber,orderdate,requireddate,datediff(requireddate,orderdate) as datedifference
from orders ;

#Maths functions
#abs()
#returns positive values
select abs(-10);
select abs(10-100);
select abs(01);

#floor()
#always return previous nearest integer
select floor(avg(buyprice)) as buyprice from products;

#ceil()
#always return next nearest integer
select ceil(avg(buyprice)) as buyprice from products;

#mod
select mod(5,2) as remainder;
select mod(2,5) as remainder;

#wasq to determine whether the quantity of products that the customer ordered is odd or even
select ordernumber,sum(quantityordered) as totalquantity,
case when mod(sum(quantityordered),2)=0 then "even"
else "odd" end as oddeven from orderdetails group by orderNumber;

#round & truncate
#round(num,decimalpoint) here 2nd parameter is optional
#if last digit is from 1 to 4 round removes that digit else round to next value
#truncate(num,decimalpoint) here both parameters are mandatory

select round(199.99,2);
select truncate(199.23,1);

select productLine,avg(msrp) from products group by productLine;

#wasq to fetch avg msrp of each productline
select productLine,round(avg(msrp),2) from products group by productLine;




  
 