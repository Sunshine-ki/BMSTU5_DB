from faker import Faker
from random import randint, choice

MAX = 1000



def GenerateWorld():
    result = open("world.csv", "w")

    nameGames = [line.strip() for line in open("data/name_gamesEN.txt", "r")]
    founder = [line.strip() for line in open("data/founder.txt", "r")]
    genre = [line.strip() for line in open("data/genre.txt", "r")]
    age = [0, 6, 12, 14, 18, 21]

    for i in range(MAX):
        line = "{0},\"{1}\",{2},{3},\"{4}\",{5},{6}\n".format(
            i, nameGames[i], choice(founder), randint(2000, 2120),
            choice(genre), choice(age), randint(0, 100000))
        result.write(line)

    result.close()


def GenerateUser():
    result = open("user.csv", "w")

    nickname = [line.strip() for line in open("data/nickname.txt", "r")]
    sex = ['f', 'm']

    for i in range(MAX):
        line = "{0},{1},{2},{3},{4},{5}\n".format(
            i, nickname[i], randint(0, 100), choice(sex), randint(0, 5000), randint(0, 999))
        result.write(line)

    result.close()


def GenerateDevice():
    result = open("device.csv", "w")
    faker = Faker()  # faker.name()

    company = [line.strip() for line in open("data/company.txt", "r")]
    color = ["blue", "red", "purple", "yellow",
             "pink", "green", "black", "white", "coral", "gold", "silver"]

    for i in range(MAX):
        line = "{0},{1},{2},{3},{4}\n".format(
            i, choice(company), randint(2000, 2120), choice(color), randint(0, 100000))
        result.write(line)

    result.close()


def GenerateWorldUser():
    result = open("device_user.csv", "w")
    for _ in range(MAX):
        result.write("{0},{1}\n".format(randint(0, 999), randint(0, 999)))
    result.close()

def GenerateUserBlackList():
    result = open("black_list.csv", "w")
    for i in range(MAX):
        result.write("{0},{1},{2}\n".format(i, randint(0, 999), randint(0, 999)))
    result.close()



def GenerateDeviceHistory():
    result = open("device_history.csv", "w")
    for _ in range(MAX):
        # year_begin INT CHECK(data_begin >= 2000 and data_begin <= 2120),
        result.write("{0},{1},{2},{3}\n".format(
            randint(0, 999), randint(0, 999),
            randint(2000, 2119),  randint(2000, 2119)))
    result.close()


if __name__ == "__main__":
    # GenerateWorld()
    # GenerateUser()
    # GenerateDevice()
    GenerateUserBlackList()
    # GenerateDeviceHistory()
