-- вывести цвет шлема у каждого пользователя.
select users.id, device.id, nickname, color
from users
join device
on users.id_device = device.id;

-- связка людей и миров.
select nickname, name, u.id as user_id, w.id as world_id
from users u
join world_user w_u
on u.id=w_u.id_user
join world w
on w_u.id_world=w.id
ORDER BY u.id;

-- Статистика по компаниям.
-- Сколько человек используют
-- шлем той или иной компании.
SELECT company, COUNT(company)
FROM users
JOIN device
ON users.id_device = device.id
GROUP BY company;