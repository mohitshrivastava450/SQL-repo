#constraints
create database class;
use class;
create table stu(sid int primary key,sname varchar(20) not null,age tinyint,
city varchar(20) default 'bhopal',fees decimal(10,2),mobile varchar(20) unique,check(age>18));
desc stu;
alter table stu drop primary key;
alter table stu modify sid int;
alter table stu modify sname varchar(20);
alter table stu modify city varchar(20);
alter table stu modify city varchar(20) default 'bhopal';
#remove unique
#alter table tablename drop key/index uniquekeyname;
alter table stu drop key mobile;
desc stu;
#remove check
#alter table tablename drop constraint constraintname;
alter table stu drop constraint stu_chk_1;
use class;

#add primary key
#alter table tablename add primary key (columnname);
alter table stu add primary key (sid);
desc stu;
# add not null
# alter table tablename modify columnname datatype not null;
alter table stu modify sname varchar(20) not null;
# add default
#alter table tablename modify columnname datatype default "value";
alter table stu modify city varchar(20) default "bhopal";

#add unique key
#alter table tablename add unique(columnname);
alter table stu add unique(mobile);
desc stu;

# add check 
# alter table tablename add check(columnname with cond.)
# alter table stu add check(age>=18);
alter table stu modify age tinyint check(age>=18);
desc stu;
