Select * from Employee where Doj between '2023-09-01' and '2023-09-30'
-- names ending with o
select * from Employee where EmpName like '%o'
--names that have a space 
select * from Employee where EmpName like '% %'
--names with 2 char 'i'
select * from Employee where EmpName like '_i%'
--EmpName-Empid
select EmpName+ '-' + CAST(EmpId as nvarchar) as [formatted name] from Employee

--Add 5 records into task table
--Get all tasks that contain 'Coding' in it
Select * from Task where TName like '%coding'
-- Get all tasks that end by end of October
select * from Task where enddate<='2023-10-31'
--Get all tasks that start on the same day (Eg: 25-Oct-2023)
select * from Task where startdate='2023-10-27'
--Select tasks and display in format Task Name - starts on- StartDate - ends by- End Date
--Eg:Coding-starts on-2023-10-25 00:00:00.0-ends by-2023-10-30 00:00:00.0
select Tname+ '- starts on -' + CAST(startdate as nvarchar) + ' ends on - ' + CAST(enddate as nvarchar) from Task
--Select Tasks that start in October with Task name containing 'coding'
select * from Task where (startdate between '2023-10-01' and '2023-10-31') and Tname like '%coding%' 
--display empnames and tasknames
select E.EmpName, T.Tname from EmpTask as ET, Task as T, Employee as E where T.Taskid=ET.Taskid and ET.Empid=E.Empid
--get task name with their matching empid
select T.TName, ET.Empid from Task as T inner join EmpTask as ET on T.Taskid=ET.Taskid
--adding to a view
create view empnames as
select E.EmpName,count(T.Tname) as TaskCount from Employee as E left outer join EmpTask as ET on E.Empid=ET.Empid left outer join Task as T on T.Taskid=ET.Taskid
Group By E.EmpName
--adding to sp
create procedure sp_empnames as
select E.EmpName,count(T.Tname) as TaskCount from Employee as E left outer join EmpTask as ET on E.Empid=ET.Empid left outer join Task as T on T.Taskid=ET.Taskid
Group By E.EmpName having count(T.Tname)=0
exec sp_empnames
--select all tasks for an empId
create procedure tasks as 
select T.Tname from Employee as E Left outer join EmpTask as ET on E.Empid=ET.Empid
left outer join Task as T on T.Taskid= ET.Taskid
where E.Empid=1000
exec tasks
--Get all tasks grouped by endDate
create procedure enddate as 
select count(Tname),enddate from Task  group by enddate
exec enddate
--Update the dates for a given TaskId (params: TaskId, StartDate, EndDate)
create procedure dates  @taskid int, @startdate datetime, @enddate datetime as 
update Task set startdate=@startdate,enddate=@enddate
where taskid=@taskid
exec dates '1','11-21-2023','12-21-2023'
select * from Task
--Delete a task for an EmployeeId (Use Employee Tasks table)
create procedure del @Empid int as
delete from EmpTask where Empid=@Empid
exec del '1000'

