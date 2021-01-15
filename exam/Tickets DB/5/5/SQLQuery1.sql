DROP TABLE Audit
GO

CREATE TABLE Audit
(
	[BankID] int NOT NULL ,
	[BankName] nvarchar(40) NOT NULL ,
	[BankRating] nvarchar(40) NULL ,
	[Action] nvarchar(6) NOT NULL DEFAULT ('ACT'),
	[ChangedDate] datetime NOT NULL DEFAULT (getdate()) ,
	[ChangedBy] nvarchar(50) NOT NULL DEFAULT (suser_sname()) 
)
GO

DROP TRIGGER auditTrigger
GO

CREATE TRIGGER auditTrigger
ON Audit
AFTER INSERT, UPDATE, DELETE
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

	if @action = 'Update' OR @action = 'Insert'
		INSERT Audit(BankID, BankName, BankRating, Action)
		SELECT BankID, BankName, BankRating, @action FROM Inserted
	else if @action = 'Delete'
		INSERT Audit(BankID, BankName, BankRating, Action)
		SELECT BankID, BankName, BankRating, @action FROM deleted
END
GO

INSERT INTO Audit (BankID, BankName, BankRating)
VALUES (101, 'HEH', 'HEH')

DELETE
FROM Audit
WHERE Action = 'ACT'

UPDATE Audit
SET BankID = 1
WHERE BankID = 102

SELECT *
FROM Audit
