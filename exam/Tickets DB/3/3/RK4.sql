/*
Navicat SQL Server Data Transfer

Source Server         : localhost
Source Server Version : 110000
Source Host           : :1433
Source Database       : rk4
Source Schema         : dbo

Target Server Type    : SQL Server
Target Server Version : 110000
File Encoding         : 65001

Date: 2013-12-19 13:30:09
*/
CREATE DATABASE DBTemp;  -- Создание базы данных "Турфирмы России"
GO  -- Конец пакета

USE DBTemp;  -- Изменяет текущую БД для данной сессии
-- ----------------------------
-- Table structure for Audit
-- ----------------------------
DROP TABLE [dbo].[Audit]
GO
CREATE TABLE [dbo].[Audit] (
[ID] int NOT NULL IDENTITY(1,1) ,
[name] nvarchar(40) NOT NULL ,
[category_id] nvarchar(40) NULL ,
[Action] nvarchar(6) NOT NULL ,
[ChangedDate] datetime NOT NULL DEFAULT (getdate()) ,
[ChangedBy] nvarchar(50) NOT NULL DEFAULT (suser_sname()) 
)


GO
DBCC CHECKIDENT(N'[dbo].[Audit]', RESEED, 8)
GO

-- ----------------------------
-- Records of Audit
-- ----------------------------
SET IDENTITY_INSERT [dbo].[Audit] ON
GO
INSERT INTO [dbo].[Audit] ([ID], [name], [category_id], [Action], [ChangedDate], [ChangedBy]) VALUES (N'1', N'Мария', N'35', N'Insert', N'20/12/13 23:59:59.997', N'dbo')
GO
GO
INSERT INTO [dbo].[Audit] ([ID], [name], [category_id], [Action], [ChangedDate], [ChangedBy]) VALUES (N'2', N'Егор', N'1', N'Update', N'20/12/13 23:59:20.900', N'dbo')
GO
GO
INSERT INTO [dbo].[Audit] ([ID], [name], [category_id], [Action], [ChangedDate], [ChangedBy]) VALUES (N'3', N'Денис', N'76', N'Insert', N'20/12/13 23:59:21.000', N'dbo')
GO
GO
INSERT INTO [dbo].[Audit] ([ID], [name], [category_id], [Action], [ChangedDate], [ChangedBy]) VALUES (N'4', N'Наталья', N'1', N'Update', N'20/12/13 23:50:21.237', N'dbo')
GO
GO
INSERT INTO [dbo].[Audit] ([ID], [name], [category_id], [Action], [ChangedDate], [ChangedBy]) VALUES (N'5', N'Евгений', N'8', N'Update', N'20/12/13 23:52:12.567', N'dbo')
GO
GO
INSERT INTO [dbo].[Audit] ([ID], [name], [category_id], [Action], [ChangedDate], [ChangedBy]) VALUES (N'6', N'Оксана', N'8', N'Update', N'20/12/13 23:53:53.940', N'dbo')
GO
GO
INSERT INTO [dbo].[Audit] ([ID], [name], [category_id], [Action], [ChangedDate], [ChangedBy]) VALUES (N'7', N'Ирина', N'59', N'Insert', N'20/12/13 23:45:23.008', N'dbo')
GO
GO
INSERT INTO [dbo].[Audit] ([ID], [name], [category_id], [Action], [ChangedDate], [ChangedBy]) VALUES (N'8', N'Руслан', N'1', N'Update', N'20/12/13 23:47:03.492', N'dbo')
GO
GO
SET IDENTITY_INSERT [dbo].[Audit] OFF
GO

-- ----------------------------
-- Table structure for books
-- ----------------------------
DROP TABLE [dbo].[cust]
GO
CREATE TABLE [dbo].[cust] (
[id] int NOT NULL IDENTITY(1,1) ,
[name] varchar(255) NULL ,
[category_id] int NULL 
)


GO
DBCC CHECKIDENT(N'[dbo].[cust]', RESEED, 8)
GO

-- ----------------------------
-- Records of books
-- ----------------------------
SET IDENTITY_INSERT [dbo].[cust] ON
GO
INSERT INTO [dbo].[cust] ([id], [name], [category_id]) VALUES (N'1', N'Мария', N'1')
GO
GO
INSERT INTO [dbo].[cust] ([id], [name], [category_id]) VALUES (N'2', N'Эльдар', N'3')
GO
GO
INSERT INTO [dbo].[cust] ([id], [name], [category_id]) VALUES (N'3', N'Егор', N'1')
GO
GO
INSERT INTO [dbo].[cust] ([id], [name], [category_id]) VALUES (N'4', N'Кристина', N'1')
GO
GO
INSERT INTO [dbo].[cust] ([id], [name], [category_id]) VALUES (N'5', N'Наталья', N'8')
GO
GO
INSERT INTO [dbo].[cust] ([id], [name], [category_id]) VALUES (N'6', N'Егор', N'1')
GO
GO
INSERT INTO [dbo].[cust] ([id], [name], [category_id]) VALUES (N'7', N'Максим', N'1')
GO
GO
INSERT INTO [dbo].[cust] ([id], [name], [category_id]) VALUES (N'8', N'Денис', N'1')
GO
GO
SET IDENTITY_INSERT [dbo].[cust] OFF
GO

-- ----------------------------
-- Indexes structure for table books
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table books
-- ----------------------------
ALTER TABLE [dbo].[cust] ADD PRIMARY KEY ([id])
GO

-- ----------------------------
-- Triggers structure for table books
-- ----------------------------
DROP TRIGGER [dbo].[Trigger]
GO
CREATE TRIGGER [dbo].[Trigger]
ON [dbo].[cust]
AFTER INSERT, UPDATE
AS
 
BEGIN  
    SET NOCOUNT ON;

    DECLARE @action as char(6);

    SET @action = 'Insert'; 
    IF EXISTS(SELECT * FROM DELETED)
    BEGIN
        SET @action = 
            CASE
                WHEN EXISTS(SELECT * FROM INSERTED) THEN 'Update' 
            END
    END
    ELSE 
        IF NOT EXISTS(SELECT * FROM INSERTED) RETURN;


		INSERT Audit(name,category_id, Action)
		SELECT name, category_id, @action FROM Inserted
END

GO
