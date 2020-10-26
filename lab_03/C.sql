-- Триггер - Объект. Ответ на событие.
-- Инфа про триггеры:
-- https://postgrespro.ru/docs/postgresql/9.6/sql-createtrigger

-- SELECT * INTO user_tmp
-- FROM userstest;

-- C.1. Триггер AFTER.
-- Когда в таблице меняется id человека (на new.id),
-- То нужно поменять у всех остальных юзеров invited_id на new.id.
-- Т.е. поменять id того человека, который их пригласил
CREATE OR REPLACE FUNCTION update_trigger()
RETURNS TRIGGER
AS '
BEGIN
    RAISE NOTICE ''New =  %'', new;
    RAISE NOTICE ''Old =  %'', old;

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
SET id = 1
WHERE id = 15;

SELECT * FROM user_tmp;

-- C.2. Триггер INSTEAD OF.
