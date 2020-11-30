from tk import *

import psycopg2


def main():
    # Подключаемся к БД.
    try:
        con = psycopg2.connect(
            database="postgres",
            user="lis",
            password="password",
            host="127.0.0.1",  # Адрес сервера базы данных.
            port="5432"		   # Номер порта.
        )
    except:
        print("Ошибка при подключении к БД")
        return

    print("База данных успешно открыта")

    # Объект cursor используется для фактического
    # выполнения наших команд.
    cur = con.cursor()

    # Интерфейс.
    window(cur)

    # Закрываем соединение с БД.
    con.close()


# Выполняем запрос.
# cur.execute('''CREATE TABLE STUDENT
# 	(ADMISSION INT PRIMARY KEY NOT NULL,
# 	NAME TEXT NOT NULL,
# 	AGE INT NOT NULL,
# 	COURSE CHAR(50),
# 	DEPARTMENT CHAR(50));''')

    # # Фиксируем изменения.
    # # Т.е. посылаем команду в бд.
    # # Метод commit() помогает нам применить изменения,
    # # которые мы внесли в базу данных,
    # # и эти изменения не могут быть отменены,
    # # если commit() выполнится успешно.
    # con.commit()
if __name__ == "__main__":
    main()
