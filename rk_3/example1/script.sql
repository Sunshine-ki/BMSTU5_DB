-- TIME:
-- https://www.postgresql.org/docs/current/functions-datetime.html

-- Задание 1 часть 1.
CREATE TABLE IF NOT EXISTS employee
(
    id INT PRIMARY KEY,
    name VARCHAR(32),
    surname VARCHAR(32),
    date_of_birth DATE,
    department VARCHAR(64)
);


CREATE TABLE IF NOT EXISTS employee_visit
(
    id INT PRIMARY KEY,
    employee_id INT,
    FOREIGN KEY (employee_id) REFERENCES employee(id),
    employee_data DATE DEFAULT CURRENT_DATE,
    day_of_week VARCHAR,
    employee_time TIME DEFAULT CURRENT_TIME,
    type INT CHECK (type >= 1 AND type <= 2) -- 1 - приешл, 2 - вышел
);


SELECT * FROM employee
ORDER BY date_of_birth;

-- Задание 1 часть 2.
-- Кол-во опоздавших сотрудников.
-- Дата опоздания в кач-ве параметра.
CREATE OR REPLACE FUNCTION get_latecomers(dt DATE)
RETURNS INT
AS
$$
    SELECT COUNT(id) AS cnt
    FROM employee_visit
    WHERE employee_data = dt
    AND employee_time > '09:00:00'
    AND type = 1;
$$ LANGUAGE SQL;

SELECT get_latecomers('2020-11-15') AS cnt;

-- Задание 2.

-- -- Если сотрудник e_id опаздывал, то вернутся его отдел.
-- CREATE OR REPLACE FUNCTION get_count_latecomers(e_id INT)
-- RETURNS VARCHAR
-- AS
-- $$
--     SELECT department
--     FROM employee e
--     WHERE e.id = e_id
--     -- И если существет таблица, показывающая
--     -- В какие недели работник опаздывал,
--     -- То выводим его отдел.
--     AND EXISTS
--     (
--         -- Внутренный запрос вернет таблицу, в которой
--         -- Первой столбец будет неделя (по счету, первая, вторя...)
--         -- А второй, кол-во опозданий сотрудника в этой недели.
--         -- Соотвтетственно, если опозданий нет, то таблица пуста.
--         SELECT date_part, COUNT(date_part) AS cnt
--         FROM
--         (
--             SELECT *
--             FROM employee_visit, EXTRACT(WEEK FROM employee_data) AS date_part
--             WHERE employee_time > '09:00:00'
--             AND type = 1
--             AND employee_id = e_id
--         ) AS tmp
--         GROUP BY date_part
--         HAVING COUNT(date_part) > 2
--     );
-- $$ LANGUAGE SQL;

-- 1. Отделы, в которых сотрудники опаздывают более 2х раз в неделю
-- (По заданию 3х раз, но я сделала 2х, чтобы много данных в таблицу не добавлять)
SELECT id, department
FROM employee t1
WHERE EXISTS
(
    SELECT department
    FROM employee e
--     WHERE e.id = t1.id
    -- И если существет таблица, показывающая
    -- В какие недели работник опаздывал,
    -- То выводим его отдел.
    WHERE EXISTS
    (
        -- Внутренный запрос вернет таблицу, в которой
        -- Первой столбец будет неделя (по счету, первая, вторя...)
        -- А второй, кол-во опозданий сотрудника в этой недели.
        -- Соотвтетственно, если опозданий нет, то таблица пуста.
        SELECT date_part, COUNT(date_part) AS cnt
        FROM
        (
            SELECT *
            FROM employee_visit, EXTRACT(WEEK FROM employee_data) AS date_part
            WHERE employee_time > '09:00:00'
            AND type = 1
            AND employee_id = t1.id
        ) AS tmp
        GROUP BY date_part
        HAVING COUNT(date_part) > 2
    )
);

-- 2.
-- Найти средний возраст сотрудников, не находящихся
-- на рабочем месте 8 часов в неделю.

-- Получиь возраст.
SELECT *, (CURRENT_DATE - e.date_of_birth) / 7 / 52  -- 7 - дней в неделе, 52 - недель в году.
FROM employee e;

-- Либо можно так:
-- SELECT *, EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM e.date_of_birth)
-- FROM employee e;

-- Сотрудник, который не находится на рабочем месте 8 часов в неделю
-- (Я сделала 9 часов, т.к. в таблице все работают как минимум 8 часов)


SELECT AVG(age)
FROM (
    SELECT *, (CURRENT_DATE - employee.date_of_birth) / 7 / 52 AS age   -- 7 - дней в неделе, 52 - недель в году.
    FROM
    (
        SELECT *,
        (
            SELECT EXTRACT(HOURS FROM e_v2.employee_time) - EXTRACT(HOURS FROM e_v.employee_time) -- e_v2.employee_time - e_v.employee_time
            FROM employee_visit e_v2
            WHERE employee_id = e_v.employee_id
            AND e_v2.employee_data = e_v.employee_data
            AND type = 2
        ) AS working_hours
        FROM employee_visit e_v
        WHERE type = 1
    ) AS tmp JOIN employee ON tmp.employee_id = employee.id
    WHERE working_hours <= 9) AS table_res;

SELECT *, e_v.employee_time
FROM employee_visit e_v;


-- 3. Все отделы и кол-во сотрудников
-- Хоть раз опоздавших за всю историю учета.
SELECT department, COUNT(employee.id)
FROM employee
JOIN employee_visit ev on employee.id = ev.employee_id
WHERE employee_time > '09:00:00'
AND type = 1
GROUP BY department;


-- Merci ORM <3
-- Запрос 2.
SELECT table1.department
FROM employee AS table1
INNER JOIN employee_visit AS table2 ON (table2.employee_id = table1.id)
WHERE ((table2.employee_time > '09:00:00') AND (table2.type = 1))
GROUP BY table1."department"
HAVING Count(table1.id) > 2


