# Спасибо статейке:
# https://habr.com/ru/post/322086/
# И, конечно, документации:
# http://docs.peewee-orm.com

from peewee import *

from colors import *

con = None

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


def task_3():
	global con 

	# Можно выполнять простые запросы.
	# cursor = con.cursor()
	# cursor.execute("SELECT * FROM device")
	# print(cursor.fetchall())
	# cursor.close()
	
	# 1. Однотабличный запрос на выборку.
	user = Users.get(Users.id == 2)
	print(BLUE, f'{"1.Однотабличный запрос на выборку:":^130}')
	print(user.id, user.nickname, user.age, user.sex, user.number_of_hours)

	# Получаем набор записей.
	query = Users.select().where(Users.age > 18).limit(5).order_by(Users.id)

	print(GREEN, f'\n{"Запрос:":^130}\n', query, '\n')
	
	users_selected = query.dicts().execute()

	print(YELLOW, f'\n{"Результат:":^130}\n')
	for elem in users_selected:
		print(elem)

	# Многотабличный запрос на выборку.
	print(BLUE, f'\n{"2.Многотабличный запрос на выборку:":^130}\n')
	
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



	con.close()	