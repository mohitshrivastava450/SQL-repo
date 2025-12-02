create database joins;
use joins;
create table table1(id int);
create table table2(id int);
insert into table1(id)
values(1),(1),(1),(2),(3),(4),(null);
insert into table2(id)
values (1),(1),(2),(5),(null),(null);
select * from table2;

#cross join/cartesian join

#select columnlist from tablename1
#cross join tablename2;

select * from table1 cross join table2;
select count(*) from table1 cross join table2;

#inner join - return match value between two or more tables
#select columnlist from tablename1
#inner join/join tablename2 on commoncolumncondition;
select * from table1 t1 inner join table2 t2 on t1.id=t2.id;
#note--without on keyword/conditon inner join works like cross join and vice versa. 
select count(*) from table1 t1 inner join table2 t2 on t1.id=t2.id;

#left  join-- inner join + remaining value of left table
select * from table1 t1 left join table2 t2 on t1.id=t2.id;
select count(*) from table1 t1 left join table2 t2 on t1.id=t2.id;

#left exclusive
select * from table1 t1 left join
table2 t2 on t1.id=t2.id
where t2.id is null;

#right  join-- inner join + remaining value of right table
select * from table1 t1 right join table2 t2 on t1.id=t2.id;
select count(*) from table1 t1 right join table2 t2 on t1.id=t2.id;
use dummy;
select * from customers;
select * from orders;
select count(*) from customers
cross join orders;





#right exclusive
select * from table1 t1 right join
table2 t2 on t1.id=t2.id
where t1.id is null;

#natural join

select * from table1 t1 natural join table2; 
select count(*) from table1 t1 natural join table2;
#when column name is different natural join works like cross join
alter table table2 rename column id to eid;
alter table table2 rename column eid to id;

#full join--remaining value of left table + inner join 
#+ remaining value of right table

#left join union right join
#left join + right exclusive
select count(*) from table1 t1 left join table2 t2
on t1.id=t2.id
union all
select count(*) from table1 t1 right join table2 t2
on t1.id=t2.id where t1.id is null;

#left exclusive + right join
select count(*) from table1 t1 left join table2 t2
on t1.id=t2.id where t2.id is null
union all
select count(*) from table1 t1 right join table2 t2
on t1.id=t2.id;

#inner join

#wasq to fetch customers and orderdetail who have 
#placed any order?(record count)

select count(*) from customers c
inner join orders o
on c.customernumber=o.customernumber;

#left join
# wasq to fetch customers and their orderdetail
#who have either placed any order or not/
select count(*) from customers c
left join orders o 
on c.customerNumber=o.customerNumber;

#wasq to fetch customer's name who have not placed any order?
select customername from customers c 
left join orders o 
on c.customerNumber=o.customerNumber
where o.customerNumber is null;

#full join
select count(*) from customers c 
left join orders o 
on c.customernumber=o.customerNumber
union all
select count(*) from customers c 
right join orders o 
on c.customernumber=o.customerNumber
where c.customernumber is null;

#wasq to fetch customer name and their respective salesrepname.
select c.customername,concat(e.firstname," ",e.lastname) as sales_rep_name from customers c inner join employees e
on c.salesRepEmployeeNumber=e.employeeNumber;

#wasq to fetch orderdate,status and ordervalue from orders and orderdetails table
select o.orderdate,o.status,od.quantityordered*od.priceeach as ordervalue from orders o
inner join orderdetails od on o.ordernumber=od.ordernumber 
order by orderDate desc;

#wasq to fetch customer name, chequeno.and amount from customers and payments table
select c.customername,p.checknumber,p.amount from customers c inner join payments p on c.customernumber=p.customerNumber;

#wasq to fetch product name who have not sold yet
select p.productName from products p left join orderdetails o on p.productCode=o.productCode 
where o.productCode is null;

#wasq to fetch customer number,customer name, orderdate, status from customers and orders table.
select c.customernumber,c.customername,o.orderdate,o.status from customers c
inner join orders o on c.customerNumber=o.customerNumber;

#joins  on multiple table
#wasq to fetch cxno.,cxname,orderno.,ordervalue,productname?
select c.customernumber,c.customername,o.ordernumber,
od.quantityordered*od.priceeach as ordervalue,p.productname
from customers c inner join orders o
on c.customernumber=o.customerNumber inner join orderdetails od
on o.orderNumber=od.orderNumber inner join products p
on od.productCode=p.productCode;

#using (#samecolumn name)
#wasq to fetch cxname who placed any order and have not made any payment yet?
select c.customername from customers c
inner join orders o on c.customerNumber=o.customerNumber left join
payments p on c.customerNumber=p.customerNumber
where p.customerNumber is null;

#wasq to fetch empnames and their sales?
select concat(e.firstname," ",e.lastname) as empfullname,quantityordered*priceeach as total_sales from employees e
inner join customers c on e.employeeNumber=c.salesRepEmployeeNumber
inner join orders o on c.customerNumber=o.customerNumber
inner join orderdetails od on o.orderNumber=od.orderNumber;

#wasq to fetch product and their ordervalue?
select pl.productline,od.quantityordered*od.priceeach as ordervalue from productlines pl
join products p on pl.productLine=p.productLine
inner join orderdetails od on p.productCode=od.productcode;

#wasqtf customer who lives in same city as office city?
select c.customername,c.city as customer_city,o.city as offcie_city from customers c 
join employees e on c.salesRepEmployeeNumber=e.employeeNumber
inner join offices o on e.officeCode=o.officeCode where o.city=c.city;

#wasq to list the product name who's status are shipped?
select p.productname,o.status from products p join orderdetails od using(productcode) 
join orders o using(ordernumber) where o.status="shipped";

#wasqtf customers and the order value of each product (ordervalue > 4000)
select c.customername,od.quantityordered*od.priceeach as ordervalue from customers c join orders o using(customernumber)
join orderdetails od using(ordernumber) where od.quantityordered*od.priceeach>4000;

#wasqtf all employees who reports to emp number 1143?
select concat(firstname," ",lastname) as empname from employees where reportsTo=1143;

select concat(firstname," ",lastname) as empfullname from employees e 
left join customers c on e.employeeNumber=c.salesRepEmployeeNumber
where c.salesrepemployeenumber is null and  jobtitle="Sales Rep";
select * from employees;

select c.customername,concat(e.firstname," " ,lastname) as sales_rep from customers c 
left join employees e on c.salesRepEmployeeNumber=e.employeeNumber;

select c.customername,concat(e.firstname," " ,lastname) as sales_rep from customers c 
left join employees e on c.salesRepEmployeeNumber=e.employeeNumber
where e.employeeNumber is null;

select c.customername,concat(e.firstname," " ,lastname) as sales_rep from customers c
join employees e on c.salesRepEmployeeNumber=e.employeeNumber 
left join orders o on c.customerNumber=o.customerNumber
where o.customerNumber is null;

#self Join

select m.employeeNumber,concat(m.firstname," ",m.lastname) as manager,
concat(e.firstName," ",e.lastName) as "direct reportee",
e.employeeNumber from employees m 
inner join employees e on m.employeeNumber=e.reportsTo;

select c1.city,c1.customername,c2.customername from customers c1 
inner join customers c2 on c1.city=c2.city
and c1.customerName>c2.customerName
order by c1.city;

create table family(member_id varchar(20),name varchar(20),age int,parent_id varchar(20));
insert into family(member_id,name,age,parent_id)
values("f1","david",4,"f5"),("f2","carol",10,"f5"),("f3","michael",12,"f5"),
("f4","johnson",36,null),("f5","mariam",40,"f6"),("f6","stewart",70,null),
("f7","rohan",6,"f4"),("f8","asha",8,"f4");
select * from family;
set sql_safe_updates=0;
update family set name="maryam" where member_id="f5";

select c.name as "child name",c.age as "child age",p.name as "parent name",p.age as "parent age" from family c join family p 
on p.member_id=c.parent_id;