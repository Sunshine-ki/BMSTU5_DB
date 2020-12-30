TASK_2_1 = """
SELECT department
FROM employee
WHERE ((EXTRACT(year FROM CURRENT_DATE) - EXTRACT(year FROM date_of_birth)) > 25)
"""

TASK_2_2 = """
SELECT employee.id, employee.fio
FROM employee_attendance
JOIN employee ON employee_attendance.employee_id = employee.id
WHERE date = CURRENT_DATE
AND type = 1
AND time IN
(
    SELECT MIN(time)
    FROM employee_attendance
    WHERE date = CURRENT_DATE
    AND type = 1
)
LIMIT 1;
"""

TASK_2_3 = """
SELECT e.id, e.fio 
FROM employee AS e 
JOIN employee_attendance AS e_a ON e_a.employee_id = e.id
WHERE (e_a.time > '09:00:00') AND (e_a.type = 1) 
GROUP BY e.id, e.fio 
HAVING (Count(e.id) > 5);
"""
