class user():
    # Структура полностью соответствует таблице users.
    id = int()
    nickname = str()
    age = int()
    sex = str()
    number_of_hours = int()
    id_device = int()

    def __init__(self, id, nickname, age, sex, number_of_hours, id_device):
        self.id = id
        self.nickname = nickname
        self.age = age
        self.sex = sex
        self.number_of_hours = number_of_hours
        self.id_device = id_device

    def get(self):
        return {'id': self.id, 'nickname': self.nickname, 'age': self.age,
                'sex': self.sex, 'number_of_hours': self.number_of_hours, 'id_device': self.id_device}

    def __str__(self):
        return f"{self.id:<2} {self.nickname:<20} {self.age:<5} {self.sex:<5} {self.number_of_hours:<15} {self.id_device:<15}"



def create_users(file_name):
    # Содает коллекцию объектов.
    # Загружая туда данные из файла file_name.
    file = open(file_name, 'r')
    users = list()

    for line in file:
        arr = line.split(',')
        arr[0], arr[2], arr[4], arr[5] = int(
            arr[0]), int(arr[2]), int(arr[4]), int(arr[5])
        users.append(user(*arr).get())

    return users
