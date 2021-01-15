USE tempdb
GO

DROP TABLE AccountActivity
GO

DROP TABLE Account
GO

CREATE TABLE Account
(
	AccountNumber char(10) PRIMARY KEY
)
GO

CREATE TABLE AccountActivity
(
	AccountNumber char(10) NOT NULL FOREIGN KEY REFERENCES Account(AccountNumber),
	TransactionNumber char(20) NOT NULL,
	Date datetime2(3) NOT NULL,
	TransactionAmount numeric(12,2) NOT NULL,
	CONSTRAINT PK_AccountActivity PRIMARY KEY (AccountNumber, TransactionNumber)
)
GO

--INSERT INTO Account (AccountNumber)
--VALUES ('1111111111'), ('2222222222');
INSERT INTO AccountActivity(AccountNumber, TransactionNumber, Date, TransactionAmount)
VALUES	('1111111111', 'A0000000000000000001', '20050712', 100)/*,
		('1111111111', 'A0000000000000000002', '20050713', 100),
		('1111111111', 'A0000000000000000003', '20050713', 100),
		('1111111111', 'A0000000000000000004', '20050714', 100),
		('2222222222', 'A0000000000000000005', '20050715', 100),
		('2222222222', 'A0000000000000000006', '20050715', 100);*/
GO

DROP TRIGGER Tr
GO

CREATE TRIGGER Tr 
ON AccountActivity
AFTER DELETE
AS
BEGIN
	DECLARE @del_amount AS INT

	SET @del_amount = 
		(
			SELECT TransactionAmount
			FROM deleted
		)

	IF @del_amount >= 100
	BEGIN
		DECLARE @AC_NUM AS Char(10)
		SET @AC_NUM = (SELECT AccountNumber FROM deleted)

		DECLARE @MON AS numeric(12,2)
		SET @MON = (SELECT TransactionAmount FROM deleted)

		DECLARE @STR_MON AS VarChar(100)
		SET @STR_MON = convert(varchar(10), @MON)
		
		RAISERROR(''' The balance for Account %s
						has been decremented by %s''', 12, 1, @AC_NUM, @STR_MON)
	END
END
GO


SELECT * FROM AccountActivity

INSERT INTO AccountActivity(AccountNumber, TransactionNumber, Date, TransactionAmount)
VALUES	('1111111111', 'A0000000000000000001', '20050712', 100)
DELETE 
FROM AccountActivity
WHERE TransactionNumber = 'A0000000000000000001'