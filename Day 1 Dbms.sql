Select * from Employee
--selecting without from
Select 'Hello' as [Message], '100'  as [code num], 'Hhhh' as [comments]
-- select using var
DECLARE @varName NVARCHAR(50)
SET @varName = 'A new value'
SELECT @varName as [Using Vars]
-- use select to assign a value to a var
DECLARE @var2 INT
SET @var2=1001
SELECT @var2=1002
-- select top few rows
Select top 2 Empid From Employee
--select with order by asc
Select * From Employee ORDER BY EmpName
-- select with order by desc
Select * from Employee ORDER BY Empid DESC
-- get the newest employee who joined 
Select top 1 * FROM Employee ORDER BY Empid DESC
-- get distinct record from table 
Select Distinct EmpName FROM Employee
Select Distinct Empid,EmpName from Employee
-- select with where clause 
select * from Employee where EmpName= 'Hi' AND Empid=10000
select * from Employee where EmpName= 'Hi' OR Empid=1000
select top 2 * from Employee where EmpName <> 'Hi'
Select * from Employee where EmpName IN ('Hello','Hi')
Select * from Employee where EmpName NOT IN ('Hello','Hi')
Select * from Employee where Empid between 1000 and 2000
Select * from Employee where Doj between '2023-09-01' and '2023-09-30'
--using wildcards
Select * from Employee where EmpName like 'H%'
-- names ending with o
select * from Employee where EmpName like '%o'
--names that have a space 
select * from Employee where EmpName like '% %'
--names with 2 char 'i'
select * from Employee where EmpName like '_i%'
--Nested select stats in place of columns 
select (select EmpName from Employee where Empid=1001) as [Employee Name], (select 5+5) as [Percentage Hike]
-- seelct stat to assign a val to var
DECLARE @Empid INT 
SET @Empid = (Select top 1 Empid from Employee where EmpName = 'Blah')
Select @Empid as [Empid assigned to var]
--select stats to assigna d print val of var
Declare @newval INT
SET @newval = (Select top 1 Empid from Employee where EmpName = 'Blah')
Select @newval
--print as log message
PRINT ' the final val of the var @newval=' + CAST(@newval as nvarchar)
--EmpName-Empid
select EmpName+ '-' + CAST(EmpId as nvarchar) as [formatted name] from Employee
--clone a table - its schema
select * into EmployeeClone
From Employee 
where 1=0
-- create quick backup table
select * into EmployeeBackup
from Employee
where Managerid is not null
--display empnames and taskid
select E.EmpName, ET.Taskid from Employee as E, EmpTask as ET where E.Empid=ET.Empid
--display empnames and tasknames
select E.EmpName, T.Tname from EmpTask as ET, Task as T, Employee as E where T.Taskid=ET.Taskid and ET.Empid=E.Empid
--using innerjoin
select E.EmpName, ET.Taskid from Employee as E inner join EmpTask as ET on T.Empid=ET.Empid
--get empnames with tasknames
select E.EmpName, T.Tname from Employee as E inner join EmpTask as ET on E.Empid=ET.Empid inner join Task as T on ET.Taskid=T.Taskid
--get taskids and all empids (left outer join)
select E.Empid, ET.Taskid from Employee as E left outer join EmpTask as ET on E.Empid=ET.Empid
--get taskid and all empids(right outer join)
select ET.Taskid, E.Empid from EmpTask as ET  right outer join Employee as E on ET.Empid= E.Empid
--full outer join 
select E.EmpName,ET.Taskid from Employee as E full outer join EmpTask as ET on E.Empid=ET.Empid
--cross join 
select ET.Empid,T.Tname from Emptask as ET cross join Task as T 
--view
Create view vw_EmpTaskNames as 
select E.EmpName, T.Tname from Employee as E Left outer join EmpTask as ET on E.Empid=ET.Empid
left outer join Task as T on T.Taskid= ET.Taskid
--stored  procedure
Create procedure sp_GetEmpTaskNames as 
select E.EmpName, T.Tname from Employee as E Left outer join EmpTask as ET on E.Empid=ET.Empid
left outer join Task as T on T.Taskid= ET.Taskid
--execute sp
exec sp_GetEmpTaskNames
--var name in sp
Create procedure sp_GetTaskNameForEmployee @EmpName nvarchar(50)
AS
select E.EmpName, T.Tname from Employee as E Left outer join EmpTask as ET on E.Empid=ET.Empid
left outer join Task as T on T.Taskid= ET.Taskid
where E.EmpName=@EmpName
exec sp_GetTaskNameForEmployee 'Hello'
--alter sp
Alter procedure sp_GetTaskNameForEmployee @EmpName nvarchar(50)
AS
select E.EmpName, T.Tname from Employee as E Left outer join EmpTask as ET on E.Empid=ET.Empid
left outer join Task as T on T.Taskid= ET.Taskid
where E.EmpName=@EmpName and T.Tname is not null
--scalar function
create function  fn_GetTNameForEmployee (@EmpName nvarchar(50))
returns nvarchar(50)
AS
begin 
	return (select top 1 T.Tname from Employee as E Left outer join EmpTask as ET on E.Empid=ET.Empid
left outer join Task as T on T.Taskid= ET.Taskid
where E.EmpName=@EmpName and T.Tname is not null)
End
--execute function
select [dbo].[fn_GetTNameForEmployee] ('Hello')
--adding count in scalar function to get how many tasks a person is working on
create function  fn_GetTotalTaskForEmployee (@EmpName nvarchar(50))
returns nvarchar(50)
AS
begin 
	return (select count(T.Tname) from Employee as E Left outer join EmpTask as ET on E.Empid=ET.Empid
left outer join Task as T on T.Taskid= ET.Taskid
where E.EmpName=@EmpName and T.Tname is not null)
End
select [dbo].[fn_GetTotalTaskForEmployee] ('Hello')
--total no.of tasks for each employee
select E.EmpName,count(T.Tname) as TaskCount from Employee as E left outer join EmpTask as ET on E.Empid=ET.Empid left outer join Task as T on T.Taskid=ET.Taskid
Group By E.EmpName
--add conditions after group by
select E.EmpName,count(T.Tname) as TaskCount from Employee as E left outer join EmpTask as ET on E.Empid=ET.Empid left outer join Task as T on T.Taskid=ET.Taskid
Group By E.EmpName having count(T.Tname)=0
--insert 
insert into Task values('coding','10-25-2023','12-18-2023')
--insert in bulk
insert into Task
select 'designing','10-25-2023','12-18-2023'
union all
select 'testing','10-25-2023','12-18-2023'
union all
select 'design','10-25-2023','12-18-2023'
select * from Task
--update 
update Task set Tname = 'sql lab work'
where Taskid=1
--program for updation
declare @taskid int, @counter int
set @taskid =7
set @counter = 1
while(@taskid<=9)
begin
update Task set Tname = 'Day'+ cast(@counter as nvarchar) + ' lab work'
where taskid=@taskid
set @taskid=@taskid+1
set @counter=@counter+1
end
--delete
delete from Task where Taskid in (11,12)
--commit 
begin transaction 
insert into Task select 'new task 1','10-27-2023','12-18-2023'
print 'newly created taskids' +cast(@@Identity as nvarchar)
delete from Task where Taskid=@@identity 
commit
select * from Task
--cursor template 
declare @Empid int, @Empname nvarchar(50), @managerid int, @doj  as datetime
declare c1 cursor for 
select Empid, EmpName,Managerid, Doj from Employee
where isActive=1
open c1
fetch next from c1
into @Empid,@EmpName,@managerid,@doj
while @@FETCH_STATUS=0
begin
if @doj>'01-01-2022' and @doj<'12-31-2023'
print 'increment for' +@Empname+ ':10%'
else if @doj between '01-01-2021' and '12-12-2023'
print 'increment for'+@Empname+ ':20%'
else if @doj between '01-01-2021' and '12-31-2023'
print @Empname + 'is not elgible for increment'
else if @doj<'01-01-2021'
print 'increment for' +@Empname+ ':30%'
fetch next from c1 into @Empid,@EmpName,@managerid,@doj
end
close c1
deallocate c1
--requirement stat: return comma separated employee names
--analysis: sql featyre:cursor coz record by record processiong
create function fnemptocsvv() 
returns nvarchar(max)
as
begin
declare @Empname nvarchar(max), @result nvarchar(max)
declare c1 cursor for 
select EmpName from Employee
open c1
fetch next from c1
into @Empname
set @result=''
while @@FETCH_STATUS=0
begin 
set @result= @result+@Empname+','
fetch next from c1
into @Empname
End
close c1
deallocate c1
return @result
end
select dbo.fnemptocsvv()