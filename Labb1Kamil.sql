--MoonMission
SELECT Spacecraft, [Launch date], [Carrier rocket], Operator, [Mission type]
INTO SuccessfulMissions
FROM MoonMissions
WHERE Outcome = 'Successful';

GO

UPDATE SuccessfulMissions
SET Operator = LTRIM(Operator);

GO

UPDATE SuccessfulMissions
SET Spacecraft = RTRIM(SUBSTRING(Spacecraft, 1, CHARINDEX('(', Spacecraft) - 2))
WHERE CHARINDEX('(', Spacecraft) > 0;

GO

SELECT Operator, [Mission type], COUNT(*) AS 'Mission count'
FROM SuccessfulMissions
GROUP BY Operator, [Mission type]
HAVING COUNT(*) > 1
ORDER BY 'Mission count' DESC;

GO

--Users
SELECT	ID, UserName, [Password], CONCAT(FirstName, ' ', LastName) AS [Name],
		CASE
			WHEN SUBSTRING(ID, LEN(ID) - 1, 1) % 2 = 0 THEN 'Female'
			ELSE 'Male'
		END AS Gender,
		Email, Phone
INTO NewUsers
FROM Users;

GO

SELECT UserName, COUNT(*) AS Frequency
FROM NewUsers
GROUP BY UserName
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC;

GO

SELECT a.*
INTO Temp
FROM NewUsers a
	JOIN
		(SELECT UserName, COUNT(*) AS Frequency
		FROM NewUsers
		GROUP BY UserName
		HAVING COUNT(*) > 1) b
			ON a.UserName = b.UserName;

UPDATE Temp
SET UserName = SUBSTRING(Temp.ID, 1, 6)

UPDATE NewUsers
SET NewUsers.UserName = Temp.UserName
FROM NewUsers
	JOIN Temp
		ON NewUsers.ID = Temp.ID

DROP TABLE Temp;

GO

DELETE FROM NewUsers
WHERE CAST(SUBSTRING(ID, 1, 2) AS INT) < 70
AND Gender = 'Female';

GO

INSERT INTO NewUsers
VALUES	('990927-4951', 'johfre', 'f6bb74951e31g5h81w2x311k24a363r5',
		'Johan Fredrikssons', 'Male', 'johan.fredrikssons@gmail.com','070-3253672');

GO

SELECT	gender, 
		AVG(FLOOR(DATEDIFF(DAY, CAST('19' + 
			SUBSTRING(ID, 1, 2 ) +
			SUBSTRING(ID, 3, 2 ) +
			SUBSTRING(ID, 5, 2 ) AS DATETIME),
			GETDATE()) / 365.25)) AS [average age]
FROM NewUsers
GROUP BY gender;