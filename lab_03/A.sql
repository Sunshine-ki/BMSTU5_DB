-- A.1. Скалярная функция.
-- Возвращает max. кол-во часов.
CREATE OR REPLACE FUNCTION get_max_number_of_hours()
RETURNS INT AS '
    SELECT  MAX(number_of_hours)
    FROM users;
' LANGUAGE sql;

SELECT get_max_number_of_hours() AS max_hours;

-- A.2. Подставляемую табличную функцию.
-- Возвращает пользователя по id.
CREATE OR REPLACE FUNCTION get_user(u_id INT = 0) -- По умолчанию == 0.
RETURNS users AS '
    SELECT *
    FROM users
    WHERE id = u_id;
' LANGUAGE  sql;

-- get_user(id) - вернет один кортеж.
-- Т.к. известно, что этот кортеж типа "user"
-- То мы можем селект запросом вывести этот кортеж как таблицу.
SELECT *
FROM get_user(21);

-- A.3. Многооператорную табличную функцию.
-- Вернуть таблицу игр с заданным возратсным ограничением.
CREATE OR REPLACE FUNCTION get_world_by_age_restrictions(age_rest INT)
RETURNS TABLE
(
    id INT,
    name  VARCHAR,
    founder  VARCHAR,
    genre VARCHAR
)
AS '
    SELECT id, name, founder, genre
    FROM world
    WHERE age_restrictions=age_rest;
    -- TODO: Добавить inset, либо select на другую таблицу
'LANGUAGE  sql;


SELECT *
FROM get_world_by_age_restrictions(18);

-- TODO: На свою таблицу переписать рекурсию.

-- A.4. Рекурсивную функцию или функцию с рекурсивным ОТВ
-- Фибоначи. Аргументы:
-- Два числа последовательности
-- И предел (до какого числа нужно идти).
-- RETURN QUERY добавляет результат выполнения запроса к результату функции.
CREATE OR REPLACE FUNCTION fib(first INT, second INT,max INT)
RETURNS TABLE (fibonacci INT)
AS '
BEGIN
    RETURN QUERY
    SELECT first;
    IF second <= max THEN
        RETURN QUERY
        SELECT *
        FROM fib(second, first + second, max);
    END IF;
END' LANGUAGE plpgsql;

SELECT *
FROM fib(1,1, 13);