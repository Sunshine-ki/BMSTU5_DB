CREATE TABLE IF NOT EXISTS Table1
(
	id INT,
	var1 CHAR,
	date_from DATE,
	date_to DATE
);

CREATE TABLE IF NOT EXISTS Table2
(
    id INT,
	var2 CHAR,
	date_from DATE,
	date_to DATE
);

INSERT INTO Table1 VALUES (1, 'A', '2018-09-01', '2018-09-15');
INSERT INTO Table1 VALUES (1, 'B', '2018-09-16', '5999-12-31');

INSERT INTO Table2 VALUES (1, 'A', '2018-09-01', '2018-09-18');
INSERT INTO Table2 VALUES (1, 'B', '2018-09-19', '5999-12-31');

SELECT * FROM Table1;
SELECT * FROM Table2;

CREATE OR REPLACE FUNCTION get_min_date(dt1 DATE, dt2 DATE)
RETURNS DATE AS '
    SELECT CASE
        WHEN dt1 < dt2
            THEN dt1
        ELSE dt2
    END
' LANGUAGE sql;

CREATE OR REPLACE FUNCTION get_max_date(dt1 DATE, dt2 DATE)
RETURNS DATE AS '
    SELECT CASE
        WHEN dt1 > dt2
            THEN dt1
        ELSE dt2
    END
' LANGUAGE sql;

SELECT t1.id, t1.var1, t2.var2,
       get_max_date(t1.date_from, t2.date_from),
       get_min_date(t1.date_to, t2.date_to)
FROM Table1 t1
JOIN Table2 t2 ON
t1.date_from < t2.date_to
AND t2.date_from < t1.date_to;