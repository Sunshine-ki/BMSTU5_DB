use DB_BANK
go

DROP TABLE [dbo].[Audit]
GO
CREATE TABLE [dbo].[Audit] (
[BankID] int NOT NULL ,
[BankName] nvarchar(40) NOT NULL ,
[BankRating] nvarchar(40) NULL ,
[Action] nvarchar(6) NOT NULL ,
[ChangedDate] datetime NOT NULL DEFAULT (getdate()) ,
[ChangedBy] nvarchar(50) NOT NULL DEFAULT (suser_sname()) 
)
GO

DROP TRIGGER [dbo].[BanksTrigger]
GO
CREATE TRIGGER [dbo].[BanksTrigger]
ON [dbo].[Banks]
AFTER DELETE, UPDATE
AS
BEGIN  
    DECLARE @action as char(6);

    SET @action = 'Insert'; 
    IF EXISTS(SELECT * FROM DELETED)
    BEGIN
        SET @action = 
            CASE
                WHEN EXISTS(SELECT * FROM INSERTED) THEN 'Update' 
                ELSE 'Delete'       
            END
    END
    ELSE 
        RETURN;

	if @action = 'Update'
		INSERT Audit(BankID, BankName, BankRating, Action)
		SELECT BankID, BankName, BankRating, @action FROM Inserted
	else
		INSERT Audit(BankID, BankName, BankRating, Action)
		SELECT BankID, BankName, BankRating, @action FROM deleted
END
GO

/*
UPDATE Banks
SET BankRating = 'ÀÀÀ'
WHERE BankID = 1;
go

insert into BANKS (BankID, BankName, BankRating, RegistrationNumber, ParentID)
values (101, 'RoubleCrash', 'ÂÂÂ-', 666, NULL)
go

delete from BANKS where BankID = 101
go*/

select * from Audit
go

select * from BANKS
go