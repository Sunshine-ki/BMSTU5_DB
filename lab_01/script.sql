-- source /home/lis/university/github/database/lab_01/script.sql

CREATE TABLE IF NOT EXISTS world
(
	id INT NOT NULL PRIMARY KEY,
	name  VARCHAR(100),
	founder  VARCHAR(32) DEFAULT 'secret',
	-- CHECK - ограничений для данных, вводимых в таблицы.
	year_of_issue INT CHECK(year_of_issue >= 2000 AND year_of_issue <= 2120),
	genre  VARCHAR(64) DEFAULT 'life',
	age_restrictions INT CHECK(age_restrictions >= 0 and age_restrictions <= 100),
	price INT CHECK (price >= 0)
);

LOAD DATA LOCAL
INFILE '/home/lis/university/github/database/lab_01/world.csv'
INTO TABLE world
FIELDS TERMINATED BY ',';

CREATE TABLE IF NOT EXISTS device
(
	id INT NOT NULL PRIMARY KEY,
	company  VARCHAR(16) DEFAULT 'secret',
	year_of_issue INT CHECK(year_of_issue >= 2000 AND year_of_issue <= 2120),
	color  VARCHAR(16) DEFAULT 'white',
	price INT CHECK (price >= 0 AND price <= 100000)
);

LOAD DATA LOCAL
INFILE '/home/lis/university/github/database/lab_01/device.csv'
INTO TABLE device
FIELDS TERMINATED BY ',';

CREATE TABLE IF NOT EXISTS user
(
	id INT NOT NULL PRIMARY KEY,
	nickname  VARCHAR(32),
	age INT CHECK (age >= 0 and age <= 100),
	sex CHAR,
	number_of_hours INT CHECK (number_of_hours >= 0 and number_of_hours <= 5000),
	-- Вторичный ключ id_device ссылается на device(id).
	id_device INT,
	FOREIGN KEY (id_device) REFERENCES device(id)
);

LOAD DATA LOCAL
INFILE '/home/lis/university/github/database/lab_01/user.csv'
INTO TABLE user
FIELDS TERMINATED BY ',';

CREATE TABLE IF NOT EXISTS world_user
(
	id_world INT,
	FOREIGN KEY (id_world) REFERENCES world(id),
	id_user INT,
	FOREIGN KEY (id_user) REFERENCES user(id)
);

LOAD DATA LOCAL
INFILE '/home/lis/university/github/database/lab_01/world_user.csv'
INTO TABLE world_user
FIELDS TERMINATED BY ',';


CREATE TABLE IF NOT EXISTS device_history 
(
	-- id INT NOT NULL PRIMARY KEY,
	id_user INT,
	FOREIGN KEY (id_user) REFERENCES user(id),
	id_device INT,
	FOREIGN KEY (id_device) REFERENCES device(id),
	year_begin INT CHECK(data_begin >= 2000 and data_begin <= 2120),
	year_end INT CHECK(data_end >= 2000 and data_end <= 2120)
);

LOAD DATA LOCAL
INFILE '/home/lis/university/github/database/lab_01/device_history.csv'
INTO TABLE device_history
FIELDS TERMINATED BY ',';

-- INSERT INTO world(id, name) VALUES(1001, 'Name');
-- INSERT INTO user VALUES(1001,'Alice',20,'f',0,123);
-- SELECT * FROM user WHERE sex='f' and age >= 15 and age <= 30;
-- SELECT *
-- FROM world;