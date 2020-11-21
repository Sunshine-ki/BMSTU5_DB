CREATE TABLE IF NOT EXISTS employee
(
    id INT PRIMARY KEY,
    department_id INT, -- Отдел.
    position VARCHAR(32), -- Должность.
    firstname VARCHAR(32),
    lastname varchar(32),
    salary INT
);

select * from employee;

ALTER TABLE employee ADD CONSTRAINT fk_id_department
FOREIGN KEY (department_id)
REFERENCES department(id);

--     department_id INT, -- Отдел.
--     FOREIGN KEY (department_id) REFERENCES department(id),

CREATE TABLE IF NOT EXISTS department
(
    id INT PRIMARY KEY,
    name VARCHAR(32),
    phone VARCHAR(16),
    manager INT, -- Заведующий.
    FOREIGN KEY (manager) REFERENCES employee(id)
);

CREATE TABLE IF NOT EXISTS medication
(
    id INT PRIMARY KEY,
    name VARCHAR(32),
    instruction VARCHAR(64),
    price INT
);

CREATE TABLE IF NOT EXISTS employee_medication
(
    id_employee INT,
    FOREIGN KEY (id_employee) REFERENCES employee(id),
    id_medication INT,
    FOREIGN KEY (id_medication) REFERENCES medication(id)
);
