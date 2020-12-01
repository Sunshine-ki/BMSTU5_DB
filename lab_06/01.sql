-- CREATE TABLE IF NOT EXISTS blacklist
-- (
--     user_id INT,
--     FOREIGN KEY (user_id) REFERENCES users(id),
--     world_id INT,
--     FOREIGN KEY (world_id) REFERENCES world(id),
--     reason VARCHAR -- Причина.
-- );

drop table blacklist;

select * from blacklist;

INSERT INTO blacklist VALUES (1,2,'Оскорбления');

SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='blacklist'