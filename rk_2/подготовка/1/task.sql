-- Сотрудник.
CREATE TABLE IF NOT EXISTS employee
(
    id INT PRIMARY KEY,
    name VARCHAR(32),
    surname VARCHAR(32),
    year_of_birth INT,
    position VARCHAR(32)
);

-- Операция обмена.
CREATE TABLE IF NOT EXISTS exchange_operation
(
    id INT PRIMARY KEY,
    id_employee INT,
    FOREIGN KEY (id_employee) REFERENCES employee(id),
    currency VARCHAR(32),
    sum INT
);

-- Курс валюты.
CREATE TABLE IF NOT EXISTS rate
(
    id INT PRIMARY KEY,
    id_currency INT,-- Валюта.
    FOREIGN KEY (id_currency) REFERENCES exchange_operation(id),
    sale INT,  -- Продажа.
    purchase INT -- Покупка.
);

-- Виды валют.
CREATE TABLE IF NOT EXISTS types_of_currencies
(
    id INT PRIMARY KEY,
    id_rate INT,
    FOREIGN KEY (id_rate) REFERENCES rate(id)
);

-- Инструкцию SELECT, использующую простое выражение CASE.
-- Добавляет колонтку comment
-- В которой, в зависимости от возраста указывает
-- Его статус: Средний, старший, младший.
SELECT id, name, surname,
CASE year_of_birth
WHEN
(
    SELECT MAX(year_of_birth)
    FROM employee
)
THEN 'Самый старший'
WHEN
(
    SELECT MIN(year_of_birth)
    FROM employee
)
THEN 'Самый младший'
ELSE 'Средний возраст'
END AS comment
FROM employee;

-- Инструкцию, использующую оконную функцию.
-- Добавляет столбец max_age
-- Который показывает самый маленький год
-- (Т.е. самого старшего сотрудника)
-- В зависимости от позиции.
-- (Т.е. у каждого консультанта будет
--  Доп. столбец, показывающий
-- Самого старшего консультанта.
-- Также запрос сортирует по позиции.
SELECT id, name, position, year_of_birth, MIN(year_of_birth) OVER (PARTITION BY position) max_age
FROM employee
ORDER BY position;

-- Инструкцию SELECT, консолидирующую данные с помощью

-- предложения GROUP BY и предложения HAVING
-- Получить название валюты и кол-во валют,
-- Кол-во которых больше 1
SELECT currency, COUNT(currency) cnt
FROM exchange_operation
GROUP BY currency
HAVING COUNT(currency) > 1
ORDER BY cnt DESC;

CREATE OR REPLACE PROCEDURE proc_name()
AS '
DECLARE
    elem RECORD;
BEGIN
    FOR elem in
        SELECT COLUMN_NAME
        FROM information_schema.columns
        WHERE table_name = ''employee''
    LOOP
        RAISE NOTICE ''elem: %'', elem;
    END LOOP;
END;
'LANGUAGE plpgsql;

CALL proc_name();

CREATE OR REPLACE PROCEDURE index_info
(
    db_name_in VARCHAR(32),
    table_name_in VARCHAR(32)
)
AS '
DECLARE
    elem RECORD;
BEGIN
    FOR elem in
        SELECT *
        FROM pg_index
        JOIN pg_class ON pg_index.indrelid = pg_class.oid
        WHERE relname = table_name_in
        LOOP
            RAISE NOTICE ''elem: %'', elem;
        END LOOP;
END;
' LANGUAGE plpgsql;

CALL index_info('rk_2', 'employee');

select *
from pg_index;

-- В каталоге pg_class описываются таблицы и практически всё,
-- что имеет столбцы или каким-то образом подобно таблице.
-- Сюда входят индексы (но смотрите также pg_index )
SELECT *
FROM pg_index
JOIN pg_class ON pg_index.indrelid=pg_class.oid
WHERE relname='employee';










