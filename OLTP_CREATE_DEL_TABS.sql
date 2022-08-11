/********************************************************/
/*	NOT READY/STOPPED Preparing OLTP for accurate deleting informations	*/
/********************************************************/
------ ! Bug with LOB-Data in Triggers: To Avoid in REAL Life Scenario Procedures could be used instead of delete/Update-commands !

-- create schema DEL;

create or alter trigger DEL_Categories
on [dbo].[Categories]
after delete
as
begin
	select	CategoryID,
			CategoryName,
			ORIGINAL_LOGIN() as Deleted_By,
			getDate() as Deleted_DateTime
	into	[DEL.Categories]
	FROM	deleted
end;

create or alter trigger DEL_Employees
on [dbo].[Employees]
after delete
as
begin
	select	*,
			ORIGINAL_LOGIN() as Deleted_By,
			getDate() as Deleted_DateTime
	into	[DEL.Employees]
	FROM	deleted
end;

exec sp_help employees

create or alter trigger DEL_Categories
on [dbo].[Categories]
after delete
as
begin
	select	*,
			ORIGINAL_LOGIN() as Deleted_By,
			getDate() as Deleted_DateTime
	into	[DEL.Categories]
	FROM	deleted
end;

create or alter trigger DEL_Categories
on [dbo].[Categories]
after delete
as
begin
	select	*,
			ORIGINAL_LOGIN() as Deleted_By,
			getDate() as Deleted_DateTime
	into	[DEL.Categories]
	FROM	deleted
end;

create or alter trigger DEL_Categories
on [dbo].[Categories]
after delete
as
begin
	select	*,
			ORIGINAL_LOGIN() as Deleted_By,
			getDate() as Deleted_DateTime
	into	[DEL.Categories]
	FROM	deleted
end;

create or alter trigger DEL_Categories
on [dbo].[Categories]
after delete
as
begin
	select	*,
			ORIGINAL_LOGIN() as Deleted_By,
			getDate() as Deleted_DateTime
	into	[DEL.Categories]
	FROM	deleted
end;