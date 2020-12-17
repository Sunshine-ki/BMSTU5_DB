from peewee import *

from requests_sql import *

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

	query = Employee.select(Employee.id, Employee.name).join(EmployeeVisit).where(EmployeeVisit.employee_time > '09:00:00').where(EmployeeVisit.e_type==1)
	 #, on=(EmployeeVisit.employee_id==Employee.id))
	
	print_query(query)

def main():
	task_2()
	task_2_orm()

if __name__ == "__main__":
	main()

con.close()
