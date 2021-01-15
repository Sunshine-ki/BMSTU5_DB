USE [master]
GO

-- ≈сли база данных уже существует, уничтожаем ее
IF  EXISTS (SELECT name FROM sys.databases WHERE name = N'tempdb2')
	DROP DATABASE [tempdb2]
GO

CREATE DATABASE [tempdb2]
GO

USE [tempdb2]
GO

CREATE TABLE student
(
	studentId int identity not null PRIMARY KEY,
	studentIdNumber char(8) not null UNIQUE,
	firstName varchar(20) not null,
	lastName varchar(20) not null,
	rowCreateDate datetime2(3) not null DEFAULT (current_timestamp),
	rowCreateUser sysname not null DEFAULT (current_user)
);

IF OBJECT_ID ( N'dbo.insert_in_student') IS NOT NULL
    DROP TRIGGER dbo.insert_in_student;
go

CREATE TRIGGER insert_in_student ON [tempdb2].[dbo].[student] INSTEAD OF insert AS
BEGIN
	BEGIN TRAN;	
	begin try
		insert into [student]
			select studentIdNumber, UPPER(firstName), UPPER(lastName), rowCreateDate, rowCreateUser
			from inserted;
		
		COMMIT
	end try
	begin catch
		ROLLBACK
	end catch	
END;
GO

