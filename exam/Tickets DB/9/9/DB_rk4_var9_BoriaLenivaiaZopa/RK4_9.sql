USE [DB_BANK]
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name='tempdb1')
	DROP DATABASE [tempdb1]
GO	

CREATE DATABASE [tempdb1]
GO

DROP Table [dbo].[WeatherReading]
go
DROP Table [dbo].[WeatherReading_exception]
go

CREATE TABLE WeatherReading
(
WeatherReadingId int NOT NULL identity PRIMARY KEY,
ReadingTime datetime2(3) NOT NULL UNIQUE,
Temperature float NOT NULL CHECK(Temperature between -80 and 150)
);
GO

CREATE TABLE WeatherReading_exception
(
WeatherReadingId int NOT NULL identity PRIMARY KEY,
ReadingTime datetime2(3) NOT NULL,
Temperature float NOT NULL
);
GO

CREATE TRIGGER [dbo].[Trigger]
ON [dbo].[WeatherReading]
INSTEAD OF INSERT
AS
BEGIN
	declare @rt datetime2(3), @t float, @id int
	
	declare [cursor] cursor
	global
	for 
		select b.ReadingTime, b.Temperature, b.WeatherReadingId from inserted b
	open [cursor];
	fetch  next from [cursor] into @rt, @t, @id

	SET XACT_ABORT OFF;
	while (@@FETCH_STATUS=0)
	begin
		begin transaction;
		print @@TRANCOUNT;
		BEGIN TRY
			insert into WeatherReading(ReadingTime, Temperature)
			values (@rt, @t);
			commit transaction
		END TRY
		BEGIN CATCH
			commit transaction
			if @@TRANCOUNT > 0
			begin
				if error_number() = 547
				begin
					begin transaction
					insert into WeatherReading_exception(ReadingTime, Temperature)
					values (@rt, @t);
					commit transaction
				end
				else
					ROLLBACK TRANSACTION
			end;
		END CATCH;
		fetch  next from [cursor] into @rt, @t, @id
	end
	close [cursor]
	DEALLOCATE [cursor]
END;
GO

INSERT INTO WeatherReading (ReadingTime, Temperature)
VALUES ('20080101 0:00',82.00), 
('20080101 0:01',89.22),
('20080101 0:02',600.32),
('20080101 0:03',88.22),
('20080101 0:04',99.01);
go

select * from WeatherReading
go

select * from WeatherReading_exception
go