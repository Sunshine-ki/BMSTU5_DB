from user import *
from task_1 import *
from task_2 import *

def main():
	# TODO: спросить у пользователя номер задания и выполнить, то что он попросил.
	# Создаем коллекцию.
	# users = Enumerable(create_users('data/user.csv'))
	# request_5(users)

	con = connection()
	# Объект cursor используется для фактического
	# выполнения наших команд.
	cur = con.cursor()

	users_array = read_table_json(cur)
	update_user(users_array, 2)
	add_user(users_array, user(1111, 'Sunshine-ki', 20, 'f', 500, 123))

	# Закрываем соединение с БД.
	cur.close()
	con.close()



if __name__ == "__main__":
	main()
