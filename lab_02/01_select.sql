-- SELECT *
-- FROM world;

-- 1. предикат сравнения.
-- Вывести никнеймы и часы всех девушек в возрасте от 20 до 35 лет
SELECT nickname as nick, number_of_hours
FROM users
WHERE age >= 20 AND age <= 35 and sex='f';

-- 2. предикат BETWEEN.
-- Найти id юзера и id девайса, где девайс использовали
-- в промежуток от 2000 до 2020 года и id девайса четное.
SELECT id_user, id_device
FROM device_history
WHERE year_begin BETWEEN 2000 AND 2020 AND (id_device % 2) = 0;
-- Либо так:
-- WHERE year_begin >= 2000 AND year_begin <= 2020 AND (id_device % 2) = 0;

-- 3. предикат LIKE.
-- Получить название и жанр игр, содержащих в названии слово 'Alice'
SELECT name, genre
FROM world
WHERE name like '%Alice%';

-- Получить название и год выпуска игр, содержащих в названии не менее 2-ух слов.
SELECT name, year_of_issue
FROM world
WHERE name like '% % %';
-- _ - один символ.
-- % - любое кол-во символов.

-- 4. предикат IN с вложенным подзапросом.
-- Вывести компнию и цену девайса у которого цвет pink or purple or coral
SELECT company, price
FROM device 
WHERE color IN ('pink', 'purple', 'coral');

-- Вывести имена и кол-во часов игроков, которые играют в игры 18+
SELECT nickname, number_of_hours
FROM users
where users.id IN
(	
	SELECT id_user
	FROM world_user
	WHERE id_world IN 
	(
		SELECT id as worldID
		FROM world
		WHERE age_restrictions > 18
	)
);

-- 5. предикат EXISTS с вложенным подзапросом.
-- Предикат EXISTS принимает значение TRUE, если подзапрос содержит любое количество строк, иначе его значение равно FALSE. 
-- Для NOT EXISTS все наоборот. Этот предикат никогда не принимает значение UNKNOWN.
-- Вывести всех мальчиков, у которых розовый шлем.
SELECT id, nickname
FROM users
WHERE sex = 'm' AND EXISTS 
(
	SELECT id
	FROM device 
	WHERE users.id_device = device.id AND color='pink'
);


-- 6. предикат сравнения с квантором.
-- Получить всех юзеров, кол-во часов у которых больше
-- чем у любой девушки с кол-вом часов более 1000
SELECT nickname as name, number_of_hours
FROM users
WHERE number_of_hours > ALL
(
	SELECT number_of_hours
	FROM users
	WHERE sex = 'f' AND number_of_hours > 1000
);

-- Получить всех мужчик, у которых кол-во 
-- часов больше чем у любой женщины.
SELECT nickname as name, number_of_hours
FROM users
WHERE number_of_hours > ALL
(
	SELECT number_of_hours
	FROM users
	WHERE sex = 'f'
) AND sex = 'm';

-- 7. агрегатные функции в выражениях столбцов.
-- Вывести кол-во девушек.
SELECT COUNT(sex)
FROM users
WHERE sex='f';

-- Узнать самую взрослую женщину. 
SELECT MAX(age) max_age
FROM users
WHERE sex = 'f';

-- Узнать какого пола пользователей больше.
SELECT MAX(sex)
FROM users;

-- Узнать кол-во девушек и мужчин.
SELECT sex, COUNT(sex)
FROM users
GROUP BY sex;


-- 8. Скалярные подзапросы в выражениях столбцов
-- Вывести информацию о изерах + инфу о шлеме (цвет).
SELECT nickname, age,
(
	SELECT color
	FROM device
	WHERE device.id = users.id_device
) AS color_device
FROM users;

-- 9. простое выражение CASE.
-- Вывести информацию о девайсе
-- С дополнительным столбцом, в котором
-- Описана цена (наименьшая/средняя/наибольшая)
SELECT id, company, price,
CASE price
WHEN
(
	SELECT MAX(price)
	FROM device
)
THEN 'Наибольшая цена девайса'
WHEN 
(
	SELECT MIN(price)
	FROM device
)
THEN 'Наименьшая цена'
ELSE 'Средняя цена'
END AS comment
FROM device
ORDER BY price;

-- 10. поисковое выражение CASE.
-- Вывести информацию о девайсе
-- С дополнительным столбцом, в котором
-- Описана доступность покупки данного девайса, опираясь на средн. ариф..
SELECT id, company, price,
CASE
WHEN price < 
(
	SELECT AVG(price)
	FROM device
)
THEN 'Доступная цена'
ELSE 'Повышенная цена'
END AS comment
FROM device;
-- ORDER BY price;


-- 11. Создание новой временной локальной таблицы.
-- Создаем таблицу с группировкой по цветам 
-- (цвет и кол-во шлемов этого цвета)
SELECT color, COUNT(color)
INTO firstLocalTable
FROM device
GROUP BY color; 


-- 12. Вложенные коррелированные подзапросы в качестве 
-- производных таблиц в предложении FROM.
-- Вывести всех изеров у которых розовые шлема.
SELECT users.id, nickname, id_device
FROM users
JOIN (
    SELECT id
    FROM device
    WHERE color = 'pink'
    ) AS D ON users.id_device = D.id;

-- 13. вложенные подзапросы с уровнем вложенности 3
-- Вывести все миры,
-- У которых пользователи играют в
-- Розовом шлеме.
SELECT id, name
FROM world
WHERE id in
      (
          SELECT id_world
          FROM world_user
          WHERE id_user IN
                (
                    SELECT id
                    FROM users
                    WHERE id_device IN
                          (
                              SELECT id
                              FROM device
                              WHERE color = 'pink'
                          )
                )
      );

-- 14. предложения GROUP BY, но без предложения HAVING.
-- Вывести кол-во выпущенных шлемов, min и max 
-- цену для каждого цвета шлема.
SELECT color, COUNT(color) as cnt, MIN(price), MAX(price)
FROM device
-- WHERE price < 10000
GROUP BY color;

-- Вывести кол-во игр каждого возрастного ограничения.
SELECT age_restrictions, COUNT(age_restrictions) AS count_age_restrictions
FROM world
GROUP BY age_restrictions;

-- 15. предложения GROUP BY и предложения HAVING
-- Вывести кол-во шлемов, у которых кол-во цветов
-- выпущенного шлема меньше 100.
SELECT color, COUNT(color) as cnt
FROM device
GROUP BY color
HAVING COUNT(color) < 100;

-- Сгруппировать по кол-ву часов + кол-во часов должно быть больше 1000
SELECT number_of_hours, count(number_of_hours) AS count_num
FROM users 
GROUP BY number_of_hours 
HAVING  number_of_hours> 1000;

-- Сгрувппировать по цене + цена < 1000.
SELECT price, count(price) AS count_price
FROM device
GROUP BY price
HAVING price < 1000;

