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
    window(cur, con)

    # Закрываем соединение с БД.
    cur.close()
    con.close()


if __name__ == "__main__":
    main()
