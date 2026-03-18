#TRIGGER IS A SPECIAL TYPE OF STORED PROGRAM IN MYSQL THAT AUTOMATICALLY EVOKE/CALL/EXECUTE WHEN SPECIFIC EVENT OCCUR ON A TABLE
#LIKE(INSERT UPDATE OR DELETE) IT IS A RULE THAT FIRES AUTOMATICALLY WHEN DATA CHANGES 
# THERE ARE 2 TYPES OF TRIGGER- 1. ROW LEVEL TRIGGER 2. STATEMENT LEVEL TRIGGER 
#1. ROW LEVEL TRIGGER IS A SPECIAL TYPE DATABASE TRIGGER THAT EXECUTE ONCE FOR EACH INDIVIDUAL ROW AFFECTED BY DATA CHANGES LIKE
#(INSERT UPDEATE OR DELETE) ON THE OTHERR HAND 
#STATEMENT LEVEL TRIGGER EXECUTE ONLY ONCE PER STATEMENT 
#ADVANTAGES
#1 BACKUP & SECURITY
# BEFORE TRIGGERS ARE USED FOR VAOLIDATION AND FORMATTING 
#AFTER ISN USED FOR AUDITNG & LOGIN 
# only row level trigger works in mysql
# delimiter $$
# create trigger trigger name
# [ before/after] [ insert/update/delete]
# on table name
# for each row
# begin
# -----trigger logic here
# end $$
# delimiter ;

create database trigger_db;
use trigger_db;
create table students1(id int auto_increment primary key,
name varchar(50), age int, course varchar(50), registered_at
timestamp default current_timestamp);

create table student_logs1 (log_id int primary key auto_increment,
student_id int, action varchar(100), log_time timestamp default current_timestamp);

desc student_logs1;

delimiter $$
create trigger before_insertion
before insert on students1
for each row
begin
set new.name=upper(new.name);
end $$
delimiter ;

insert into students1(name,age,course)
values("xyz",23,"data analytics");

select * from students1;

#after insertion 
delimiter $$
create trigger after_insertion
after insert on students1
for each row
begin
insert into student_logs1(student_id,action)
values(new.id,"after insertion");
end $$
delimiter ;

insert into students1(name,age,course)
values("abc",24,"data science");

select * from students1;
select * from student_logs1;

# after delete

delimiter $$
create trigger after_deletion
after delete on students1
for each row
begin
insert into student_logs1(student_id,action)
values(old.id,"after deletion");
end $$
delimiter ;

delete from students1 where id=1;
select * from students1;
select * from student_logs1;

#after Update

delimiter $$
create trigger  after_updation
after update on students1
for each row
begin
insert into student_logs1(student_id,action)
values(new.id,concat_ws(" ","student",new.name,"change course from",old.course,"to",new.course));
end $$
delimiter ;

update students1 set course="data analytics"
where id=2;
select * from students1;
select * from student_logs1;

create table customers_backup(customerNumber int,customerName varchar(50),contactLastName varchar(50),contactFirstName varchar(50),
phone varchar(50),addressLine1 varchar(50),addressLine2 varchar(50),city varchar(50),state varchar(50),postalCode varchar(50),
country varchar(50),salesRepEmployeeNumber int,creditLimit decimal(10,2),deleted_at datetime,operation_type varchar(50));



select * from customers_backup;

#create a before insert trigger on customers table that automatically convert the customername to uppercase
#trim extra spaces from contactfirstname and contactlastname ensure the phoneno. doesnot contain spaces
delimiter $$
create trigger before_insert_on_customers
before insert on customers
for each row
begin
set new.customerName=upper(new.customername);
set new.contactfirstname=trim(new.contactfirstname);
set new.contactlastname=trim(new.contactlastname);
set new.phone=replace(new.phone," ","");
end $$
delimiter ;
insert into customers(customerNumber,customername,contactfirstname,contactlastname,phone,addressLine1,addressLine2,city,state,postalCode
,country,salesRepEmployeeNumber,creditLimit)
values(1,'abcd','     qwer  ','   ty     ui   ','54 89 565 43 6','null','null','bhopal','MP',1,'India',1370,1);
select * from customers where customerNumber=1;

#write an after delete trigger that insert deleted row into the backup table with current time stamp (now)
delimiter $$
create trigger after_deletion
after delete on customers
for each row
begin
insert into customers_backup
values(old.customerNumber,old.customerName,old.contactLastName,old.contactFirstName,old.phone,old.addressLine1,
old.addressLine2,old.city,old.state,old.postalCode,old.country,old.salesRepEmployeeNumber,old.creditLimit,now(),"DELETE");
end $$
delimiter ;
delete from customers where customerNumber=1;
select * from customers_backup;

#write an after update trigger that stores the previous record into the same customers_backup table with
#operation_type as update
delimiter $$
create trigger after_update_customers_backup
after update on customers
for each row
begin
   insert into customers_backup
    values (old.customerNumber,old.customerName,old.contactLastName,old.contactFirstName,old.phone,old.addressLine1,old.addressLine2,
old.city,old.state,old.postalCode,old.country,
old.salesRepEmployeeNumber,old.creditLimit,NOW(),"update");
end $$
delimiter ;
update customers
set city='delhi'
where customernumber=103;
select * from customers_backup;

#create a before insert trigger on customers table that checks if the new customers credit limit<0
#if yes then automatically set it to zero instead of throwing error
delimiter $$
create trigger before_insert_checck
before insert on customers
for each row
begin
if new.creditlimit<0 then
set new.creditlimit=0;
end if;
end $$
delimiter ;

insert into customers(customerNumber,customerName,contactLastName,contactFirstName,phone,addressLine1,city,country,creditLimit) 
values(1999,'test customer','doe','john'
,'123456789','123 street','bhopal','India',-5000);

select * from customers where customernumber=1999;
desc customers_backup;



