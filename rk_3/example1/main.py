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
	name = CharField(column_name='name')
	surname = CharField(column_name='surname')
	date_of_birth = DateField(column_name='date_of_birth')
	department = CharField(column_name='department')

	class Meta:
		table_name = 'employee'



class EmployeeVisit(BaseModel):
	id = IntegerField(column_name='id')	
	employee_id = ForeignKeyField(Employee, backref='employee_id')
	employee_data = DateField(column_name='employee_data')
	day_of_week =  CharField(column_name='day_of_week')
	employee_time = TimeField(column_name='employee_time')
	e_type = IntegerField(column_name='type')	

	class Meta:
		table_name = 'employee_visit'




def output(cur):
	rows = cur.fetchall()
	for elem in rows:
		print(*elem)
	print()

def task_2():
	global con

	cur = con.cursor()

	cur.execute(TASK_2_1)
	output(cur)

	cur.execute(TASK_2_2)
	print(*cur.fetchone(), "\n")

	cur.execute(TASK_2_3)
	output(cur)

	cur.close()

def print_query(query):
	for elem in query.dicts().execute():
		print(elem)
		# print(elem['employee_data'].isocalendar()[1] )

def task_2_orm():
	# 1.
	print("Отделы, в которых сотрудники опаздывают более 2х раз в неделю")
	query = Employee.select(Employee.department).join(EmployeeVisit).where(EmployeeVisit.employee_time > '09:00:00').where(EmployeeVisit.e_type==1).group_by(Employee.department).having(fn.Count(Employee.id) > 2)
	#, on=(EmployeeVisit.employee_id==Employee.id))
	print(query) 
	print_query(query)
	 
	# 2.
	print("\nНайти средний возраст сотрудников, не находящихся на рабочем месте 8 часов в неделю.")
	print(datetime.now())
	# datetime.datetime.now().year - Employee.date_of_birth.year
	# Это средний возраст сотрудников.
	query = Employee.select(fn.AVG(datetime.now().year - Employee.date_of_birth.year))
	print_query(query)
	
	# # Это сотрудники, которые находятся на рабочем месте менее 8 часов.
	sql_max = fn.Max(EmployeeVisit.employee_time)
	sql_min = fn.Min(EmployeeVisit.employee_time)
	query = Employee.select(
			EmployeeVisit.employee_data, EmployeeVisit.employee_id, 
			(sql_max - sql_min).alias("cnt")).join(EmployeeVisit).group_by(
			EmployeeVisit.employee_data, EmployeeVisit.employee_id).order_by(EmployeeVisit.employee_id).having(
				sql_max - sql_min > timedelta(hours=8))
	
	# А это недели.
	# res = query.dicts().execute()
	# for elem in res:
	# 	elem['week'] = elem['employee_data'].isocalendar()[1]
	# 	print(elem['employee_data'].isocalendar()[1])

	# query = Employee.select(EmployeeVisit.employee_data).join(EmployeeVisit).group_by(EmployeeVisit.employee_data)
	tmp = Employee.select(
			EmployeeVisit.employee_id).join(EmployeeVisit).group_by(
			EmployeeVisit.employee_data, EmployeeVisit.employee_id).order_by(EmployeeVisit.employee_id).having(
				sql_max - sql_min > timedelta(hours=8))
	query = Employee.select(fn.AVG(datetime.now().year - Employee.date_of_birth.year))#.where(Employee.id << tmp.employee_id)
	
	print_query(tmp)

	# 3.
	print("\nВсе отделы и кол-во сотрудников хоть раз опоздавших за всю историю учета.")
	query = Employee.select(Employee.department, fn.Count(Employee.id)).join(EmployeeVisit).where(
		EmployeeVisit.employee_time > '09:00:00').where(EmployeeVisit.e_type==1).group_by(Employee.department)

	print_query(query)



def main():
	task_2()
	task_2_orm()

if __name__ == "__main__":
	main()

con.close()
