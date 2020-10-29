-- Триггер - Объект. Ответ на событие.
-- Инфа про триггеры:
-- https://postgrespro.ru/docs/postgresql/9.6/sql-createtrigger

SELECT * INTO user_tmp
FROM userstest;

-- drop table user_tmp;

-- C.1. Триггер AFTER.
-- Когда в таблице меняется id человека (на new.id),
-- То нужно поменять у всех остальных юзеров invited_id на new.id.
-- Т.е. поменять id того человека, который их пригласил
CREATE OR REPLACE FUNCTION update_trigger()
RETURNS TRIGGER
AS '
BEGIN
    RAISE NOTICE ''New =  %'', new;
    RAISE NOTICE ''Old =  %'', old; RAISE NOTICE ''New =  %'', new;


    UPDATE user_tmp
    SET invited_id = new.id
    WHERE user_tmp.invited_id = old.id;

    --     Для операций INSERT и UPDATE возвращаемым значением должно быть NEW.
    RETURN new;
END;
' LANGUAGE plpgsql;

-- AFTER - оперделяет, что заданная цункция будет вызываться после события.
CREATE TRIGGER log_update
AFTER UPDATE ON user_tmp
-- Триггер с пометкой FOR EACH ROW вызывается один раз для каждой строки,
-- изменяемой в процессе операции.
FOR EACH ROW
EXECUTE PROCEDURE update_trigger();

UPDATE user_tmp
SET id = 20
WHERE id = 1;

SELECT * FROM user_tmp;

-- C.2. Триггер INSTEAD OF.
-- INSTEAD OF - Сработает вместо указанной операции.

-- Заменяем удаление на мягкое удаление.
-- Т.е. при попытки удалить шлем, он не будет
-- Удален, а лишь поставлен company = none
-- Что будет свидетельствовать о том
-- Что данного шлема больше нет.
-- VIEW - вирутальная табоица.
CREATE VIEW device_new AS
SELECT * -- INTO device_new
FROM device
WHERE id < 15;

-- drop VIEW device_new;

SELECT * FROM device_new;

CREATE OR REPLACE FUNCTION del_device_func()
RETURNS TRIGGER
AS '
BEGIN
    RAISE NOTICE ''New =  %'', new;

    UPDATE device_new
    SET company = ''none''
    WHERE device_new.id = old.id;

    RETURN new;
END;
' LANGUAGE plpgsql;

CREATE TRIGGER del_device_trigger
INSTEAD OF DELETE ON device_new
    FOR EACH ROW
    EXECUTE PROCEDURE del_device_func();

DELETE FROM device_new
WHERE year_of_issue = 2046;

SELECT * FROM device_new
ORDER BY year_of_issue;