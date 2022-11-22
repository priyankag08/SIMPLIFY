Drop table dbo.EmpDetails
create table dbo.EmpDetails (
	EmployeeName nvarchar(50) ,
	City varchar(50),
	ID int,
	Gender nvarchar(50),
	Designation nVarchar(50) )

insert into EmpDetails (EmployeeName,City,ID,Gender,Designation)
   Values ('Pravin','Kerala','2021194','male','TL'),('Rajvika','Gujrat','2021195','Female','Senior SW');

select * from dbo.EmpDetails 

