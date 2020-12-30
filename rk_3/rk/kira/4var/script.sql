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

--Написать табличную функцию, возвращающую сотрудников, не пришедших сегодня на работу.
-- «Сегодня» необходимо вводить в качестве параметра
CREATE OR REPLACE FUNCTION Absence(dt DATE) RETURNS TABLE
(
    fio varchar,
    department varchar
)
AS
$$
    SELECT fio, department
    FROM employee empl
    WHERE empl.id NOT IN (SELECT e.id
    FROM employee e JOIN employee_attendance ea ON e.id = ea.employee_id
    WHERE date = dt)
$$LANGUAGE SQL;

SELECT * FROM Absence('2020-11-15');



--1 Первый запрос (SQL)
--Найти сотрудников, опоздавших сегодня меньше чем на 5 минут
SELECT DISTINCT fio
FROM employee e JOIN employee_attendance ea on e.id = ea.employee_id
WHERE type = 1 AND date = NOW() AND time > '08:00:00' AND (EXTRACT (HOURS FROM time - '08:00:00') * 60 + EXTRACT (MINUTES FROM time - '08:00:00')) < 5;

--2 Второй запрос (SQL)
--Найти сотрудников, которые выходили больше чем на 10 минут
--???

--3 Третий запрос (SQL)
--Найти сотрудников бухгалтерии, приходящих на работу раньше 8:00
SELECT DISTINCT fio
FROM employee e JOIN employee_attendance ea on e.id = ea.employee_id
WHERE department = 'Руководитель' AND type = 1 AND time < '08:00:00';

