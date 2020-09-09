-- source /home/lis/university/github/database/lab_01/script.sql

CREATE TABLE world
(
	-- IDENTITY(1, 1) 
	id int NOT NULL PRIMARY KEY,
	name VARCHAR(64),
	founder VARCHAR(32) DEFAULT 'secret',
	-- CHECK - ограничений для данных, вводимых в таблицы.
	year_of_issue int CHECK(year_of_issue >=2000 AND year_of_issue <= 2120),
	genre VARCHAR(32) DEFAULT 'life',
	age_restrictions int CHECK(age_restrictions >= 0 and age_restrictions <= 100),
	price int CHECK (price >= 0)
);

LOAD DATA LOCAL
INFILE '/home/lis/university/github/database/lab_01/world.csv'
INTO TABLE world
FIELDS TERMINATED BY ',';

CREATE TABLE user
(
	id int NOT NULL PRIMARY KEY,
	nickname VARCHAR(32),
	age int CHECK (age>=0 and age <=100),
	sex char,
	number_of_hours int CHECK (number_of_hours >= 0 and number_of_hours <=5000)
);

LOAD DATA LOCAL
INFILE '/home/lis/university/github/database/lab_01/user.csv'
INTO TABLE user
FIELDS TERMINATED BY ',';

CREATE TABLE device
(
	id int NOT NULL PRIMARY KEY,
	company VARCHAR(16) DEFAULT 'secret',
	year_of_issue int CHECK(year_of_issue >=2000 AND year_of_issue <= 2120),
	color VARCHAR(16) DEFAULT 'white',
	price int CHECK (price >= 0 and price <= 100000)
);

LOAD DATA LOCAL
INFILE '/home/lis/university/github/database/lab_01/device.csv'
INTO TABLE device
FIELDS TERMINATED BY ',';

select *
from world;