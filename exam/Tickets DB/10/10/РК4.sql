USE tempdb
GO

CREATE TABLE Version
(
	DatabaseVersion varchar(10) NOT NULL
);
GO

INSERT INTO Version (DatabaseVersion)
VALUES ('1.0.12')
GO

CREATE TRIGGER Restriction ON Version
INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN
	RAISERROR('Изменения запрещены', 12, 1)
END
GO


SELECT *
FROM Version
GO