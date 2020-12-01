-- 16.Однострочная инструкция INSERT,
-- выполняющая вставку в таблицу одной строки значений.
INSERT INTO device(id, company, year_of_issue, color, price) 
VALUES(1000, 'OOO coral', 2020, 'blue', 10000);

INSERT into users (id, nickname, age, sex, number_of_hours, id_device)
VALUES (4001, 'Alice', 20, 'f', 1000, 123);

-- 17. Многострочная инструкция INSERT, выполняющая вставку в таблицу
-- результирующего набора данных вложенного подзапроса.
-- Вставляем юзеров
INSERT INTO users (id, id_device)
SELECT id * 1000 as ID,  id_device as ID_DEVECE
FROM users
WHERE id > 100 AND id < 150 AND sex='f';

-- 18. Простая инструкция UPDATE.
UPDATE users 
SET number_of_hours = number_of_hours + 10, sex = 'm'
WHERE id = 1000;

-- 19. Инструкция UPDATE со скалярным подзапросом в предложении SET.
-- Изменить цену какого-то мира на самую дорогую. 
UPDATE world
SET price = 
(
	SELECT MAX(price)
	FROM world
)
WHERE id = 0;

-- 20. Простая инструкция DELETE.
DELETE FROM users
WHERE nickname = 'Alice';

-- 21. Инструкция DELETE с вложенным коррелированным
-- подзапросом в предложении WHERE.
-- Удалить историю всех девайсов с 'red' цветом шлема.
DELETE FROM device_history
WHERE id_device in
(
    SELECT id
    FROM device
    WHERE color='red'
);

-- 22. Инструкция SELECT, использующая
-- простое обобщенное табличное выражение
WITH meow (id_device, sex)
AS
(
    SELECT u.id_device, u.sex FROM users AS u
)
SELECT * FROM meow;

WITH CTEworld
AS
(
    SELECT * FROM world
)
SELECT * FROM  CTEworld;

-- 23. Инструкция SELECT, использующая
-- рекурсивное обобщенное табличное выражение.
-- Создаем таблицу.
-- (Загрузить туда данные далее нужно не забыть...)
CREATE TABLE UsersTest
(
    id INT NOT NULL PRIMARY KEY,
    invited_id  INT,
	name VARCHAR(32)
);

-- Собственно сам рекурсивный запрос.
-- Вывести цепочку (кого пригласил) определенный юзер.
WITH RECURSIVE RecursiveUsers(id, invited_id, name)
AS
(
    -- Определение закрепленного элемента.
    SELECT id, invited_id, name
    FROM UsersTest U_T
    WHERE U_T.ID = 1
    UNION ALL
    -- Определение рекурсивного элемента
    SELECT U_T.id, U_T.invited_id, U_T.name
    FROM UsersTest U_T
    JOIN RecursiveUsers rec ON U_T.invited_id=rec.id
)
SELECT *
FROM RecursiveUsers;


-- 24. Оконные функции.
-- Использование конструкций MIN/MAX/AVG OVER()
-- Вывести сумму кол-ва часов по группам возраста.
SELECT id, nickname,  age, SUM(number_of_hours) OVER(PARTITION BY age) sum
FROM users
ORDER BY id;

WITH new_table (id, nickname, age, sum)
AS
(
    SELECT id, nickname,  age, SUM(number_of_hours) OVER(PARTITION BY age) sum
    FROM users
    ORDER BY id
)
SELECT * FROM new_table;

