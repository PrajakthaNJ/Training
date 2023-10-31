USE [Task Management]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetTNameForEmployee]    Script Date: 30-10-2023 12:36:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function  [dbo].[fn_GetTNameForEmployee] (@EmpName nvarchar(50))
returns nvarchar(50)
AS
begin 
	return (select top 1 T.Tname from Employee as E Left outer join EmpTask as ET on E.Empid=ET.Empid
left outer join Task as T on T.Taskid= ET.Taskid
where E.EmpName=@EmpName and T.Tname is not null)
End
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetTotalTaskForEmployee]    Script Date: 30-10-2023 12:36:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function  [dbo].[fn_GetTotalTaskForEmployee] (@EmpName nvarchar(50))
returns nvarchar(50)
AS
begin 
	return (select count(T.Tname) from Employee as E Left outer join EmpTask as ET on E.Empid=ET.Empid
left outer join Task as T on T.Taskid= ET.Taskid
where E.EmpName=@EmpName and T.Tname is not null)
End
GO
/****** Object:  UserDefinedFunction [dbo].[fnemptocsv]    Script Date: 30-10-2023 12:36:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fnemptocsv]() 
returns nvarchar(max)
as
begin
declare @Empname nvarchar(max), @result nvarchar(max)
declare c1 cursor for 
select EmpName from Employee
open c1
fetch next from c1
into @Empname
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
GO
/****** Object:  UserDefinedFunction [dbo].[fnemptocsvv]    Script Date: 30-10-2023 12:36:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fnemptocsvv]() 
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
GO
/****** Object:  UserDefinedFunction [dbo].[sp_GetTNameForEmployee]    Script Date: 30-10-2023 12:36:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function  [dbo].[sp_GetTNameForEmployee] (@EmpName nvarchar(50))
returns nvarchar(50)
AS
begin 
	return (select top 1 T.Tname from Employee as E Left outer join EmpTask as ET on E.Empid=ET.Empid
left outer join Task as T on T.Taskid= ET.Taskid
where E.EmpName=@EmpName and T.Tname is not null)
End
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 30-10-2023 12:36:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[Empid] [int] IDENTITY(1000,1) NOT NULL,
	[EmpName] [nvarchar](50) NULL,
	[Managerid] [int] NULL,
	[Emailid] [nvarchar](70) NULL,
	[Doj] [datetime] NOT NULL,
	[isActive] [bit] NOT NULL,
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED 
(
	[Empid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Task]    Script Date: 30-10-2023 12:36:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Task](
	[Taskid] [int] IDENTITY(1,1) NOT NULL,
	[Tname] [nvarchar](200) NULL,
	[startdate] [datetime] NULL,
	[enddate] [datetime] NULL,
 CONSTRAINT [PK_Task] PRIMARY KEY CLUSTERED 
(
	[Taskid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmpTask]    Script Date: 30-10-2023 12:36:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmpTask](
	[Empid] [int] NOT NULL,
	[Taskid] [int] NOT NULL,
	[IsSubmitted] [bit] NOT NULL,
	[IsComplete] [bit] NOT NULL,
	[ModifyDate] [datetime] NOT NULL,
 CONSTRAINT [PK_EmpTask] PRIMARY KEY CLUSTERED 
(
	[Empid] ASC,
	[Taskid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_EmpTaskNames]    Script Date: 30-10-2023 12:36:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [dbo].[vw_EmpTaskNames] as 
select E.EmpName, T.Tname from Employee as E Left outer join EmpTask as ET on E.Empid=ET.Empid
left outer join Task as T on T.Taskid= ET.Taskid
GO
/****** Object:  Table [dbo].[EmployeeClone]    Script Date: 30-10-2023 12:36:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeClone](
	[Empid] [int] IDENTITY(1000,1) NOT NULL,
	[EmpName] [nvarchar](50) NULL,
	[Managerid] [int] NULL,
	[Emailid] [nvarchar](70) NULL,
	[Doj] [datetime] NOT NULL,
	[isActive] [bit] NOT NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Employee] ON 
GO
INSERT [dbo].[Employee] ([Empid], [EmpName], [Managerid], [Emailid], [Doj], [isActive]) VALUES (1000, N'Hello', 101, N'hello@kpmg.com', CAST(N'2023-09-09T00:00:00.000' AS DateTime), 1)
GO
INSERT [dbo].[Employee] ([Empid], [EmpName], [Managerid], [Emailid], [Doj], [isActive]) VALUES (1001, N'Blah', 102, N'Blah@kpmg.com', CAST(N'2023-09-09T00:00:00.000' AS DateTime), 1)
GO
INSERT [dbo].[Employee] ([Empid], [EmpName], [Managerid], [Emailid], [Doj], [isActive]) VALUES (1002, N'Hi', 103, N'Hi@kpmg.com', CAST(N'2023-09-09T00:00:00.000' AS DateTime), 1)
GO
INSERT [dbo].[Employee] ([Empid], [EmpName], [Managerid], [Emailid], [Doj], [isActive]) VALUES (1003, N'Bye', 104, N'Bye@kpmg.com', CAST(N'2023-09-09T00:00:00.000' AS DateTime), 1)
GO
INSERT [dbo].[Employee] ([Empid], [EmpName], [Managerid], [Emailid], [Doj], [isActive]) VALUES (1004, N'Hello', 105, N'hello@kpmg.com', CAST(N'2023-09-09T00:00:00.000' AS DateTime), 1)
GO
INSERT [dbo].[Employee] ([Empid], [EmpName], [Managerid], [Emailid], [Doj], [isActive]) VALUES (1005, N'Hello', 105, N'hello@kpmg.com', CAST(N'2023-09-09T00:00:00.000' AS DateTime), 1)
GO
SET IDENTITY_INSERT [dbo].[Employee] OFF
GO
INSERT [dbo].[EmpTask] ([Empid], [Taskid], [IsSubmitted], [IsComplete], [ModifyDate]) VALUES (1001, 1, 1, 1, CAST(N'2023-10-25T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[EmpTask] ([Empid], [Taskid], [IsSubmitted], [IsComplete], [ModifyDate]) VALUES (1001, 2, 0, 0, CAST(N'2023-10-26T00:00:00.000' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Task] ON 
GO
INSERT [dbo].[Task] ([Taskid], [Tname], [startdate], [enddate]) VALUES (1, N'sql lab work', CAST(N'2023-11-21T00:00:00.000' AS DateTime), CAST(N'2023-12-21T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[Task] ([Taskid], [Tname], [startdate], [enddate]) VALUES (2, N' dbms in depth', CAST(N'2023-10-26T00:00:00.000' AS DateTime), CAST(N'2023-10-26T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[Task] ([Taskid], [Tname], [startdate], [enddate]) VALUES (3, N'Basic coding', CAST(N'2023-10-27T00:00:00.000' AS DateTime), CAST(N'2023-10-27T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[Task] ([Taskid], [Tname], [startdate], [enddate]) VALUES (4, N'basic coding', CAST(N'2023-10-27T00:00:00.000' AS DateTime), CAST(N'2023-10-29T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[Task] ([Taskid], [Tname], [startdate], [enddate]) VALUES (5, N'coding', CAST(N'2023-10-28T00:00:00.000' AS DateTime), CAST(N'2023-10-30T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[Task] ([Taskid], [Tname], [startdate], [enddate]) VALUES (6, N'coding', CAST(N'2023-10-28T00:00:00.000' AS DateTime), CAST(N'2023-10-31T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[Task] ([Taskid], [Tname], [startdate], [enddate]) VALUES (7, N'Day1 lab work', CAST(N'2023-10-29T00:00:00.000' AS DateTime), CAST(N'2023-10-31T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[Task] ([Taskid], [Tname], [startdate], [enddate]) VALUES (8, N'Day2 lab work', CAST(N'2023-09-29T00:00:00.000' AS DateTime), CAST(N'2023-10-31T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[Task] ([Taskid], [Tname], [startdate], [enddate]) VALUES (9, N'Day3 lab work', CAST(N'2023-10-25T00:00:00.000' AS DateTime), CAST(N'2023-12-18T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[Task] ([Taskid], [Tname], [startdate], [enddate]) VALUES (10, N'designing', CAST(N'2023-10-25T00:00:00.000' AS DateTime), CAST(N'2023-12-18T00:00:00.000' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Task] OFF
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Employee] FOREIGN KEY([Empid])
REFERENCES [dbo].[Employee] ([Empid])
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_Employee_Employee]
GO
ALTER TABLE [dbo].[EmpTask]  WITH CHECK ADD  CONSTRAINT [FK_EmpTask_Employee] FOREIGN KEY([Empid])
REFERENCES [dbo].[Employee] ([Empid])
GO
ALTER TABLE [dbo].[EmpTask] CHECK CONSTRAINT [FK_EmpTask_Employee]
GO
ALTER TABLE [dbo].[EmpTask]  WITH CHECK ADD  CONSTRAINT [FK_EmpTask_Task] FOREIGN KEY([Taskid])
REFERENCES [dbo].[Task] ([Taskid])
GO
ALTER TABLE [dbo].[EmpTask] CHECK CONSTRAINT [FK_EmpTask_Task]
GO
/****** Object:  StoredProcedure [dbo].[dates]    Script Date: 30-10-2023 12:36:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dates]  @taskid int, @startdate datetime, @enddate datetime as 
update Task set startdate=@startdate,enddate=@enddate
where taskid=@taskid
exec dates '1','11-21-2023','12-21-2023'
GO
/****** Object:  StoredProcedure [dbo].[del]    Script Date: 30-10-2023 12:36:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[del] @Empid int as
delete from EmpTask where Empid=@Empid
GO
/****** Object:  StoredProcedure [dbo].[enddate]    Script Date: 30-10-2023 12:36:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[enddate] as 
select count(Tname),enddate from Task  group by enddate
GO
/****** Object:  StoredProcedure [dbo].[sp_empnames]    Script Date: 30-10-2023 12:36:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_empnames] as
select E.EmpName,count(T.Tname) as TaskCount from Employee as E left outer join EmpTask as ET on E.Empid=ET.Empid left outer join Task as T on T.Taskid=ET.Taskid
Group By E.EmpName having count(T.Tname)=0
GO
/****** Object:  StoredProcedure [dbo].[sp_GetEmpTaskNames]    Script Date: 30-10-2023 12:36:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[sp_GetEmpTaskNames] as 
select E.EmpName, T.Tname from Employee as E Left outer join EmpTask as ET on E.Empid=ET.Empid
left outer join Task as T on T.Taskid= ET.Taskid
GO
/****** Object:  StoredProcedure [dbo].[sp_GetTaskNameForEmployee]    Script Date: 30-10-2023 12:36:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_GetTaskNameForEmployee] @EmpName nvarchar(50)
AS
select E.EmpName, T.Tname from Employee as E Left outer join EmpTask as ET on E.Empid=ET.Empid
left outer join Task as T on T.Taskid= ET.Taskid
where E.EmpName=@EmpName and T.Tname is not null
GO
/****** Object:  StoredProcedure [dbo].[tasks]    Script Date: 30-10-2023 12:36:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[tasks] as 
select T.Tname from Employee as E Left outer join EmpTask as ET on E.Empid=ET.Empid
left outer join Task as T on T.Taskid= ET.Taskid
where E.Empid=1000
GO
