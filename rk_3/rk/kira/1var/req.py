FirstQ = """
SELECT department
FROM employee
WHERE EXTRACT (YEARS FROM now()) - EXTRACT (YEARS FROM date_of_birth) > 25;
"""

SecondQ = """
SELECT fio
FROM employee_attendance ea JOIN employee e ON ea.employee_id = e.id
WHERE date = current_date AND type = 1 AND time = (
    SELECT MIN(time)
    FROM employee_attendance
    )
"""

ThirdQ = """
SELECT e.id, e.fio 
FROM employee AS e 
JOIN employee_attendance AS e_a ON (e_a.employee_id = e.id) 
WHERE ((e_a.time > '09:00:00') AND (e_a.type = 1)) 
GROUP BY e.id, e.fio 
HAVING (Count(e.id) > 2);
"""
