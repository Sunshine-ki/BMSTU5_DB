from peewee import *

from requests_sql import *

# Создаем соединение с базой данных
con = PostgresqlDatabase(
    database='postgres',
    user='kira',
    password='password',
    host='127.0.0.1', 
    port="5432"
)

def output(cur):
	rows = cur.fetchall()
	for elem in rows:
		print(*elem)
	print()

def task_1():
	global con

	cur = con.cursor()

	# cur.execute(TASK_2_1)
	# output(cur)

	cur.close()

def main():
	task_1()

if __name__ == "__main__":
	main()


con.close()

# class BaseModel(Model):
# 	class Meta:
# 		database = con

# class Employee(BaseModel):
# 	id = IntegerField(column_name='id')
# 	name = CharField(column_name='name')
# 	surname = CharField(column_name='surname')
# 	date_of_birth = DateField(column_name='date_of_birth')
# 	department = CharField(column_name='department')
# 	employee_time = TimeField(column_name='employee_time')
# 	employee_id = ForeignKeyField(Employee, backref='employee_id')


# 	class Meta:
# 		table_name = 'employee'
