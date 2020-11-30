from tkinter import *
from tkinter import messagebox as mb


def create_list_box(rows, title, count=15):
    root = Tk()

    root.title(title)
    root.resizable(width=False, height=False)

    size = (count + 3) * len(rows[0]) + 1

    list_box = Listbox(root, width=size, height=22,
                       font="monospace 10", bg="lavender", highlightcolor='lavender', selectbackground='#59405c', fg="#59405c")

    list_box.insert(END, "█" * size)

    for row in rows:
        string = (("█ {:^" + str(count) + "} ") * len(row)).format(*row) + '█'
        list_box.insert(END, string)

    list_box.insert(END, "█" * size)

    list_box.grid(row=0, column=0)

    root.configure(bg="lavender")

    root.mainloop()


def execute_task4(cur, table_name):
    table_name = table_name.get()

    try:
        cur.execute(f"SELECT * FROM {table_name}")
    except:
        mb.showerror(title="Ошибка", message="Такой таблицы нет!")
        return

    rows = [(elem[0],) for elem in cur.description]

    create_list_box(rows, "Задание 4", 17)


def execute_task1(cur, age):
    try:
        age = int(age.get())
    except:
        mb.showerror(title="Ошибка", message="Введите число!")
        return

    cur.execute(f" \
        SELECT count(age) \
        FROM users \
        WHERE age={age} \
        GROUP BY age")

    row = cur.fetchone()

    mb.showinfo(title="Результат",
                message=f"Кол-во игроков в возрасте {age} составляет: {row[0]}")


def task1(cur):
    root_1 = Tk()

    root_1.title('Задание 1')
    root_1.geometry("300x200")
    root_1.configure(bg="lavender")
    root_1.resizable(width=False, height=False)

    Label(root_1, text="  Введите возраст:", bg="lavender").place(
        x=75, y=50)
    age = Entry(root_1)
    age.place(x=75, y=85, width=150)

    b = Button(root_1, text="Выполнить",
               command=lambda arg1=cur, arg2=age: execute_task1(arg1, arg2),  bg="thistle3")
    b.place(x=75, y=120, width=150)

    root_1.mainloop()


def task2(cur):
    # Статистика по компаниям.
    # Сколько человек используют
    # шлем той или иной компании.
    cur.execute(" \
    SELECT company, COUNT(company) \
    FROM users \
    JOIN device \
    ON users.id_device = device.id \
    GROUP BY company;")

    rows = cur.fetchall()

    create_list_box(rows, "Задание 2")


def task3(cur):
    print("Task3")


def task4(cur):

    root_1 = Tk()

    root_1.title('Задание 4')
    root_1.geometry("300x200")
    root_1.configure(bg="lavender")
    root_1.resizable(width=False, height=False)

    Label(root_1, text="Введите название таблицы:", bg="lavender").place(
        x=65, y=50)
    name = Entry(root_1)
    name.place(x=75, y=85, width=150)

    b = Button(root_1, text="Выполнить",
               command=lambda arg1=cur, arg2=name: execute_task4(arg1, arg2),  bg="thistle3")
    b.place(x=75, y=120, width=150)

    root_1.mainloop()

    # cur.execute("SELECT * FROM cities")

    # rows = cur.fetchall()

    # desc = cur.description


def task5(cur):
    cur.execute("SELECT get_max_number_of_hours() AS max_hours;")

    row = cur.fetchone()

    mb.showinfo(title="Результат",
                message=f"Максимальное кол-во часов составляет: {row[0]}")


def task6(cur):
    print("Task6")


def task7(cur):
    print("Task7")


def task8(cur):
    print("Task8")


def task9(cur):
    print("Task9")


def task10(cur):
    print("Task10")
