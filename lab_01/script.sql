-- \i lab_01/script.sql

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

-- copy world from '/home/lis/university/github/database/lab_01/world.csv' delimiter ',';

CREATE TABLE IF NOT EXISTS device
(
	id INT NOT NULL PRIMARY KEY,
	company  VARCHAR(16) DEFAULT 'secret',
	year_of_issue INT CHECK(year_of_issue >= 2000 AND year_of_issue <= 2120),
	color  VARCHAR(16) DEFAULT 'white',
	price INT CHECK (price >= 0 AND price <= 100000)
);

-- copy device from 'lab_01/device.csv' delimiter ',';

CREATE TABLE IF NOT EXISTS users
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

-- copy users from 'lab_01/user.csv' delimiter ',';

CREATE TABLE IF NOT EXISTS world_user
(
	id_world INT,
	FOREIGN KEY (id_world) REFERENCES world(id),
	id_user INT,
	FOREIGN KEY (id_user) REFERENCES users(id)
);

-- /home/lis/university/github/database/
-- copy world_user from 'lab_01/world_user.csv' delimiter ',';


CREATE TABLE IF NOT EXISTS device_history 
(
	-- id INT NOT NULL PRIMARY KEY,
	id_user INT,
	FOREIGN KEY (id_user) REFERENCES users(id),
	id_device INT,
	FOREIGN KEY (id_device) REFERENCES device(id),
	year_begin INT CHECK(year_begin >= 2000 and year_begin <= 2120),
	year_end INT CHECK(year_end >= 2000 and year_end <= 2120)
);


CREATE TABLE IF NOT EXISTS users_black_list
(
    id INT NOT NULL PRIMARY KEY,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id),
    world_id INT,
    FOREIGN KEY (world_id) REFERENCES world(id)
);


-- copy device_history from 'lab_01/device_history.csv' delimiter ',';

-- INSERT INTO world(id, name) VALUES(1001, 'Name');
-- INSERT INTO user VALUES(1001,'Alice',20,'f',0,123);
-- SELECT * FROM user WHERE sex='f' and age >= 15 and age <= 30;
-- SELECT *
-- FROM world;