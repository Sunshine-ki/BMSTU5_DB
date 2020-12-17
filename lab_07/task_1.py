# Документация: 
# https://viralogic.github.io/py-enumerable/

from py_linq import *

from user import *
from colors import *

def request_1(users):
	# Юзеры старше 50 лет отсортированные по нику.
	result = users.where(lambda x: x['age'] >= 50).order_by(lambda x: x['nickname']).select(lambda x: {x['nickname'], x['age']})
	return result

	# Отсортированные имена.
	# names = users.select(lambda x: x['nickname']).order_by(lambda x: x)
	# names = users.select(lambda x: {x['nickname'], x['age']})


def request_2(users):
	# Необязательным параметром является условие. 
	# Количество изеров, старше 50.
	result = users.count(lambda x: x['age'] >= 50)
	
	return result


def request_3(users):
	# минимальный, максимальный возраст.
	age = Enumerable([{users.min(lambda x: x['age']), users.max(lambda x: x['age'])}])
	# минимальное, минимальное кол-во часов в игре.
	name = Enumerable([{users.min(lambda x: x['number_of_hours']), users.max(lambda x: x['number_of_hours'])}])
	# А теперь объединяем все это.
	result = Enumerable(age).union(Enumerable(name), lambda x: x)
	
	return result

def request_4(users):
	# Группировка по полу.
	result = users.group_by(key_names=['sex'], key=lambda x: x['sex']).select(lambda g: {'key': g.key.sex, 'count': g.count()})
	return result
	# Кол-во группировок.
	# tmp = users.group_by(key_names=['sex'], key=lambda x: x['sex']).count()

def request_5(users):
	device = Enumerable([{'id':244, 'color':'red'}, {'id':143, 'color':'blue'}, {'id':390, 'color':'green'}])
	# inner_key = i_k первичный ключ
	# outer_key = o_k внешний ключ
	# inner join 
	u_d = users.join(device, lambda o_k : o_k['id_device'], lambda i_k: i_k['id'])

	for elem in u_d:
		print(elem)

	return u_d

def task_1():
	# Создаем коллекцию.
	users = Enumerable(create_users('data/user.csv'))

	print(GREEN, '\n1.Юзеры старше 50 лет, отсортированные по нику:\n')
	for elem in request_1(users): 
		print(elem)

	print(YELLOW, f'\n2.Количество изеров, старше 50: {str(request_2(users))}')

	print(BLUE, '\n3.Некоторые характеристики:\n')
	for elem in request_3(users): 
		print(elem)

	print(GREEN, '\n4.Группировка по полу:\n')
	for elem in request_4(users): 
		print(elem)

	print(GREEN, '\n5.Соединяем изера и его шлем (цвет):\n')
	for elem in request_5(users): 
		print(elem)
