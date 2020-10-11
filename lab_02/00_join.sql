-- Вывести цвет шлема у каждого пользователя.
SELECT users.id, device.id, nickname, color
FROM users 
JOIN device
ON users.id_device = device.id;

-- Связка людей и миров.
SELECT nickname, name, u.id as user_id, w.id as world_id
FROM users u
LEFT JOIN world_user w_u
ON u.id=w_u.id_user
LEFT JOIN world w
ON w_u.id_world=w.id;

