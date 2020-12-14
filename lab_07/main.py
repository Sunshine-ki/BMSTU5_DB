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

class Users(BaseModel):
	id = IntegerField(column_name='id')
	nickname = CharField(column_name='nickname')
	age = IntegerField(column_name='age')
	sex = CharField(column_name='sex')
	number_of_hours = IntegerField(column_name='number_of_hours')
	id_device = IntegerField(column_name='id_device')

	class Meta:
		table_name = 'users'


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
	user = Users.get(Users.id == 2)
	print(user.nickname, user.age, user.sex)

	# Получаем набор записей.
	query = Users.select()
	# print(query)

	query = Users.select().where(Users.age > 18).limit(5).order_by(Users.id)
	print(query)

	users_selected = query.dicts().execute()
	# print(users_selected)

	for elem in users_selected:
		print(elem)

		

	con.close()

if __name__ == "__main__":
	main()
