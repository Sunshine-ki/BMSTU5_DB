-- Конфеты...


-- Создать хранимую процедуру с входным параметром, которая выводит
-- имена и описания типа объектов (только хранимых процедур и скалярных
-- функций), в тексте которых на языке SQL встречается строка, задаваемая
-- параметром процедуры. Созданную хранимую процедуру протестировать.
CREATE OR REPLACE PROCEDURE info_routine
(
    str VARCHAR(32)
)
AS '
DECLARE
    elem RECORD;
BEGIN
    FOR elem in
        SELECT routine_name, routine_type
        FROM information_schema.routines
             -- Чтобы были наши схемы.
        WHERE specific_schema = ''public''
        AND (routine_type = ''PROCEDURE''
        OR (routine_type = ''FUNCTION'' AND data_type != ''record''))
        AND routine_definition LIKE CONCAT(''%'', str, ''%'')
    LOOP
        RAISE NOTICE ''elem: %'', elem;
    END LOOP;
END;
' LANGUAGE plpgsql;

CALL info_routine('CONCAT');

-- null - процедура
-- in
-- record - мб таблица.

select data_type, specific_name
FROM information_schema.routines
WHERE specific_schema = 'public';

CREATE OR REPLACE FUNCTION func_int()
RETURNS INT AS '
    SELECT  5
' LANGUAGE sql;