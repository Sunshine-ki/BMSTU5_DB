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

--Написать скалярную функцию, возвращающую количество сотрудников
--в возрасте от 18 до 40, выходивших более 3х раз
CREATE OR REPLACE FUNCTION EmployeeCount() RETURNS INTEGER
AS
$$
    SELECT COUNT(*)
    FROM employee_attendance ea JOIN employee e on ea.employee_id = e.id
    WHERE type = 2 AND date_part('year', age(date_of_birth)) > 18
    AND date_part('year', age(date_of_birth)) < 40
    GROUP BY employee_id, date
    HAVING COUNT(*) > 4; -- с учетом ухода домой
$$LANGUAGE SQL;

SELECT * FROM EmployeeCount();

--1 Первый запрос (SQL)
--Найти все отделы, в которых работает более 10 сотрудников
SELECT department
FROM employee
GROUP BY department
HAVING COUNT(*) > 10;

--2 Второй запрос (SQL)
--Найти сотрудников, которые не выходят с рабочего места в течение всего рабочего дня
SELECT DISTINCT employee_id
FROM employee_attendance
WHERE type = 2
GROUP BY employee_id, date
HAVING COUNT(*) = 1; --с учетом ухода домой

--3 Третий запрос (SQL)
--Найти все отделы, в которых есть сотрудники, опоздавшие в определенную дату.
-- Дату передавать с клавиатуры
SELECT DISTINCT department
FROM employee e JOIN employee_attendance ea on e.id = ea.employee_id
WHERE date = '2020-11-15' AND type = 1 AND time > '08:00:00';

