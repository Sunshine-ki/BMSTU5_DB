-- Вариант 2

-- Виды работ.
CREATE TABLE IF NOT EXISTS type_of_jobs
(
    id INT PRIMARY KEY,
    name_jobs VARCHAR(32),
    labor_costs INT, -- Трудозатраты.
    equipment VARCHAR(32) -- Необходимое оборудование.
);

-- Развязочная таблица для type_of_jobs и executor.
CREATE TABLE IF NOT EXISTS type_of_jobs_executor
(
    id_type_of_jobs INT,
    FOREIGN KEY (id_type_of_jobs) REFERENCES type_of_jobs(id),
    id_executor INT,
    FOREIGN KEY (id_executor) REFERENCES executor(id)
);

-- Исполнитель.
CREATE TABLE IF NOT EXISTS executor
(
    id INT PRIMARY KEY,
    name VARCHAR(32),
    surname VARCHAR(32),
    year_of_birth INT,
    experience INT, -- Стаж (Кол-во лет)
    phone VARCHAR(32)
);

-- Развязочная таблица для executor и customer
CREATE TABLE IF NOT EXISTS executor_customer
(
    id_executor INT,
    FOREIGN KEY (id_executor) REFERENCES executor(id),
    id_customer INT,
    FOREIGN KEY (id_customer) REFERENCES customer(id)
);

-- Заказчик.
CREATE TABLE IF NOT EXISTS customer
(
    id INT PRIMARY KEY,
    name VARCHAR(32),
    surname VARCHAR(32),
    experience INT, -- Стаж
    phone VARCHAR(32)
);

-- Развязочная таблица для type_of_jobs и customer.
CREATE TABLE IF NOT EXISTS type_of_jobs_customer
(
    id_type_of_jobs INT,
    FOREIGN KEY (id_type_of_jobs) REFERENCES type_of_jobs(id),
    id_customer INT,
    FOREIGN KEY (id_customer) REFERENCES customer(id)
);

-- ЗАПРОСЫ

-- 1. Инструкция SELECT, использующая предикат сравнения.
-- Вывести всю информацию о исполнителях
-- Год рождения которых меньше 1995.
SELECT *
FROM executor
WHERE year_of_birth < 1995; -- AND year_of_birth < 2000;

-- 2. Инструкцию, использующую оконную функцию.
-- Вывести информацию о виде работы,
-- Добавляя столбец cnt, в котором показано
-- Сколько сумерно тратится (сумма трудозатрат)
-- На работу с каким-то оборудованием.
SELECT id, name_jobs, labor_costs, equipment, SUM(labor_costs) OVER(PARTITION BY equipment) cnt
FROM type_of_jobs
ORDER BY cnt;

-- 3. Инструкцию SELECT, консолидирующую данные с помощью
-- предложения GROUP BY и предложения HAVING
-- Получить для каждого стажа
SELECT experience, COUNT(experience) cnt
FROM customer
GROUP BY experience
HAVING COUNT(experience) > 2;