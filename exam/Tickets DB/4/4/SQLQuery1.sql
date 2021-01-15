DROP TABLE employee
GO

CREATE TABLE employee
(
	employee_id char(6) NOT NULL PRIMARY KEY,
	first_name varchar(20) NOT NULL,
	last_name varchar(20) NOT NULL,
	salary decimal(12,2) NOT NULL
)
GO

DROP TABLE employee_auditTrail
GO

CREATE TABLE employee_auditTrail
(
	employee_id char(6) NOT NULL,
	first_name varchar(20) NOT NULL,
	last_name varchar(20) NOT NULL,
	salary decimal(12,2) NOT NULL,
-- DOPOLNITELNYE STOLBCI
	action char(6) NOT NULL CHECK(action in ('delete', 'update')),
	date_changed datetime2(0) NOT NULL DEFAULT (SYSDATETIME()),
	changed_by_user_name sysname NOT NULL DEFAULT (original_login()),
	CONSTRAINT PK_auditTrail PRIMARY KEY (employee_id, date_changed)
)
GO

INSERT employee (employee_id, first_name, last_name, salary)
VALUES (1, 'Phillip', 'Taibul', 10000),
	   (2, 'Peter', 'Talib', 420228);

SELECT *
FROM employee
GO

DROP TRIGGER emp_trig
GO

CREATE TRIGGER dbo.emp_trig
ON dbo.employee
AFTER UPDATE, DELETE
AS
BEGIN
	DECLARE @action as CHAR(6);
	
	SET @action = 'DELETE'
	IF EXISTS(SELECT * FROM inserted)
	BEGIN
		SET @action = 'UPDATE'
	END

	IF @action = 'UPDATE'
	BEGIN
		INSERT employee_auditTrail(employee_id, first_name, last_name, salary, action)
		SELECT employee_id, first_name, last_name, salary, @action FROM inserted
	END
	ELSE
	BEGIN
		INSERT employee_auditTrail(employee_id, first_name, last_name, salary, action)
		SELECT employee_id, first_name, last_name, salary, @action FROM deleted
	END
END
GO


UPDATE employee
SET last_name = 'Akhmed'
WHERE last_name = 'Talib'

SELECT * FROM employee
SELECT * FROM employee_auditTrail

DELETE FROM employee
WHERE employee_id = 1

SELECT * FROM employee
SELECT * FROM employee_auditTrail