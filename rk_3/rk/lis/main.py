from peewee import *

from requests_sql import *
from datetime import *

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
    e_date = DateField(column_name='date')
    day_of_week = CharField(column_name='day_of_week')
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


def task_1():
    global con

    cur = con.cursor()

    cur.execute(TASK_2_1)
    print("Задание 1:")
    output(cur)

    cur.execute(TASK_2_2)
    print("Задание 2:")

    output(cur)

    cur.execute(TASK_2_3)
    print("Задание 3:")
    output(cur)

    cur.close()


def task_2():
    print("1. Найти все отделы, в которых нет сотрудников моложе 25 лет")
    tmp = datetime.now().year - Employee.date_of_birth.year
    query = Employee.select(Employee.department).where(tmp > '25')
    print_query(query)

    print("2. Найти сотрудника, который пришел сегодня на работу раньше всех")
    query = EmployeeAttendance.select(
        fn.Min(EmployeeAttendance.e_time).alias('min_time')).where(EmployeeAttendance.e_type == 1 and EmployeeAttendance.e_date == date.today())
    min_time = query.dicts().execute()
    # print(min_time[0]['min_time'])
    # (Чтобы запрос что-то вывел нужно добавить сотрудников, которые пришли сегодня.)
    query = EmployeeAttendance.select(EmployeeAttendance.employee_id).where(
        EmployeeAttendance.e_time == min_time[0]['min_time']).where(EmployeeAttendance.e_type == 1 and EmployeeAttendance.e_date == date.today()).limit(1)
    print_query(query)

    print("3. Найти сотрудников, опоздавших не менее 5-ти раз")
    # Данных не так много, поэтому для наглядности можно сделать опоздания не более 2 раз (тогда увидим результат).
    query = Employee.select(Employee.id, Employee.fio).join(EmployeeAttendance).where(EmployeeAttendance.e_time > '09:00:00').where(
        EmployeeAttendance.e_type == 1).group_by(Employee.id, Employee.fio).having(fn.Count(Employee.id) > 5)
    print_query(query)


def main():
    task_1()
    task_2()


if __name__ == "__main__":
    main()


con.close()
