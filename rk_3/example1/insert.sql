-- Работники.
INSERT INTO employee
VALUES (0, 'Элис', 'Сукочева', '2000-07-19', 'Программист');

INSERT INTO employee
VALUES (1, 'Вася', 'Малков', '1998-01-02', 'Программист');

INSERT INTO employee
VALUES (2, 'Вика', 'Софрнова', '2002-05-01', 'Системный администратор');

INSERT INTO employee
VALUES (3, 'Дима', 'Власов', '1995-11-11', 'Руководитель');

-- Пришли.
INSERT INTO employee_visit
VALUES (0, 0, CURRENT_DATE - 1, 'Понедельник', '08:55:00', 1);

INSERT INTO employee_visit
VALUES (1, 1, CURRENT_DATE - 1, 'Понедельник', '08:55:00', 1);

INSERT INTO employee_visit
VALUES (2, 2, CURRENT_DATE - 1, 'Понедельник', '09:05:00', 1);

INSERT INTO employee_visit
VALUES (3, 3, CURRENT_DATE - 1, 'Понедельник', '10:51:00', 1);

-- Ушли.
INSERT INTO employee_visit
VALUES (4, 0, CURRENT_DATE - 1, 'Понедельник', '16:05:00', 2);

INSERT INTO employee_visit
VALUES (5, 1, CURRENT_DATE - 1, 'Понедельник', '16:06:00', 2);

INSERT INTO employee_visit
VALUES (6, 2, CURRENT_DATE - 1, 'Понедельник', '19:09:00', 2);

INSERT INTO employee_visit
VALUES (7, 3, CURRENT_DATE - 1, 'Понедельник', '21:00:00', 2);
