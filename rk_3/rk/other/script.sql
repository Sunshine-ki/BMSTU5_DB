-- ВАРИАНТ 1
-- Написать скалярную функцию, возвращающую количество сотрудников
-- в возрасте от 18 до 40, выходивших более 3х раз.

-- date_part:
-- Первый аргумент "какая часть?"
-- Второй аргумент date
-- age(timestamp) - вичитает из текущей даты дату, указанную аргументом.
CREATE OR REPLACE FUNCTION count_employee()
RETURNS INT
AS
$$
WITH new_table (id, cnt)
AS
(
    SELECT employee.id, COUNT(employee.id)
    FROM employee JOIN employee_attendance ea on employee.id = ea.employee_id
    WHERE date_part('year', age(date_of_birth)) > 18
    AND date_part('year', age(date_of_birth)) < 40
    AND ea.type = 1
    GROUP BY employee.id
    HAVING COUNT(employee.id) > 3
)
SELECT COUNT(*) FROM new_table;
$$LANGUAGE SQL;

SELECT date_part('year', age('2000-07-19'::date));

SELECT * FROM count_employee() AS cnt;

-- 1. Найти все отделы, в которых работает более 10 сотрудников
SELECT employee.department, COUNT(employee.department) -- department
FROM employee
GROUP BY employee.department
HAVING COUNT(employee.department) > 2;

-- 2. Найти сотрудников, которые не выходят с рабочего места в течение всего рабочего дня.
WITH new_table(fio, date, cnt)
AS
 (
     SELECT e.fio, employee_attendance.date, COUNT(*)
     FROM employee_attendance
              JOIN employee e on e.id = employee_attendance.employee_id
     GROUP BY e.fio, employee_attendance.date
    -- Кол-во должно быть == 2, потому что человек пришел (его отметили)
    -- Вечпром человек ушел (его опять отметили)
    -- Значит чтобы он не выходил никуда с рабочего места
    -- Он должен просто зайти и выйти (т.е. 2 раза только отметиться)
     HAVING COUNT(*) = 2
 )
SELECT fio
FROM new_table
GROUP BY fio;

-- 3. Найти все отделы, в которых есть сотрудники, опоздавшие в определенную дату.
SELECT department
FROM employee JOIN employee_attendance ea on employee.id = ea.employee_id
WHERE date = '2020-11-15'
AND type = 1
AND time > '09:00:00'
GROUP BY department;

-- ВАРИАНТ 3
-- Написать скалярную функцию, возвращающую минимальный
-- Возраст сотрудника, опоздавшего более чем на 10 минут.
-- Минимальный возраст == максимальная дата рождения.
CREATE OR REPLACE FUNCTION get_latecomer()
RETURNS INT
AS
$$
    SELECT date_part('year',age(MAX(employee.date_of_birth)))
    FROM employee JOIN employee_attendance ea on employee.id = ea.employee_id
    WHERE ea.type = 1 AND ea.time > '09:10:00'
$$LANGUAGE SQL;

SELECT * FROM get_latecomer();

-- 1. Найти самого старшего сотрудника в бухгалтерии
-- Бухгалтерии у меня в данных нет, так что ищем программиста.
SELECT id, fio, date_of_birth, department
FROM employee
WHERE department='Программист'
AND date_of_birth =
(
    SELECT MIN(date_of_birth)
    FROM employee
    WHERE department='Программист'
);

-- 2. Найти сотрудников, выходивших больше 3-х раз с рабочего места
-- В моих данных таких нет (поэтому тестить на других нужно, либо более 0 раз сделать...).
SELECT employee_id, date, COUNT(*)
FROM employee_attendance
WHERE type=1
GROUP BY employee_id, date
HAVING COUNT(*) > 3;

-- 3. Найти сотрудника, который пришел сегодня последним
SELECT e.id, e.fio, employee_attendance.time
FROM employee_attendance JOIN employee e on e.id = employee_attendance.employee_id
WHERE date = '2020-11-15' -- CURRENT_DATE
AND type = 1
AND time =
(
    SELECT MAX(time)
    FROM employee_attendance
    WHERE date = '2020-11-15' -- CURRENT_DATE
    AND type = 1
);


-- ВАРИАНТ 4.
-- Написать табличную функцию, возвращающую сотрудников, не пришедших сегодня на
-- работу. «Сегодня» необходимо вводить в качестве параметра.
CREATE OR REPLACE FUNCTION missed_work(dt DATE) -- dt - "сегодня"
RETURNS TABLE
(
    id INT,
    fio VARCHAR
)
AS
$$
    SELECT id, fio
    FROM employee
    WHERE id NOT IN
    (
        SELECT employee.id
        FROM employee JOIN employee_attendance ea on employee.id = ea.employee_id
        WHERE date = dt
        AND type = 1
    );
$$LANGUAGE SQL;

SELECT * FROM missed_work('2020-11-15');

-- 1. Найти сотрудников, опоздавших сегодня меньше чем на 5 минут
SELECT *
FROM employee JOIN employee_attendance ea on employee.id = ea.employee_id
WHERE date =  '2020-11-15' -- CURRENT_DATE
AND type = 1
AND time > '09:00:00' -- Опоздал
AND time <= '09:05:00'; -- Менее, чем на 5 минут.

-- 2. Найти сотрудников, которые выходили больше чем на 10 минут
SELECT *
FROM employee_attendance;

-- 3. Найти сотрудников бухгалтерии, приходящих на работу раньше 8:00
-- Вместо бухгалтерии у меня программисты. (Раньше 9)
SELECT *
FROM employee
WHERE id in
(
    SELECT employee.id
    FROM employee JOIN employee_attendance ea on employee.id = ea.employee_id
    WHERE department='Программист'
    AND type = 1
    AND time < '09:00:00'
);