-- SELECT *
-- FROM world;

-- 1. предикат сравнения.
-- Вывести никнеймы и часы всех девушек в возрасте от 20 до 35 лет
SELECT nickname as nick, number_of_hours
FROM user
WHERE age BETWEEN 20 AND 35 and sex='f';

-- 2. предикат BETWEEN.
-- Найти id юзера и id девайса, где девайс использовали
-- в промежуток от 2000 до 2020 года и id девайса четное.
SELECT id_user, id_device
FROM device_history
WHERE year_begin BETWEEN 2000 AND 2020 AND (id_device % 2) = 0;
-- Либо так:
-- WHERE year_begin >= 2000 AND year_begin <= 2020 AND (id_device % 2) = 0;

-- 3. предикат LIKE.
-- Получить название и жанр игр, содержащих в названии слово 'alcie'
SELECT name, genre
FROM world
WHERE name like '%alice%';

-- Получить название и год выпуска игр, содержащих в названии не менее 2-ух слов.
SELECT name, year_of_issue
FROM world
WHERE name like '% % %';

-- 4. предикат IN с вложенным подзапросом.
-- Вывести компнию и цену девайса у которого цвет pink or purple or coral
SELECT company, price
FROM device 
WHERE color IN ('pink', 'purple', 'coral');

-- Вывести имена и кол-во часов игроков, которые играют в игры 18+
SELECT nickname, number_of_hours
FROM user
where user.id IN
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
-- Вывести все миры в которые играют как девочки так и мальчики.
-- SELECT name
-- FROM world
-- where id in
-- (
-- SELECT world_id
-- FROM
-- (
-- user u LEFT JOIN world_user w_u ON u.id=w_u.id_user
-- LEFT JOIN world w ON w_u.id_world=w.id
-- ) as UWUW
-- WHERE sex = 'm' 
-- );
-- -- AND EXISTS
-- -- (
-- -- SELECT user_id
-- -- FROM UWUW
-- -- WHERE sex = 'f' AND id_world = UWUW.user_id
-- -- )
-- -- );
-- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- SELECT name
-- from world
-- WHERE id in
-- (
-- FROM (
-- SELECT nickname, name, u.id as user_id, w.id as world_id
-- FROM user u
-- LEFT JOIN world_user w_u
-- ON u.id=w_u.id_user
-- LEFT JOIN world w
-- ON w_u.id_world=w.id
-- ) AS t1
-- )
-- ;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 6. предикат сравнения с квантором.
-- Получить всех юзеров, кол-во часов у которых больше
-- чем у любой девушки с кол-вом часов более 1000
SELECT nickname as name, number_of_hours
FROM user
WHERE number_of_hours > ALL
(
	SELECT number_of_hours
	FROM user
	WHERE sex = 'f' AND number_of_hours > 1000
);

-- Получить всех мужчик, у которых кол-во 
-- часов больше чем у любой женщины.
SELECT nickname as name, number_of_hours
FROM user
WHERE number_of_hours > ALL
(
	SELECT number_of_hours
	FROM user
	WHERE sex = 'f'
) AND sex = 'm';

-- 7. агрегатные функции в выражениях столбцов.
-- Вывести кол-во девушек.
SELECT COUNT(sex)
FROM user
WHERE sex='f';

-- Узнать самую взрослую женщину. 
SELECT MAX(age) max_age
FROM user
WHERE sex = 'f';

-- Узнать какого пола пользователей больше.
SELECT MAX(sex)
FROM user;

-- Узнать кол-во девушек и мужчин.
SELECT sex, COUNT(sex)
FROM user
GROUP BY sex;

-- Вывести максимальное кол-во выпущенных миров в год
-- TODO: Как вывести года в котрые выпускали максимальное кол-во миров?
SELECT year_of_issue
FROM
 (
	SELECT year_of_issue, COUNT(year_of_issue) as cnt
	FROM world
	GROUP BY year_of_issue
	ORDER BY cnt
) AS t1
WHERE cnt = 
(
	SELECT MAX(cnt) 
	FROM t1
)

SELECT year_of_issue
FROM t1
WHERE year_of_issue = 
(
SELECT MAX(cnt) 
FROM t1
);



-- FIXME: Концовочка 
-- with t1(year_of_issue, cnt) as (
-- 	SELECT year_of_issue, COUNT(year_of_issue) as cnt
-- 	FROM world
-- 	GROUP BY year_of_issue
-- 	ORDER BY cnt
-- ) 
-- SELECT * 
-- FROM t1;
-- SELECT year_of_issue
-- FROM t1
-- WHERE year_of_issue = 
-- (
-- SELECT MAX(cnt) 
-- FROM t1
-- );



-- 8. калярные подзапросы в выражениях столбцов
-- TODO: Разобраться с этим
SELECT nickname, 
(
	SELECT MIN(year_of_issue)
	FROM device
	WHERE device.id = user.id_device
) AS t1
FROM user;

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
WHEN price > 
(
	SELECT AVG(price)
	FROM device
)
THEN 'Доступная цена'
ELSE 'Повышенная цена'
END AS comment
FROM device
ORDER BY price;


-- 11. Создание новой временной локальной таблицы.
-- TODO: Почему не работают ?
SELECT color, COUNT(color)
INTO #firstLocalTable
FROM device
GROUP BY color; 

SELECT id
INTO #table1
FROM user

-- 12. Вложенные коррелированные подзапросы в качестве 
-- производных таблиц в предложении FROM.

-- 13. вложенные подзапросы с уровнем вложенности 3

-- 14. предложения GROUP BY, но без предложения HAVING.
-- Вывести кол-во выпущенных шлемов, min и max 
-- цену для каждого цвета шлема.
SELECT color, COUNT(color) as cnt, MIN(price), MAX(price)
FROM device
GROUP BY color;

-- 15. предложения GROUP BY и предложения HAVING
SELECT number_of_hours, count(number_of_hours)  
FROM user 
GROUP BY number_of_hours 
HAVING number_of_hours > 1000;

SELECT age_restrictions, COUNT(age_restrictions) AS 'Avarage age restrictions'
FROM world
GROUP BY age_restrictions