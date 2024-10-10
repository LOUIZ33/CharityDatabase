CREATE DATABASE Charity;
Use Charity;

CREATE TABLE Donors
(Donors_ID INT NOT NULL PRIMARY KEY,
name VARCHAR(50) NOT NULL,
surname VARCHAR(50),
telephone VARCHAR(11)
);

INSERT INTO Donors
(Donors_ID, name, surname, telephone) 
 VALUES
(1, 'Izzie', 'Steven', '07177767601'),
(2, 'Cristina', 'Yang', '07277767602'),
(3, 'Owen', 'Hunt', '07377767603'),
(4, 'Alex', 'Karev', '07477767604'),
(5, 'Derek', 'Shepard', '07577767605'),
(6, 'Miranda', 'Bailey', '07677767606'),
(7, 'Meredith', 'Grey', '07777767607'),
(8, 'Richard', 'Webber', '07877767608'),
(9, 'George', 'OMallley', '07977767609'),
(10, 'April', 'Kepner', '07107767610'
);

CREATE TABLE Supply_Type
(Supply_Type_ID INT NOT NULL PRIMARY KEY, 
Supply_Type_Name VARCHAR(100) NOT NULL);

INSERT INTO Supply_Type
(Supply_Type_ID, Supply_Type_Name)
VALUES(
1, 'Medical Supplies'),
(2, 'Hygiene Products'),
(3, 'Clothing Donations'),
(4, 'Educational Materials'
);

CREATE TABLE Supply
(Supply_ID INT NOT NULL PRIMARY KEY,
Supply_Type_ID INT NOT NULL ,
Donors_ID INT NOT NULL,
Quantity INT,
Donation_Date DATE,
FOREIGN KEY (Supply_Type_ID)
REFERENCES
Supply_Type (Supply_Type_ID),
FOREIGN KEY (Donors_ID)
REFERENCES
Donors (Donors_ID)
);

INSERT INTO Supply 
(Supply_ID, Supply_Type_ID, Donors_ID, Quantity, Donation_Date)
VALUES
(1, 3, 1, 40, '2023-10-03'),
(2, 4, 6, 80, '2023-10-27'),
(3, 2, 4, 100, '2023-11-14'),
(4, 2, 8, 45, '2023-12-06'),
(5, 1, 2, 120, '2023-12-24'),
(6, 3, 10, 50, '2024-01-14'),
(7, 1, 1, 25, '2024-01-20'),
(8, 1, 7, 60, '2024-01-31'),
(9, 4, 5, 75, '2024-02-08'),
(10, 1, 9, 40, '2024-02-11'),
(11, 2, 6, 85, '2024-02-14'),
(12, 3, 4, 150, '2024-02-19'),
(13, 2, 7, 35, '2024-02-22'),
(14, 4, 9, 60, '2024-02-24'),
(15, 2, 3, 95, '2024-02-28'),
(16, 1, 9, 15, '2024-03-13'),
(17, 2, 2, 30, '2024-03-15'),
(18, 4, 10, 55, '2024-03-16'
);
CREATE TABLE Recipients(
Recipients_ID INT NOT NULL PRIMARY KEY,
Recipients_Name VARCHAR(50) NOT NULL,
Contact_Number VARCHAR(11)  NOT NULL
);

INSERT INTO Recipients (Recipients_ID, Recipients_Name, Contact_Number)
VALUES(
1, 'The Children', '07256678991'),
(2, 'Homeless Shelter', '07456678992'),
(3, 'Helping Hands Club', '07656678993'
);

CREATE TABLE Distribution (
Distribution_ID INT NOT NULL PRIMARY KEY,
Supply_ID INT NOT NULL,
Recipients_ID INT NOT NULL,
Distribution_Date DATE NOT NULL,
FOREIGN KEY (Supply_ID)
REFERENCES
Supply (Supply_ID),
FOREIGN KEY (Recipients_ID)
REFERENCES
Recipients (Recipients_ID)
);

INSERT INTO Distribution (Distribution_ID, Supply_ID, Recipients_ID, Distribution_Date)
VALUES (
1, 5, 3, '2024-03-17'),
(2, 9, 2, '2024-03-18'),
(3, 12, 1, '2024-03-19'),
(4, 14, 2, '2024-03-20'),
(5, 2, 2, '2024-03-20'),
(6, 18, 1, '2024-3-20'),
(7, 4, 3, '2024-03-21'),
(8, 11, 2, '2024-03-20'),
(9, 16, 3, '2024-04-01'),
(10, 8, 3, '2024-04-05'),
(11, 1, 1, '2024-04-05'),
(12, 13, 1, '2024-04-06'),
(13, 10, 2, '2024-04-06'),
(14, 17, 3, '2024-04-13'),
(15, 3, 1, '2024-04-13'),
(16, 7, 2, '2024-04-13'),
(17, 15, 2, '2024-04-15'),
(18, 6, 3, '2024-04-17'
);

-- CORE REQUIREMENT: JOINS and CREATE VIEW
-- Shows the total amount of donation from each donor
CREATE VIEW TotalQuantityPerDonor
AS
SELECT DISTINCT CONCAT(d.name, " ", d.surname) AS Donors_Name, SUM(S.Quantity) AS Total_Quantity
FROM Donors D
INNER JOIN Supply S
ON D.Donors_ID = S.Donors_ID
GROUP BY Donors_Name;

SELECT *
From TotalQuantityPerDonor;

-- CORE REQUIREMENT: Stored function used in a query !!!!!!!!!!
-- single donations with over 100 quanitity will be shown appreciation
USE Charity; 

DELIMITER //
CREATE FUNCTION AppreciationSendout (Quantity INT)
RETURNS VARCHAR(5) 
DETERMINISTIC
BEGIN
    DECLARE Appreciation_Status VARCHAR(5);
    IF Quantity > 100 THEN
        SET Appreciation_Status = 'YES';
    ELSEIF Quantity >= 50 AND QuantityP <= 100 THEN
        SET Appreciation_Status = 'MAYBE';
    ELSEIF Quantity < 50 THEN
	 SET Appreciation_Status = 'NO';
    END IF;
    
    RETURN (Appreciation_Status);
END//
DELIMITER ;

SELECT 
Donors_ID,
AppreciationSendout (Quantity) AS Appreciation_Status
FROM Supply;


-- CORE REQUIREMENT: Prepare an example query with a subquery to demonstrate how to extract data from your DB for analysis
-- Shows donations from a specific month and year
SELECT D.name, D.surname,  S.Quantity, S.Donation_Date
FROM Donors D 
JOIN Supply S ON 
D.Donors_ID = S.Donors_ID
WHERE D.Donors_ID IN (
    SELECT S.Donors_ID, S.Donation_Date
    FROM Supply S
    WHERE (YEAR(S.Donation_Date) = 2024 AND MONTH(S.Donation_Date = 2))
    );
    
-- ADVANCED REQUIREMENT: View with 3-4 base tables
-- A more simple table showing each donor donation 
CREATE VIEW DonationDetails AS
SELECT D.name, D.surname, ST.Supply_Type_Name, S.Quantity, S.Donation_Date
FROM Donors D
JOIN Supply S ON D.Donors_ID = S.Donors_ID
JOIN Supply_Type ST ON S.Supply_Type_ID = ST.Supply_Type_ID
ORDER BY S.Donation_Date DESC;

SELECT *
FROM DonationDetails;

-- ADVANCED REQUIREMNTS: Query with GROUP BY and HAVING
-- Shows Donors who have donated a quantity of supply equal to or greater than 75
SELECT D.name, D.surname, S.Quantity, ST.Supply_Type_Name
FROM Donors D
JOIN Supply S 
ON D.Donors_ID = S.Donors_ID
JOIN Supply_Type ST
ON S.Supply_Type_ID = ST.Supply_Type_ID
GROUP BY D.name, D.surname, S.Quantity, ST.Supply_Type_Name
HAVING Quantity >= 75
ORDER BY Quantity ASC;

