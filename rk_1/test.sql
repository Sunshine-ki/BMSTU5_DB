CREATE TABLE IF NOT EXISTS Tourists
(
	id INT NOT NULL PRIMARY KEY,
	FirstName VARCHAR(16),
	LastName VARCHAR(16),
	CityID INT,
	Age INT
);

CREATE TABLE IF NOT EXISTS Sights
(
	id INT NOT NULL PRIMARY KEY,
	Name VARCHAR(16),
	CityID INT,
	Description VARCHAR(16)
);

-- ST(SightID:int, TouristID:int, Date:date)
CREATE TABLE IF NOT EXISTS ST
(
	SightID INT,
    FOREIGN KEY (SightID) REFERENCES Sights(id),

	TouristID INT,
    FOREIGN KEY (TouristID) REFERENCES Tourists(id)
);

INSERT INTO ST(SightID, TouristID)
VALUES (3,1);


-- INSERT INTO Tourists(id, FirstName, LastName, CityID, Age)
-- VALUES(3, 'Pasha', 'Perestoronin', 1, 20);

-- select * from Tourists;

INSERT INTO Sights(id, Name, CityID, Description)
VALUES(3, 'C', 1, '11.11');

SELECT *
FROM Tourists
JOIN ST ON Tourists.id = ST.TouristID;
