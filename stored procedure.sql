#stored procedure is a named precompiled collection of 1 or more sql statements stored in a database. desgined  to perfrom specifc
#task(act like a function or sub routine)

#stored procedure syntax
#delimiter $$
#create procedure procedurename(in parameter datatype)
#begin
#sql statements;
#end $$
#delimiter ;
#call procedurename();

#wasp to fetch customername,cno,city,state,country and credit limit
delimiter $$
create procedure cust_details()
begin
select customernumber,customername,city,state,country,creditlimit from customers;
end $$
delimiter ;

call cust_details();

delimiter !!
create procedure cust_order_details()
begin 
select * from customers;
select * from orders;
end !!
delimiter ;

call cust_order_details();

delimiter ^^
create procedure cust_details_usa()
begin
select * from customers where
country="usa";
end ^^
delimiter ;

call cust_details_usa();

delimiter ??
create procedure cust_details_country(in incountry varchar(100))
begin
select * from customers c where c.country=incountry;
end ??
delimiter ;

call cust_details_country("france");

delimiter ??
create procedure cust_details_country1(in incountry varchar(100),creditlimit decimal(10,2))
begin
select * from customers c where c.country=incountry and c.creditlimit>creditlimit;
end ??
delimiter ;
call cust_details_country1("usa",20000);

#what is the quantity on hand for the products listed on "on hold orders"(productname,quantityinstock and status)
select productname,quantityinstock,status from products join orderdetails using(productcode)
join orders using(ordernumber) where status="on hold";

#write a stored procedure to fetch that returns top rank product on the basis of total order value of each
#productline . input parameter productrank and productline
delimiter &&
create procedure toprankproduct(in productsline varchar(100), productrank varchar(100))
begin
with cte as(select productline,productname,sum(quantityordered*priceeach) as totalordervalue,
dense_rank() over (partition by productline order by sum(quantityordered*priceeach) desc)
as productsrank from products join orderdetails using(productcode) group by 1,2)
select * from cte where productsline=productline and productrank=productsrank;  
end &&
delimiter ;

call toprankproduct("classic cars",3);

#wasp that fetch ordercount of each status
select status,count(status) as ordercount from orders group by 1;
delimiter $$
create procedure status_ord_count(in status varchar(50),out total int)
begin 
select count(*) into total from orders o where o.status=status;
end $$
delimiter ;
call status_ord_count("cancelled",@total);
select @total;

#wasp named empemail, fetch the email of given employee (in empno,out pemail)
delimiter $$
create procedure empemail(in empno int,out pemail varchar(100))
begin
select email into pemail from employees e
where e.employeeNumber=empno;
end $$
delimiter ;
call empemail(1056,@pemail);
select @pemail;

#wasp named product_category_sales that fetch total sales by productline of each year
delimiter $$
create procedure product_category_sales(in pline varchar(100),pyear int,out totalsales decimal(12,2))
begin
select sum(quantityordered*priceeach) into totalsales from orderdetails od join orders using(ordernumber)
join products p using(productcode)
where p.productline=pline  and year(orderdate)=pyear;
end $$
delimiter ;
call product_category_sales("classic cars",2003,@totalsales);
select @totalsales;

#wasp that fetch total amount paid by each customer in each year(in cno,pyear)
delimiter $$
create procedure total_amount(in cnumber int,pyear int,out camount decimal(10,2))
begin
select sum(amount) into camount from payments where customernumber=cnumber and year(paymentdate)=pyear;
end $$
delimiter ;
call total_amount(103,2003,@camount);
select @camount;

#wasp that fetch ordercount of each customer of each year
delimiter $$
create procedure ord_count(in cnumber int,oyear int,out ocount int)
begin
select count(ordernumber) into ocount from orders where customerNumber=cnumber and year(orderdate)=oyear;
end $$
delimiter ;
call ord_count(103,2004,@ocount);
select @ocount;

