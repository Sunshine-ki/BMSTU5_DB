from py_linq import *


from user import *
from task_1 import *


def main():
	# Создаем коллекцию.
	users = Enumerable(create_users('user.csv'))
	request_5(users)

if __name__ == "__main__":
	main()
