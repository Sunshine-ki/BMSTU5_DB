# https://nifi.apache.org/docs/nifi-docs/html/getting-started.html
# http://localhost:8080/nifi


from faker import Faker
from random import randint, choice
import datetime
import time
import json


class device():
	# Структура полностью соответствует таблице device.
	id = int()
	company = str()
	year_of_issue = int()
	color = str()
	price = int()

	def __init__(self, id, company, year_of_issue, color, price):
		self.id = id
		self.company = company
		self.year_of_issue = year_of_issue
		self.color = color
		self.price = price

	def get(self):
		return {'id': self.id, 'company': self.company, 'year_of_issue': self.year_of_issue,
				'color': self.color, 'price': self.price}

	def __str__(self):
		return f"{self.id:<2} {self.company:<20} {self.year_of_issue:<5} {self.color:<5} {self.price:<15}"



def main():
	faker = Faker()  # faker.name()
	color = ["blue", "red", "purple", "yellow",
			"pink", "green", "black", "white", "coral", "gold", "silver"]
	i = 0


	while True:
		obj = device(i, faker.name(), randint(2000, 2120), choice(color), randint(0, 100000))
		
		# print(obj)
		# print(json.dumps(obj.get()))
		
		file_name = "data/device_" + str(i) + "_" + \
			str(datetime.datetime.now().strftime("%d-%m-%Y_%H:%M:%S")) + ".json"

		print(file_name)
		
		with open(file_name, "w") as f:
			print(json.dumps(obj.get()), file=f)

		i += 1
		time.sleep(10)


if __name__ == "__main__":
	main()
