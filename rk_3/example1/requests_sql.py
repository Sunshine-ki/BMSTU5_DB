TASK_2_1 = """
-- 1. Отделы, в которых сотрудники опаздывают более 2х раз в неделю
-- (По заданию 3х раз, но я сделала 2х, чтобы много данных в таблицу не добавлять)
SELECT department
FROM employee t1
WHERE EXISTS
(
	SELECT department
	FROM employee e
--	 WHERE e.id = t1.id
	-- И если существет таблица, показывающая
	-- В какие недели работник опаздывал,
	-- То выводим его отдел.
	WHERE EXISTS
	(
		-- Внутренный запрос вернет таблицу, в которой
		-- Первой столбец будет неделя (по счету, первая, вторя...)
		-- А второй, кол-во опозданий сотрудника в этой недели.
		-- Соответственно, если опозданий нет, то таблица пуста.
		SELECT date_part, COUNT(date_part) AS cnt
		FROM
		(
			SELECT *
			FROM employee_visit, EXTRACT(WEEK FROM employee_data) AS date_part
			WHERE employee_time > '09:00:00'
			AND type = 1
			AND employee_id = t1.id
		) AS tmp
		GROUP BY date_part
		HAVING COUNT(date_part) > 2
	)
);
"""

TASK_2_2 = """
-- 2. Найти средний возраст сотрудников, не находящихся
-- на рабочем месте 8 часов в неделю.
SELECT AVG(age)
FROM (
    SELECT *, (CURRENT_DATE - employee.date_of_birth) / 7 / 52 AS age   -- 7 - дней в неделе, 52 - недель в году.
    FROM
    (
        SELECT *,
        (
            SELECT EXTRACT(HOURS FROM e_v2.employee_time) - EXTRACT(HOURS FROM e_v.employee_time) -- e_v2.employee_time - e_v.employee_time
            FROM employee_visit e_v2
            WHERE employee_id = e_v.employee_id
            AND e_v2.employee_data = e_v.employee_data
            AND type = 2
        ) AS working_hours
        FROM employee_visit e_v
        WHERE type = 1
    ) AS tmp JOIN employee ON tmp.employee_id = employee.id
    WHERE working_hours <= 9) AS table_res;
"""

TASK_2_3 = """
-- 3. Все отделы и кол-во сотрудников
-- Хоть раз опоздавших за всю историю учета.
SELECT department, COUNT(employee.id)
FROM employee
JOIN employee_visit ev on employee.id = ev.employee_id
WHERE employee_time > '09:00:00'
AND type = 1
GROUP BY department;
"""