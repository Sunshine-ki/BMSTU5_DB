-- 1. Из таблиц базы данных, созданной в первой
-- лабораторной работе, извлечь данные в JSON.

-- Функция row_to_json - Возвращает кортеж в виде объекта JSON.
SELECT row_to_json(u) result FROM users u;
SELECT row_to_json(w) result FROM world w;
SELECT row_to_json(d) result FROM device d;

-- 2. Выполнить загрузку и сохранение JSON файла в таблицу.
-- Созданная таблица после всех манипуляций должна соответствовать таблице
-- базы данных, созданной в первой лабораторной работе.

-- Создаем новую таблицу, чтобы сравнить ее со старой.
-- Да и вообще, чтобы не дропать старую таблицу...
CREATE TABLE IF NOT EXISTS users_copy
(
	id INT NOT NULL PRIMARY KEY,
	nickname  VARCHAR(32),
	age INT CHECK (age >= 0 and age <= 100),
	sex CHAR,
	number_of_hours INT CHECK (number_of_hours >= 0 and number_of_hours <= 5000),
	-- Вторичный ключ id_device ссылается на device(id).
	id_device INT,
	FOREIGN KEY (id_device) REFERENCES device(id)
);

-- Копируем данные из таблицы users в файл users.json
-- (В начале нужно поставить \COPY).
COPY
(
    SELECT row_to_json(u) result FROM users u
)
TO '/home/lis/university/github/database/lab_05/users.json';

-- Подготовка данных завершена.
-- Собственно далее само задание.

-- Помещаем файл в таблицу БД.
-- Создаем таблицу, которая будет содержать json кортежи.
CREATE TABLE IF NOT EXISTS users_import(doc json);

-- Теперь копируем данные в созданную таблицу.
-- (Но опять же делаем это с помощью \COPY).
COPY users_import FROM '/home/lis/university/github/database/lab_05/users.json';

SELECT * FROM users_import;

-- В принципе можно было сделать так, но т.к. в условии написано
-- Выгрузить из файла, так что нужно использовтаь copy.
-- CREATE TABLE IF NOT EXISTS users_tmp(doc json);
-- INSERT INTO users_tmp
-- SELECT row_to_json(u) result FROM users u;
-- SELECT * FROM users_tmp;

-- Данный запрос преобразует данные из строки в формате json
-- В табличное предстваление. Т.е. разворачивает объект из json в табличную строку.
SELECT * FROM users_import, json_populate_record(null::users_copy, doc);
-- Преобразование одного типа в другой null::users_copy
SELECT * FROM users_import, json_populate_record(CAST(null AS users_copy ), doc);

-- Загружаем в таблицу сконвертированные данные из формата json из таблицы users_import.
INSERT INTO users_copy
SELECT id, nickname, age, sex, number_of_hours, id_device
FROM users_import, json_populate_record(null::users_copy, doc);

SELECT * FROM users_copy;

-- 3. Создать таблицу, в которой будет атрибут(-ы) с типом JSON, или
-- добавить атрибут с типом JSON к уже существующей таблице.
-- Заполнить атрибут правдоподобными данными с помощью команд INSERT или UPDATE

-- Создаем таблицу, которая будет содержать
-- Нарушителей в json формате.
CREATE TABLE IF NOT EXISTS blacklist_json
(
    data json
);

SELECT * FROM blacklist_json;

-- Вставляем в нее json строку.
-- json_object - формирует объект JSON.
INSERT INTO blacklist_json
SELECT * FROM json_object('{user_id, word_id, reason}', '{1,2, "Красноречиво выражался"}');

-- 4. Выполнить следующие действия:
-- 1. Извлечь XML/JSON фрагмент из XML/JSON документа
CREATE TABLE IF NOT EXISTS users_id_name
(
    id INT,
    nickname VARCHAR
);

SELECT * FROM users_import, json_populate_record(null::users_id_name, doc);

-- Получаем id и имена всех юзеров
-- У кроторых nickname начинается с буквы 'A'
SELECT id, nickname
FROM users_import, json_populate_record(null::users_id_name, doc)
WHERE nickname LIKE 'A%';

-- Оператор -> возвращает поле объекта JSON как JSON.
-- -> - выдаёт поле объекта JSON по ключу.
SELECT * FROM users_import;

SELECT doc->'id' AS id, doc->'nickname' AS nickname
FROM users_import;



-- 2. Извлечь значения конкретных узлов или атрибутов XML/JSON документа
CREATE TABLE inventory(doc jsonb);
-- Оружие: огнестрельное: пистолет, ручное: нож
INSERT INTO inventory VALUES ('{"id":0, "weapon": {"firearms":"pistol", "hand_weapon":"knife"}}');
INSERT INTO inventory VALUES ('{"id":1, "weapon": {"firearms":"machine gun", "hand_weapon":"none"}}');

SELECT * FROM inventory;

-- Извлекаем огнестрельное оружие у пользователей.
SELECT doc->'id' AS id, doc->'weapon'->'firearms' AS firearms
FROM inventory;

-- 3. Выполнить проверку существования узла или атрибута
-- Проверка вхождения — важная особенность типа jsonb, не имеющая аналога для типа json.
-- Эта проверка определяет, входит ли один документ jsonb в другой.
-- (https://postgrespro.ru/docs/postgresql/9.5/datatype-json#json-containment)

-- В данном примере проверятся существование инвенторя у пользователя с id=u_id.
CREATE OR REPLACE FUNCTION get_inventory(u_id jsonb)
RETURNS VARCHAR AS '
    SELECT CASE
               WHEN count.cnt > 0
                   THEN ''true''
               ELSE ''false''
               END AS comment
    FROM (
             SELECT COUNT(doc -> ''id'') cnt
             FROM inventory
             WHERE doc -> ''id'' @> u_id
         ) AS count;
' LANGUAGE sql;

SELECT * FROM inventory;

SELECT get_inventory('1');

-- 4. Изменить XML/JSON документ

INSERT INTO inventory VALUES ('{"id":3, "weapon": {"firearms":"machine gun", "hand_weapon":"none"}}');

SELECT * FROM inventory;
-- Особенность конкатенации json заключается в перезаписывании.
SELECT doc || '{"id": 33}'::jsonb
FROM inventory;

-- Перезаписываем значение json поля.
UPDATE inventory
SET doc = doc || '{"id": 33}'::jsonb
WHERE (doc->'id')::INT = 3;

SELECT * FROM inventory;

-- 5. Разделить XML/JSON документ на несколько строк по узлам
-- Игра, которую юзер прошел.
CREATE TABLE IF NOT EXISTS passed_game(doc JSON);

INSERT INTO passed_game VALUES ('[{"user_id": 0, "game_id": 1},
  {"user_id": 2, "game_id": 2}, {"user_id": 3, "game_id": 1}]');

SELECT * FROM passed_game;

-- jsonb_array_elements - Разворачивает массив JSON в набор значений JSON.
SELECT jsonb_array_elements(doc::jsonb)
FROM passed_game;

-- TODO: Защита: jsonb отличается от json

SELECT '[{"user_id": 0, "game_id": 1},
  {"user_id":   2, "game_id": 2}, {"user_id": 3, "game_id": 1}]'::jsonb;

SELECT '[{"user_id": 0, "game_id": 1},
  {"user_id":    2, "game_id": 2}, {"user_id": 3, "game_id": 1}]'::json;