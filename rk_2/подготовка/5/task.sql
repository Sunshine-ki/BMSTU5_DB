-- Создать хранимую процедуру с входным параметром – «имя таблицы»,
-- которая удаляет дубликаты записей из указанной таблицы в текущей базе
-- данных. Созданную хранимую процедуру протестировать.

CREATE TABLE IF NOT EXISTS test_duplicates
(
    id INT,
    name VARCHAR(32)
);


CREATE OR REPLACE PROCEDURE remove_duplicates
(
    table_name_in VARCHAR(32)
)
AS '
BEGIN
    EXECUTE ''
        create table tab_temp as
        select distinct *
        from '' || table_name_in;

    EXECUTE ''
        DROP TABLE'' || table_name_in;

    EXECUTE ''
    ALTER TABLE tab_temp rename to '' || table_name_in;
END;
' LANGUAGE plpgsql;



SELECT * FROM tab_temp;

CALL remove_duplicates('test_duplicates');



--     EXECUTE '
--         create table tab_temp as
--         select distinct *
--         from ' || table_name_in;

SELECT table_name
FROM
(
    SELECT *
    FROM information_schema.columns
    WHERE table_name = 'test_duplicates'
) a;

select table_name, column_name
from information_schema.columns
where table_name = 'test_duplicates';