from peewee import *
from datetime import *
from req import *

# Создаем соединение с базой данных
con = PostgresqlDatabase(
    database='postgres',
    user='kira',
    password='password',
    host='127.0.0.1', 
    port="5432"
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
    data = DateField(column_name='date')
    day_of_week =  CharField(column_name='day_of_week')
    time = TimeField(column_name='time')
    type = IntegerField(column_name='type')	

    class Meta:
        table_name = 'employee_attendance'

def Task1():
    global con

    cur = con.cursor()

    cur.execute(FirstQ)
    print("Запрос 1:\n")
    rows = cur.fetchall()
    for row in rows:
        print(*row)

    cur.execute(SecondQ)
    print("\nЗапрос 2:\n")
    rows = cur.fetchall()
    for row in rows:
        print(*row)

    cur.execute(ThirdQ)
    print("\nЗапрос 3:\n")
    rows = cur.fetchall()
    for row in rows:
        print(*row)

    cur.close()

def Task2():
    global con

    cur = con.cursor()
	
    print("1. Найти все отделы, в которых нет сотрудников моложе 25 лет")
    query = Employee.select(Employee.department).where(datetime.now().year - Employee.date_of_birth.year > '25')
    for q in query.dicts().execute():
        print(q)

    print("2. Найти сотрудника, который пришел сегодня на работу раньше всех")
    query = EmployeeAttendance.select(fn.Min(EmployeeAttendance.time).alias('earliest_time'))
    earliest_time = query.dicts().execute()
    print(earliest_time[0]['earliest_time'])
    query = EmployeeAttendance.select(EmployeeAttendance.employee_id).where(EmployeeAttendance.time == earliest_time[0]['earliest_time']).limit(1)
    for q in query.dicts().execute():
        print(q)
        
    print("3. Найти сотрудников, опоздавших не менее 5-ти раз")
    query = Employee.select(Employee.id, Employee.fio).join(EmployeeAttendance).where(EmployeeAttendance.time > '08:00:00').where(EmployeeAttendance.type==1).group_by(Employee.id, Employee.fio).having(fn.Count(Employee.id) > 5)
    for q in query.dicts().execute():
        print(q)

    cur.close()
	

def main():
	Task1()
	Task2()

	con.close()

if __name__ == "__main__":
	main()



