from user import user
import json
import psycopg2

from colors import * 

def connection():
	con = None
	# Подключаемся к БД.
	try:
		con = psycopg2.connect(
			database="postgres",
			user="lis",
			password="password",
			host="127.0.0.1",  # Адрес сервера базы данных.
			port="5432"		   # Номер порта.
		)
	except:
		print("Ошибка при подключении к БД")
		return con

	print("База данных успешно открыта")
	return con
	
def output_json(array):
	print(BLUE)
	for elem in array:
		print(json.dumps(elem.get()))
	print(YELLOW)

def read_table_json(cur, count = 15):
	# Возвращает массив кортежей словарей.
	cur.execute("select * from users_json")

	# with open('data/task_2.json', 'w') as f:
	    # f.write(rows)

	rows = cur.fetchmany(count)

	array = list()
	for elem in rows: 
		tmp = elem[0]
		# print(elem[0], sep=' ', end='\n')
		array.append(user(tmp['id'], tmp['nickname'], tmp['age'], tmp['sex'],
		tmp['number_of_hours'], tmp['id_device']))

	print(GREEN,f"{'id':<2} {'nickname':<20} age  sex number_of_hours id_device")
	print(*array, sep='\n')
	
	return array


def update_user(users, in_id):
	# Увеличивает возраст пользователя.
	for elem in users:
		if elem.id == in_id:
			elem.age += 1

	# dumps - сериализация. 
	# print(json.dumps(users[0].get()))
	output_json(users)

def add_user(users, user):
	users.append(user)
	output_json(users)

def task_2():
	con = connection()
	# Объект cursor используется для фактического
	# выполнения наших команд.
	cur = con.cursor()

	# 1. Чтение из XML/JSON документа.
	print(GREEN, f'{"1.Чтение из XML/JSON документа:":^130}')
	users_array = read_table_json(cur)
	# 2. Обновление XML/JSON документа.
	print(BLUE, f'\n{"1.Обновление XML/JSON документа:":^130}')
	update_user(users_array, 2)
	# 3. Запись (Добавление) в XML/JSON документ.
	print(BLUE, f'{"1.Запись (Добавление) в XML/JSON документ:":^130}')
	add_user(users_array, user(1111, 'Sunshine-ki', 20, 'f', 500, 123))

	# Закрываем соединение с БД.
	cur.close()
	con.close()