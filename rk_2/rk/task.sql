-- Вариант 2

-- Задание 1.

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

-- Задание 2.

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

-- Я ошибласть и сделала не тот запрос, но удалять его жалко
-- 3. Инструкцию SELECT, консолидирующую данные с помощью
-- предложения GROUP BY и предложения HAVING`
-- Группируем по стажу
-- (Т.е. таблица меняет свою структуру)
-- Тпереь для каждого стажа будет кол-во строк
-- С данным стажем.
-- И накладываем условие, то что данное кол-во
-- Должно быть больше 2
SELECT experience, COUNT(experience) cnt
FROM customer
GROUP BY experience
HAVING COUNT(experience) > 2;

-- 3. Инструкция SELECT, использующая вложенные коррелированные
-- подзапросы в качестве производных таблиц в предложении FROM.
-- Вывести всю информацию о исполнителе
-- У которой стаж работы больше чем средний стаж работы.
SELECT *
FROM executor
WHERE  experience >
(
    SELECT AVG(experience)
    FROM executor
);


-- Задание 3

-- Создать хранимую процедуру с двумя входными параметрами – имя базы
-- данных и имя таблицы, которая выводит сведения об индексах указанной
-- таблицы в указанной базе данных. Созданную хранимую процедуру
-- протестировать.

-- Джоиним две таблицы, которые содержат информацию о индексах
-- И накладыаем условие, чтобы выодились информация только о нужной
-- (которая задана в параметрах) таблице.
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
        -- В каталоге pg_index содержится часть информации об индексах.
        -- Остальная информация в основном находится в pg_class.
        FROM pg_index
        --  В каталоге pg_class описываются таблицы и практически всё,
        --  что имеет столбцы или каким-то образом подобно таблице.
        --  Сюда входят индексы.
        JOIN pg_class ON pg_index.indrelid = pg_class.oid
        WHERE relname = table_name_in
    LOOP
        RAISE NOTICE ''elem: %'', elem;
    END LOOP;
END;
' LANGUAGE plpgsql;

CALL index_info('rk_2', 'type_of_jobs');

select *
from pg_index;

SELECT *
FROM pg_index
JOIN pg_class ON pg_index.indrelid=pg_class.oid
WHERE relname='type_of_jobs';
