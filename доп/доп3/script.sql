WITH RECURSIVE tmp
AS (
    SELECT 1 i, 1 factorial

    UNION
    SELECT i + 1 i, factorial * (i + 1) factorial
    FROM tmp
    WHERE i < 10
) SELECT * FROM tmp;
-- ORDER BY factorial DESC
-- LIMIT 1;

-- :)
SELECT 10! AS factorial;
SELECT factorial(10);












-- Фибоначчи.
-- WITH RECURSIVE tmp
-- AS (
--     SELECT 1 i, 1 a, 1 b
--
--     UNION
--     SELECT i + 1 i, b, a + b
--     FROM tmp
--     WHERE i < 10
-- ) SELECT * FROM tmp;