from task_1 import *
from task_2 import *
from task_3 import *

def main():
	answer = int(input(GREEN + "Номер задания: "))
	
	if answer == 1:
		task_1()
	elif answer == 2:
		task_2()
	elif answer == 3:
		task_3()

if __name__ == "__main__":
	main()
