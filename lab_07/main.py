from peewee import *

from user import *
from task_1 import *
from task_2 import *

con = None

# Подключаемся к нашей БД.
con = PostgresqlDatabase(
	database='postgres',
	user='lis',
	password='password',
	host='127.0.0.1', 
	port=5432
)

# Спасибо статейке:
# https://habr.com/ru/post/322086/
# И, конечно, документации:
# http://docs.peewee-orm.com

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



def main():
	# спросить у пользователя номер задания и выполнить, то что он попросил.
	# TODO: task 1
	# Создаем коллекцию.
	# users = Enumerable(create_users('data/user.csv'))
	# request_5(users)
	# TODO: task 2
	# con = connection()
	# # Объект cursor используется для фактического
	# # выполнения наших команд.
	# cur = con.cursor()

	# users_array = read_table_json(cur)
	# update_user(users_array, 2)
	# add_user(users_array, user(1111, 'Sunshine-ki', 20, 'f', 500, 123))

	# # Закрываем соединение с БД.
	# cur.close()
	# con.close()

	# TODO: task 3
	global con 

	# Можно выполнять простые запросы.
	# cursor = con.cursor()
	# cursor.execute("SELECT * FROM device")
	# print(cursor.fetchall())
	# cursor.close()
	
	# Одиночная запись.
	# user = Users.get(Users.id == 2)
	# print(user.nickname, user.age, user.sex)

	# Получаем набор записей.
	# query = Users.select().limit(5)
	# print(query)

	# query = Users.select().where(Users.age > 18).limit(5).order_by(Users.id)
	# print(query)

	query = Users.select().limit(5)
	users_selected = query.dicts().execute()

	query = World.select().limit(5)
	world_selected = query.dicts().execute()
	# print(users_selected)

	query = BlackList.select().limit(5)
	# print(query)
	black_list_selected = query.dicts().execute()


	# query = Users.select().join(BlackList).limit(5)
	# u_b = query.dicts().execute()
	# print(query)

	# for elem in u_b:
	# 	print(elem.content)

	# query = Users.select(Users.id, BlackList.world_id).join(BlackList).limit(5)#.where(BlackList.world_id==0)	

	# Изеры и игры, в которых они заблокированы.
	query = Users.select(Users.id, Users.nickname, World.name).join(BlackList).join(World).order_by(Users.id).limit(5).where(Users.id>2)
	u_b = query.dicts().execute()

	for elem in u_b:
		print(elem)


	# Изер и цвет его шлема.
	query = Users.select(Users.id, Device.color).join(Device, on=(Users.id_device == Device.id)).limit(5)

	u_d = query.dicts().execute()

	for elem in u_d:
		print(elem)

	# Большой join
	# Цвет шлема, изер и миры в которых он забанен.
	# query = Users.select(Users.id, Users.nickname, World.name, Device.color).join(BlackList).join(World).join(Device, on=(Users.id_device == Device.id)).order_by(Users.id).limit(50).where(Users.id>2)


	con.close()

if __name__ == "__main__":
	main()
