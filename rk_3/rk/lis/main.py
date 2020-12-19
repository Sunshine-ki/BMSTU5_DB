from peewee import *

from requests_sql import *
from datetime import *

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


class Employee(BaseModel):
	id = IntegerField(column_name='id')
	fio = CharField(column_name='fio')
	date_of_birth = DateField(column_name='date_of_birth')
	department = CharField(column_name='department')

	class Meta:
		table_name = 'employee'

class EmployeeAttendance(BaseModel):
	id = IntegerField(column_name='id')
	employee_id = ForeignKeyField(Employee, backref='employee_id')
	e_data = DateField(column_name='date')
	day_of_week =  CharField(column_name='day_of_week')
	e_time = TimeField(column_name='time')
	e_type = IntegerField(column_name='type')	

	class Meta:
		table_name = 'employee_attendance'	

def output(cur):
	rows = cur.fetchall()
	for elem in rows:
		print(*elem)
	print()

def print_query(query):
	for elem in query.dicts().execute():
		print(elem)
		# print(elem['employee_data'].isocalendar()[1] )

def task_1():
	global con

	cur = con.cursor()

	# cur.execute(TASK_2_1)
	# output(cur)


	cur.close()


def task_2():
	print("1. Найти все отделы, в которых нет сотрудников моложе 25 лет")
	# query = Employee.select(Employee.department).join(EmployeeAttendance).where(EmployeeAttendance.employee_time > '09:00:00').where(EmployeeAttendance.e_type==1).group_by(Employee.department).having(fn.Count(Employee.id) > 2)
	# tmp = 
	# query = Employee.select(datetime.now().year - Employee.date_of_birth.year)
	# query = Employee.select(datetime.now() - Employee.date_of_birth)
	tmp = datetime.now().year - Employee.date_of_birth.year
	query = Employee.select(Employee.department).where(tmp > '25')#.where(Employee.date_of_birth.year > '2000-02-01')
	# print_query(query)

	print("2. Найти сотрудника, который пришел сегодня на работу раньше всех")
	# tmp = 
	# sql_min = fn.Min(EmployeeAttendance.e_time)

	# query = Employee.select(Employee.id, Employee.fio,EmployeeAttendance.e_time).join(EmployeeAttendance).group_by(EmployeeAttendance.e_time)


	# query = Employee.select(Employee.id, Employee.fio,EmployeeAttendance.e_time).join(EmployeeAttendance).group_by(EmployeeAttendance.e_time)
	# .where(EmployeeAttendance.e_type==1).where(EmployeeAttendance.e_time==sql_min)
	# print_query(query)

	print("3. Найти сотрудников, опоздавших не менее 5-ти раз")

	# query = Employee.select(Employee.department).join(EmployeeAttendance).where(EmployeeAttendance.e_time > '09:00:00').where(EmployeeAttendance.e_type==1).where(fn.Count(Employee.id) > 2)
	query = Employee.select(Employee.id, Employee.fio).join(EmployeeAttendance).where(EmployeeAttendance.e_time > '09:00:00').where(EmployeeAttendance.e_type==1).group_by(Employee.id, Employee.fio)
	#, on=(EmployeeVisit.employee_id==Employee.id))
	# print(query) 
	print_query(query)

def main():
	# task_1()
	task_2()

if __name__ == "__main__":
	main()


con.close()