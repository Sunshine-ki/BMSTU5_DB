CREATE TABLE IF NOT EXISTS employee(
    id INT PRIMARY KEY,
    fio VARCHAR(32),
    date_of_birth DATE,
    department VARCHAR(32)
);

CREATE TABLE IF NOT EXISTS employee_attendance(
    id INT PRIMARY KEY,
    employee_id INT,
    FOREIGN KEY (employee_id) REFERENCES employee(id),
    date DATE DEFAULT CURRENT_DATE,
    day_of_week VARCHAR,
    time TIME DEFAULT CURRENT_TIME,
    type INT
);

--Написать скалярную функцию, возвращающую минимальный возраст сотрудника,
-- опоздавшего более чем на 10 минут
CREATE OR REPLACE FUNCTION MinAge() RETURNS INTEGER
AS
$$
    SELECT MIN(EXTRACT (YEARS FROM now()) - EXTRACT (YEARS FROM date_of_birth))
    FROM employee e JOIN employee_attendance ea ON e.id = ea.employee_id
    WHERE type = 1 AND time > '08:00:00' AND (EXTRACT (HOURS FROM time - '08:00:00') * 60 + EXTRACT (MINUTES FROM time - '08:00:00')) > 10;
$$LANGUAGE SQL;

SELECT * FROM MinAge();

--1 Первый запрос (SQL)
--Найти самого старшего сотрудника в бухгалтерии
SELECT id, fio, date_of_birth
FROM employee
WHERE department = 'Руководитель' AND date_of_birth =
(SELECT MIN(date_of_birth)
FROM employee
WHERE department = 'Руководитель'
);

--2 Второй запрос (SQL)
--Найти сотрудников, выходивших больше 3-х раз с рабочего места
SELECT DISTINCT employee_id, COUNT(*)
FROM employee_attendance
WHERE type = 2
GROUP BY employee_id, date
HAVING COUNT(*) > 4; -- с учетом ухода домой

--3 Третий запрос (SQL)
--Найти сотрудника, который пришел сегодня последним
SELECT fio
FROM employee e JOIN employee_attendance ea on e.id = ea.employee_id
WHERE ea.date = now() AND ea.type = 1 AND ea.time IN
(SELECT MAX(time)
FROM employee_attendance empl_att
WHERE empl_att.type = 1);

