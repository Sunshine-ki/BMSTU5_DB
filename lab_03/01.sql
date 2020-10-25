-- $$ - тело процедуры.
-- CREATE FUNCTION first_function()
-- RETURNS int AS $$
--     DECLARE ret int;
--     BEGIN
--         SELECT ret = MAX(id)
--         FROM users;
--         RETURN ret;
--     END;
-- $$ LANGUAGE plpgsql;

-- A.1. Скалярная функция.
-- Возвращает max. кол-во часов.
CREATE FUNCTION get_max_number_of_hours()
RETURNS INT AS '
    SELECT  MAX(number_of_hours)
    FROM users;
' LANGUAGE sql;

SELECT get_max_number_of_hours() AS max_hours;

-- A.2. Подставляемую табличную функцию.
-- Возвращает пользователя по id.
CREATE FUNCTION get_user(u_id INT = 0) -- По умолчанию == 0.
RETURNS users AS '
    SELECT *
    FROM users
    WHERE id = u_id;
' LANGUAGE  sql;

-- get_user(id) - вернет один кортеж.
-- Т.к. известно, что этот кортеж типа "user"
-- То мы можем селект запросом вывести этот кортеж как таблицу.
SELECT *
FROM get_user(15);

-- A.3. Многооператорную табличную функцию.
-- Вернуть таблицу игр с заданным возратсным ограничением.
CREATE FUNCTION get_world_by_age_restrictions(age_rest INT)
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
'LANGUAGE  sql;


SELECT *
FROM get_world_by_age_restrictions(18);
