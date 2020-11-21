-- Создать хранимую процедуру без параметров, в которой для экземпляра
-- SQL Server создаются резервные копии всех пользовательских баз данных.
-- Имя файла резервной копии должно состоять из имени базы данных и даты
-- создания резервной копии, разделенных символом нижнего подчеркивания.
-- Дата создания резервной копии должна быть представлена в формате
-- YYYYDDMM. Созданную хранимую процедуру протестировать.

CREATE OR REPLACE PROCEDURE backup()
AS $$
DECLARE
    elem varchar;
    reserve_name varchar;
BEGIN
    FOR elem IN
        SELECT datname FROM pg_database
    LOOP
        SELECT elem || '_' || EXTRACT(year FROM current_date)::varchar ||
        EXTRACT(month FROM current_date)::varchar || EXTRACT(day FROM current_date)::varchar
        INTO reserve_name;
        RAISE NOTICE 'making copy of % as %', elem, reserve_name;
        EXECUTE 'CREATE DATABASE ' || reserve_name || ' WITH TEMPLATE ' || elem;
    END LOOP;
END;
$$ LANGUAGE PLPGSQL;