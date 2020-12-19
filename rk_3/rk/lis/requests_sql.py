TASK_2_3 = """
SELECT e.id, e.fio 
FROM employee AS e 
JOIN employee_attendance AS e_a ON (e_a.employee_id = e.id) 
WHERE ((e_a.time > '09:00:00') AND (e_a.type = 1)) 
GROUP BY e.id, e.fio 
HAVING (Count(e.id) > 2)
"""


