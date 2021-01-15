-- Вариант 2

CREATE TABLE IF NOT EXISTS employee(
    id INT PRIMARY KEY,
    fio VARCHAR(32),
    date_of_birth DATE,
    department VARCHAR(32)
);

select * from employee;

CREATE TABLE IF NOT EXISTS employee_attendance(
    id INT PRIMARY KEY,
    employee_id INT,
    FOREIGN KEY (employee_id) REFERENCES employee(id),
    date DATE DEFAULT CURRENT_DATE,
    day_of_week VARCHAR,
    time TIME DEFAULT CURRENT_TIME,
    type INT CHECK (type >= 1 AND type <= 2)
);

-- Написать табличную функцию, возвращающую статистику
-- На сколько и кто (кол-во человек) опоздал в определенную дату.
CREATE OR REPLACE FUNCTION Visit(dt DATE)
RETURNS TABLE
(
    minutes double precision,
    employee_qty int
)
AS
$$
    SELECT EXTRACT (HOURS FROM time - '09:00:00') * 60 + EXTRACT (MINUTES FROM time - '09:00:00'), COUNT(*) AS employee_qty
    FROM employee_attendance
    WHERE date = dt
    AND time > '09:00:00'
    AND type = 1
    GROUP BY time - '09:00:00'
$$ LANGUAGE SQL;

SELECT * FROM Visit('2020-11-17');



