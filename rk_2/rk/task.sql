-- Вариант 2

CREATE TABLE IF NOT EXISTS type_of_jobs
(
    id INT PRIMARY KEY,
    name_jobs VARCHAR(32),
    labor_costs INT, -- Трудозатраты.
    equipment VARCHAR(32) -- Необходимое оборудование.
);

-- Развязочная таблица для type_of_jobs и executor
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