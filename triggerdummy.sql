use dummy;


select * from customers_backup;

delimiter $$
create trigger before_insertion
before insert on customers
for each row
begin 
 set new.customername=upper(trim(new.customername));
 set new.contactfirstname=trim(new.contactfirstname);
 set new.contactlastname=trim(new.contactlastname);
 set new.phone=replace(new.phone," ","");
end $$
delimiter ;


delimiter $$
create trigger after_deletion
after delete on customers
for each row
begin
    insert into customers_backup
values (old.customerNumber,old.customerName,old.contactLastName
,old.contactFirstName,old.phone,old.addressLine1,old.addressLine2,
old.city,old.state,old.postalCode,old.country,
old.salesRepEmployeeNumber,old.creditLimit,NOW(),"DELETE");
end $$
delimiter ;


delete from customers where customernumber=125;

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
set city ='mumbai'
where customerNumber =103;


delimiter $$
create trigger before_insert_check
before insert on customers
for each row
begin
   if new.creditLimit < 0 then
        set new.creditLimit =0;
    end if;
end;

delimiter ;


insert into customers (
    customerNumber, customerName, contactLastName, contactFirstName,
    phone, addressLine1, city, country, creditLimit)
values (1999, "test customer", "doe", "john",
"1234567890","123 Street", 
"bhopal", "India", -5000);

select * from customers_backup;

desc customers_backup;





