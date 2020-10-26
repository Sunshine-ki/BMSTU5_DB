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
    UPDATE user_copy
    SET id_device = in_id_device
    WHERE id=in_id;
END;
' LANGUAGE plpgsql;

-- Вызов процедуры.
CALL update_user(1, 1);

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

CALL fib_proc(0, 21);

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

-- B.3. Хранимую процедуру с курсором
-- Отладочная печать: RAISE NOTICE 'Вызов %', in_id;

-- Меняет invited_id всех юзеров, которых пригласил один и тот же пользователь с id равным in_invited_id.
CREATE OR REPLACE PROCEDURE proc_update_cursor
(
    in_invited_id INT,
    new_invited_id INT
)
AS '
DECLARE myCursor CURSOR FOR
    SELECT *
    FROM user_tmp
    WHERE invited_id = in_invited_id;
    tmp user_tmp;
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

        UPDATE user_tmp
        SET invited_id = new_invited_id
        WHERE user_tmp.id = tmp.id;

        RAISE NOTICE ''Elem =  %'', tmp;
    END LOOP;
    CLOSE myCursor;
END;
'LANGUAGE  plpgsql;

CALL proc_update_cursor(1, 0);

SELECT * FROM user_tmp;













