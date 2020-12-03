select * from pg_language;

-- create extension plpython3u;

-- 1) Определяемую пользователем скалярную функцию CLR.
-- Получить название мира по id.
CREATE OR REPLACE FUNCTION get_world_name(user_id INT)
RETURNS VARCHAR
AS $$
res = plpy.execute(f" \
    SELECT name \
    FROM world  \
    WHERE id = {user_id};")
if res:
    return res[0]['name']
$$ LANGUAGE plpython3u;

SELECT * FROM get_world_name(5) as "World name";

-- 2) Пользовательскую агрегатную функцию CLR.
-- Получить кол-во шлемов заданного цвета.
CREATE OR REPLACE FUNCTION count_color(a INT, clr VARCHAR)
RETURNS INT
AS $$
# res = plpy.execute(f" \
#     SELECT COUNT(id) \
#     FROM device      \
#     WHERE color = \'{clr}\';")

count = 0
res = plpy.execute("SELECT * FROM device")

for elem in res:
    if elem["color"] == clr:
        count += 1

return count
$$ LANGUAGE plpython3u;

-- TODO: Защита сделалать агрегат.
CREATE AGGREGATE count_color_agr(VARCHAR)
(
    -- Функция состояния.
    SFUNC = count_color,
    STYPE = INT
);

SELECT count_color_agr('black') FROM users;

-- Проверка:
SELECT color, COUNT(color)
FROM device
GROUP BY color;

-- Получить кол-во игдроков в мире (передается id мира)
SELECT COUNT(w.id)
FROM world w JOIN world_user wu on w.id = wu.id_world
JOIN users u on u.id = wu.id_user
WHERE w.id = 0;

CREATE OR REPLACE FUNCTION count_users(world_id INT)
RETURNS INT
AS $$
res = plpy.execute(f" \
    SELECT COUNT(w.id) \
    FROM world w JOIN world_user wu on w.id = wu.id_world \
    JOIN users u on u.id = wu.id_user \
    WHERE w.id = {world_id};")

return res[0]["count"]
$$ LANGUAGE plpython3u;

SELECT * FROM count_users(0);

-- 3) Определяемую пользователем табличную функцию CLR.
-- Возвращает пользователей с заданным цветом шлема.
CREATE OR REPLACE FUNCTION count_users_in_color(cls VARCHAR)
RETURNS TABLE
(
    id INT,
    nickname VARCHAR,
    sex CHAR
)
AS $$
# return value
rv = plpy.execute(f" \
SELECT users.id as id, nickname, sex, color \
FROM users JOIN device d on d.id = users.id_device")
res = []
for elem in rv:
    if elem["color"] == cls:
        res.append(elem)
return res
$$ LANGUAGE plpython3u;

SELECT * FROM count_users_in_color('white');

-- Проверка:
SELECT users.id as id, nickname, sex, color
FROM users JOIN device d on d.id = users.id_device
WHERE color = 'white';


-- 4) Хранимую процедуру CLR.
-- Добавляет нового пользователя.
CREATE OR REPLACE PROCEDURE add_user
(
    id INT,
    nickname VARCHAR,
    age INT,
    sex CHAR,
    number_of_hours INT,
    id_device INT
) AS $$
# Чтобы юзать так, нужно подругому назвать входные параметры.
# plpy.execute(f"INSERT INTO users VALUES({id}, \'{nick name}\', \'{sex}\', {number_of_hours}, {id_device});")

# Функция plpy.prepare подготавливает план выполнения для запроса.
# Передается строка запроса и список типов параметров.
plan = plpy.prepare("INSERT INTO users VALUES($1, $2, $3, $4, $5, $6)", ["INT", "VARCHAR", "INT","CHAR", "INT", "INT"])
rv = plpy.execute(plan, [id, nickname, age, sex, number_of_hours, id_device])
$$ LANGUAGE plpython3u;

CALL add_user(1004, 'Alice', 20, 'f', 1000, 234);

-- create table test_str(a INT, b VARCHAR);
-- insert into test_str VALUES (0, 'Alice');
-- SELECT * FROM test_str;
-- CREATE OR REPLACE PROCEDURE add_str_test
-- (
--     id INT,
--     name VARCHAR
-- ) AS $$
-- plpy.execute(f"INSERT INTO test_str VALUES({id}, \'{name}\');")
-- $$ LANGUAGE plpython3u;
--
-- CALL add_str_test(3, 'Misha');


-- 5) Триггер CLR.
-- Создаем представление, т.к. таблицы не могут иметь INSTEAD OF triggers.
CREATE VIEW users_new AS
SELECT * -- INTO device_new
FROM users
WHERE id < 15;

SELECT * FROM users_new;

-- Заменяем удаление на мягкое удаление.
CREATE OR REPLACE FUNCTION del_users_func()
RETURNS TRIGGER
AS $$
old_id = TD["old"]["id"]
rv = plpy.execute(f" \
UPDATE users_new SET nickname = \'none\'  \
WHERE users_new.id = {old_id}")

return TD["new"]
$$ LANGUAGE plpython3u;

CREATE TRIGGER del_user_trigger
-- INSTEAD OF - Сработает вместо указанной операции.
INSTEAD OF DELETE ON users_new
-- Триггер с пометкой FOR EACH ROW вызывается один раз для каждой строки,
-- изменяемой в процессе операции.
FOR EACH ROW
EXECUTE PROCEDURE del_users_func();

DELETE FROM users_new
WHERE nickname = 'Colace';

-- 6) Определяемый пользователем тип данных CLR.
-- Тип содержит цвет и кол-во шлемов такого цвета.
CREATE TYPE color_count AS
(
	color VARCHAR,
	count INT
);

CREATE OR REPLACE FUNCTION get_color_count(clr VARCHAR)
RETURNS color_count
AS
$$
plan = plpy.prepare("      \
SELECT color, COUNT(color) \
FROM device                \
WHERE color = $1           \
GROUP BY color;", ["VARCHAR"])

# return value
rv = plpy.execute(plan, [clr])

# nrows - возвращает кол-во строк, обработанных командой.
if (rv.nrows()):
    return (rv[0]["color"], rv[0]["count"])
$$ LANGUAGE plpython3u;

SELECT * FROM get_color_count('white');

-- CREATE OR REPLACE FUNCTION test(a INT, b INT)
-- RETURNS INT AS '
-- 	if a > b:
-- 		return a
-- 	return b
-- ' LANGUAGE plpython3u;
--
-- SELECT test(5,39);

-- CREATE TYPE num_value AS
-- (
-- 	a INT,
-- 	b INT
-- );
--
-- CREATE OR REPLACE FUNCTION make_pair(a INT, b INT)
-- RETURNS num_value
-- AS
-- '
--     return [a, b]
-- 'LANGUAGE plpython3u;
--
-- SELECT * FROM make_pair(1, 21);

