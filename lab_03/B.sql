-- B.1. Хранимую процедуру без параметров или с параметрами
-- Добавить девайс.
CREATE OR REPLACE PROCEDURE insert_device
(
    id INT,
    company VARCHAR,
    year_of_issue INT,
    color VARCHAR,
    price INT
)
AS '
BEGIN
    INSERT INTO device
    VALUES (id, company, year_of_issue, color, price);
END;
' LANGUAGE plpgsql;

CALL insert_device(5001, 'My', 2020, 'coral', 10000);

-- Поменять id_device у юзера по заданному id.
SELECT * INTO TEMP user_copy
FROM users;

SELECT *
FROM  user_copy;

CREATE OR REPLACE PROCEDURE update_user
(
    in_id INT,
    in_id_device INT
)
AS '
BEGIN
    UPDATE users
    SET id_device = in_id_device
    WHERE id=in_id;
END;
' LANGUAGE plpgsql;


-- Вызов процедуры.
CALL update_user(1, 5);

SELECT * FROM users ORDER BY id LIMIT 5;



-- B.2. Рекурсивную хранимую процедуру или хранимую процедур с рекурсивным ОТВ.

-- Фибоначи. Входные параметры:
-- 1. Куда запишем результат.
-- 2. max - число, до которого будут считаться числа фибоначи.
-- Т.е. вернет наибольшее число фибоначи меньшее или равное max.
-- 3. и 4. - необязательные параметры.
-- Можно отправить два числа последовательности
-- С этих чисел и начнется счет последовательности.
CREATE OR REPLACE PROCEDURE fib_proc
(
    res INOUT INT,
    max INT,
    first INT DEFAULT 1,
    second INT DEFAULT  1
)
AS '
DECLARE
    tmp INT;
BEGIN
    tmp = first + second;
    IF tmp <= max THEN
        res = tmp;
        CALL fib_proc(res, max, second, tmp);
    END IF;
END;
'LANGUAGE  plpgsql;

CALL fib_proc(0, 100);

-- Выводит число по индексу из последовательности числел фибоначи.
CREATE OR REPLACE PROCEDURE fib_proc_index
(
    res INOUT INT,
    index INT,
    first INT DEFAULT 1,
    second INT DEFAULT 1
)
AS '
BEGIN
    IF index > 0 THEN
--         RAISE NOTICE ''Elem =  %'', res;
        res = first + second;
        CALL fib_proc_index(res, index - 1, second, first + second);
    END IF;
END;
'LANGUAGE  plpgsql;

-- 2, 3, 5, 8, 13, 21
CALL fib_proc_index(0, 5);


-- TODO: Тоже на свою таблицу. (Рекурсивную хранимую процедуру). Ok.
-- Получить награду за каждого приглашенного пользователя.
-- За самого себя (то что авторизировался) получает 500.
-- Далее, чем ниже по дереву, тем меньше вознаграждение.
-- Т.е. за пользователя, которого пригласил ты, получишь 450
-- За пользователя, которого ппригласил пользователь,
-- Которого пригласил ты 400 и тд....
CREATE OR REPLACE PROCEDURE get_reward
(
    res INOUT INT,
    in_id INT,
    coefficient FLOAT DEFAULT 1
)
AS '
DECLARE
    elem INT;
BEGIN

    IF coefficient <= 0 THEN
        coefficient = 0.1;
    END IF;

    res = res + 500 * coefficient;

    RAISE NOTICE ''res = %, coefficient = %'', res, coefficient;

    FOR elem IN
        SELECT *
        FROM userstest
        WHERE invited_id = in_id
        LOOP
            CALL get_reward(res, elem, coefficient - 0.1);
        END LOOP;

END;
' LANGUAGE plpgsql;

-- Pasha = 500 + 450 * 5 = 2750.
-- Alice = 500 + 450 * 2 * (5 + 4) * 400 = 5000.
CALL get_reward(0, 1);



-- B.3. Хранимую процедуру с курсором
-- Отладочная печать: RAISE NOTICE 'Вызов %', in_id;

select *
into user_tmp_cursor
from userstest;

-- Можно считать сумму баллов.

-- Меняет invited_id всех юзеров, которых пригласил один и тот же пользователь с id равным in_invited_id.
CREATE OR REPLACE PROCEDURE proc_update_cursor
(
    in_invited_id INT,
    new_invited_id INT
)
AS '
DECLARE
    myCursor CURSOR FOR
        SELECT *
        FROM user_tmp_cursor
        WHERE invited_id = in_invited_id;
    tmp user_tmp_cursor;
BEGIN
    OPEN myCursor;

    LOOP
        -- FETCH - Получает следующую строку из курсора
        -- И присваевает в переменную, которая стоит после INTO.
        -- Если строка не найдена (конец), то присваевается значение NULL.
        FETCH myCursor
        INTO tmp;
        -- Выходим из цикла, если нет больше строк (Т.е. конец).
        EXIT WHEN NOT FOUND;

        UPDATE user_tmp_cursor
        SET invited_id = new_invited_id
        WHERE user_tmp_cursor.id = tmp.id;

        RAISE NOTICE ''Elem =  %'', tmp;
    END LOOP;

    CLOSE myCursor;
END;
'LANGUAGE  plpgsql;

CALL proc_update_cursor(1, 20);

SELECT * FROM user_tmp_cursor;

-- B.4. Хранимую процедуру доступа к метаданным.
-- Получаем название атрибутов и их тип.

CREATE OR REPLACE PROCEDURE metadata(name VARCHAR) -- Получает название таблицы.
AS '
    -- Инфа про метаданные:
    -- https://postgrespro.ru/docs/postgresql/9.6/infoschema-columns
    DECLARE
        myCursor CURSOR FOR
            SELECT column_name,
                   data_type
           -- INFORMATION_SCHEMA обеспечивает доступ к метаданным о базе данных.
           -- columns - данные о столбацых.
            FROM information_schema.columns
            WHERE table_name = name;
        -- RECORD - переменная, которая подстравивается под любой тип.
        tmp RECORD;
BEGIN
        OPEN myCursor;

        LOOP
            FETCH myCursor
            INTO tmp;
            EXIT WHEN NOT FOUND;
            RAISE NOTICE ''column name = %; data type = %'', tmp.column_name, tmp.data_type;
        END LOOP;

        CLOSE myCursor;

END;
' LANGUAGE plpgsql;

CALL metadata('users');

-- TODO: Защита: без курсора вывод в консоль. Ok.

CREATE OR REPLACE PROCEDURE metadata2(name VARCHAR)
AS '
DECLARE
    elem RECORD;
BEGIN

    FOR elem IN
        SELECT column_name,data_type
        FROM information_schema.columns
        WHERE table_name = name
    LOOP
            RAISE NOTICE ''elem = % '', elem;
    END LOOP;

END;
' LANGUAGE plpgsql;

CALL metadata2('world');
