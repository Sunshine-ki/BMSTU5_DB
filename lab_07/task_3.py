# Спасибо статейке:
# https://habr.com/ru/post/322086/
# И, конечно, документации:
# http://docs.peewee-orm.com
# -----------------------------------
# таблица связи между типом поля в нашей модели и в базе данных:
# http://docs.peewee-orm.com/en/latest/peewee/models.html#field-types-table

from peewee import *

from colors import *

# Подключаемся к нашей БД.
con = PostgresqlDatabase(
	database='postgres',
	user='lis',
	password='password',
	host='127.0.0.1', 
	port=5432
)


class BaseModel(Model):
	class Meta:
		database = con


class Device(BaseModel):
	id = IntegerField(column_name='id')
	company = CharField(column_name='company')
	year_of_issue = IntegerField(column_name='year_of_issue')
	color = CharField(column_name='color')
	price = IntegerField(column_name='price')

	class Meta:
		table_name = 'device'


class World(BaseModel):
	id = IntegerField(column_name='id')
	name = CharField(column_name='name')
	founder = CharField(column_name='founder')
	year_of_issue = IntegerField(column_name='year_of_issue')
	genre = CharField(column_name='genre')
	age_restrictions = IntegerField(column_name='age_restrictions')
	price = IntegerField(column_name='price')

	class Meta:
		table_name = 'world'

class Users(BaseModel):
	id = IntegerField(column_name='id')
	nickname = CharField(column_name='nickname')
	age = IntegerField(column_name='age')
	sex = CharField(column_name='sex')
	number_of_hours = IntegerField(column_name='number_of_hours')
	id_device = IntegerField(column_name='id_device')
	# id_device = ForeignKeyField(Device, field='id', backref='id_device', object_id_name='aaa')

	class Meta:
		table_name = 'users'

class BlackList(BaseModel):
	id = IntegerField(column_name='id')
	user_id = ForeignKeyField(Users, backref='user_id')
	world_id = ForeignKeyField(World, backref='world_id')

	class Meta:
		table_name = 'users_black_list'

def query_1():
	# 1. Однотабличный запрос на выборку.
	user = Users.get(Users.id == 2)
	print(GREEN, f'{"1. Однотабличный запрос на выборку:":^130}')
	print(user.id, user.nickname, user.age, user.sex, user.number_of_hours)

	# Получаем набор записей.
	query = Users.select().where(Users.age > 18).limit(5).order_by(Users.id)

	print(BLUE, f'\n{"Запрос:":^130}\n\n', query, '\n')
	
	users_selected = query.dicts().execute()

	print(YELLOW, f'\n{"Результат:":^130}\n')
	for elem in users_selected:
		print(elem)

def query_2():
	# 2. Многотабличный запрос на выборку.
	global con 
	print(GREEN, f'\n{"2. Многотабличный запрос на выборку:":^130}\n')
	
	print(BLUE, f'{"Изеры и игры, в которых они заблокированы:":^130}\n')

	# Изеры и игры, в которых они заблокированы.
	query = Users.select(Users.id, Users.nickname, World.name).join(BlackList).join(World).order_by(Users.id).limit(5).where(Users.id>2)
	
	u_b = query.dicts().execute()
	for elem in u_b:
		print(elem)

	print(GREEN, f'\n{"Изер и цвет его шлема:":^130}\n')

	# Изер и цвет его шлема.
	query = Users.select(Users.id, Device.color).join(Device, on=(Users.id_device == Device.id)).limit(5)

	u_d = query.dicts().execute()

	for elem in u_d:
		print(elem)

	# Большой join
	# Цвет шлема, изер и миры в которых он забанен.
	# query = Users.select(Users.id, Users.nickname, World.name, Device.color).join(BlackList).join(World).join(Device, on=(Users.id_device == Device.id)).order_by(Users.id).limit(50).where(Users.id>2)

def print_last_five_users():
	# Вывод последних 5-ти записей.
	print(BLUE, f'\n{"Последнии 5 пользователей:":^130}\n')
	query = Users.select().limit(5).order_by(Users.id.desc())
	for elem in query.dicts().execute():
		print(elem)
	print()

def add_user(new_id, new_nickname, new_age, new_sex, new_number_of_hours, new_id_device):
	global con 
	
	try:
		with con.atomic() as txn:
			# user = Users.get(Users.id == new_id)
			Users.create(id=new_id, nickname=new_nickname, age=new_age, sex=new_sex, number_of_hours=new_number_of_hours, id_device=new_id_device)
			print(GREEN, "Пользователь успешно добавлен!")
	except:
		print(YELLOW, "Пользователь уже существует!")
		txn.rollback()

def update_nickname(user_id, new_nickname):
	user = Users(id=user_id)
	user.nickname = new_nickname
	user.save()	
	print(GREEN, "Nickname успешно обновлен!")

def del_user(user_id):
	print(GREEN, "Пользователь успешно удален удален!")
	user = Users.get(Users.id == user_id)
	user.delete_instance()

def query_3():
	# 3. Три запроса на добавление, изменение и удаление данных в базе данных.
	print(GREEN, f'\n{"3. Три запроса на добавление, изменение и удаление данных в базе данных:":^130}\n')

	print_last_five_users()

	add_user(1020, 'Sunshine-ki', 20, 'f', 500, 123)
	print_last_five_users()

	update_nickname(1020, 'Lis')
	print_last_five_users()

	del_user(1020)	
	print_last_five_users()

def query_4():
	# 4. Получение доступа к данным, выполняя только хранимую процедуру.
	global con 
	# Можно выполнять простые запросы.
	cursor = con.cursor()

	print(GREEN, f'\n{"4. Получение доступа к данным, выполняя только хранимую процедуру:":^130}\n')

	# cursor.execute("SELECT * FROM users ORDER BY id DESC LIMIT 5;")
	# for elem in cursor.fetchall():
	# 	print(*elem)

	print_last_five_users()

	cursor.execute("CALL update_user(%s, %s);", (1000,55))
	# # Фиксируем изменения.
	# # Т.е. посылаем команду в бд.
	# # Метод commit() помогает нам применить изменения,
	# # которые мы внесли в базу данных,
	# # и эти изменения не могут быть отменены,
	# # если commit() выполнится успешно.
	con.commit()

	print_last_five_users()

	cursor.execute("CALL update_user(%s, %s);", (1000,123))
	con.commit()

	cursor.close()
	


def task_3():
	global con 

	query_1()
	query_2()
	query_3()
	query_4()

	con.close()	