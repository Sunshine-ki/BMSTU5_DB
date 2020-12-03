from tasks import *

from tkinter import *

root = Tk()


def info_show():
    global root
    info = Toplevel(root)
    info_txt = "Условия задачи: \n\
    1. Выполнить скалярный запрос;\n \
    2. Выполнить запрос с несколькими соединениями(JOIN);\n\
    3.Выполнить запрос с ОТВ(CTE) и оконными функциями;\n\
    4. Выполнить запрос к метаданным;\n\
    5. Вызвать скалярную функцию(написанную в третьей лабораторной работе);\n\
    6. Вызвать многооператорную или табличную функцию(написанную в третьей лабораторной работе);\n\
    7. Вызвать хранимую процедуру(написанную в третьей лабораторной работе); \n\
    8. Вызвать системную функцию или процедуру; \n\
    9. Создать таблицу в базе данных, соответствующую тематике БД; \n\
    10. Выполнить вставку данных в созданную таблицу с использованием инструкции INSERT или COPY."

    label1 = Label(info, text=info_txt, font="Verdana 14", bg="lavender")
    label1.pack()


def window(cur, con):
    global root

    root.title('Лабораторная работа №6')
    root.geometry("1200x800")
    root.configure(bg="lavender")
    root.resizable(width=False, height=False)

    main_menu = Menu(root)
    root.configure(menu=main_menu)

    third_item = Menu(main_menu, tearoff=0)
    main_menu.add_cascade(label="Техническое задание",
                          menu=third_item, font="Verdana 10")

    third_item.add_command(label="Показать тз",
                           command=info_show, font="Verdana 12")

    tasks = [task1, task2, task3, task4, task5,
             task6, task7, task8, task9, task10]

    for (index, i) in enumerate(range(75, 750, 150)):
        button = Button(text="Задание " + str(index + 1), width=35, height=2,
                        command=lambda a=index: tasks[a](cur, con),  bg="thistle3")
        button.place(x=290, y=i)

        button = Button(text="Задание " + str(index + 6), width=35, height=2,
                        command=lambda a=index + 5: tasks[a](cur, con),  bg="thistle3")
        button.place(x=610, y=i)  # anchor="center")


    root.mainloop()
