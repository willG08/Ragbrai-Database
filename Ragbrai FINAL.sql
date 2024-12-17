-- Create the database if it doesn't exist
DROP DATABASE IF EXISTS Ragbrai;
CREATE DATABASE Ragbrai;
USE Ragbrai;

DROP TABLE IF EXISTS Events;
-- Table to store information about the events
CREATE TABLE Events (
    EventID INT AUTO_INCREMENT PRIMARY KEY,
    EventYear INT NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL
);

DROP TABLE IF EXISTS HostTowns;
-- Table to store host towns and their GPS coordinates
CREATE TABLE HostTowns (
    TownID INT AUTO_INCREMENT PRIMARY KEY,
    TownName VARCHAR(100) NOT NULL,
    Latitude DECIMAL(9, 6) NOT NULL,
    Longitude DECIMAL(9, 6) NOT NULL
);

DROP TABLE IF EXISTS EventHostTowns;
-- Table to join events to their host towns
CREATE TABLE EventHostTowns (
    EventHostTownID INT AUTO_INCREMENT PRIMARY KEY,
    EventID INT NOT NULL,
    TownID INT NOT NULL,
	StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    FOREIGN KEY (EventID) REFERENCES Events(EventID),
    FOREIGN KEY (TownID) REFERENCES HostTowns(TownID)
);
DROP TABLE IF EXISTS Riders;
-- Table to store rider information, each rider can only compete with one team but the team may not be setup at the time of rider registration
CREATE TABLE Riders (
    RiderID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    HasVehiclePass BOOLEAN NOT NULL,
    RegistrationType ENUM('Weeklong Rider', 'Weeklong Non-Rider', 'Day Pass') NOT NULL,
    TeamID INT 
);

DROP TABLE IF EXISTS Teams;
-- Table to store teams and captain may be decided later
CREATE TABLE Teams (
    TeamID INT AUTO_INCREMENT PRIMARY KEY,
    EventID INT NOT NULL,
    TeamName VARCHAR(100) NOT NULL,
    CaptainID INT
);



-- Insert sample data for the tables
INSERT INTO Events (EventYear, StartDate, EndDate) VALUES
(2019, '2019-07-14', '2019-07-20'),
(2020, '2020-07-19', '2020-07-25'),
(2021, '2021-07-11', '2021-07-17'),
(2022, '2022-07-10', '2022-07-16'),
(2023, '2023-07-23', '2023-07-29'),
(2024, '2024-07-14', '2024-07-20'),
(2025, '2025-07-20', '2025-07-26');

-- Keep in mind these are real towns in Iowa but the order of the towns and coordinates are just for sample data.
INSERT INTO HostTowns (TownName, Latitude, Longitude) VALUES
('Sioux, Iowa', 41.6070, -93.1200),
('Ford Dodge, Iowa', 42.0350, -93.4300),
('Ames, Iowa', 41.8850, -94.1000),
('Cedar Rapids, Iowa', 41.5000, -92.8000),
('Mason City, Iowa', 42.2500, -93.0000),
('Iowa City, Iowa', 41.7000, -92.2000),
('Burlington, Iowa', 41.1000, -93.0000);

INSERT INTO EventHostTowns (EventID, TownID, StartDate, EndDate) VALUES
-- Event 1 (6)
(1, 3, '2019-07-14', '2019-07-15'),
(1, 2, '2019-07-15', '2019-07-16'),
(1, 7, '2019-07-16', '2019-07-17'),
(1, 5, '2019-07-17', '2019-07-18'),
(1, 4, '2019-07-18', '2019-07-19'),
(1, 6, '2019-07-19', '2019-07-20'),

-- Event 2 (3)
(2, 1, '2020-07-19', '2020-07-20'),
(2, 2, '2020-07-21', '2020-07-22'),
(2, 3, '2020-07-23', '2020-07-24'),

-- Event 3 (3)
(3, 2, '2021-07-11', '2021-07-12'),
(3, 3, '2021-07-13', '2021-07-14'),
(3, 4, '2021-07-15', '2021-07-16'),

-- Event 4 (2)
(4, 3, '2022-07-10', '2022-07-11'),
(4, 4, '2022-07-12', '2022-07-13'),

-- Event 5 (3)
(5, 5, '2023-07-23', '2023-07-24'),
(5, 6, '2023-07-25', '2023-07-26'),
(5, 7, '2023-07-26', '2023-07-27'),

-- Event 6 (2)
(6, 1, '2024-07-14', '2024-07-15'),
(6, 2, '2024-07-16', '2024-07-17'),

-- Event 7 (1)
(7, 1, '2025-07-20', '2025-07-21');

-- Each year we need a different registration because team name, team members, eventID, and captainID may change.
INSERT INTO Teams (EventID, TeamName, CaptainID) VALUES
-- 2019 (2)
(1, 'Cycling Kings', 1),
(1, 'Bike Warriors', 4),

-- 2020 (3)
(2, 'Pedal Power', 7),
(2, 'Speedsters', 10),
(2, 'Team Corn Huskers', 13),

-- 2021 (4)
(3, 'Cycling Kings', 14),
(3, 'Bike Soldiers', 17),
(3, 'Pedal Pride', 20),
(3, 'Team Corn Huskers', 23),

-- 2022 (2)
(4, 'Cycling Kings', 24),
(4, 'Bike Warriors', 27),

-- 2023 (4)
(5, 'Pedal Power', 30),
(5, 'Speedsters', 33),
(5, 'Team Tina', 36),
(5, 'Team Corn Huskers', 38),

-- 2024 (2)
(6, 'Bike Warriors', 39),
(6, 'Speedy Gonzalez', 42),
 
 -- 2025 (1)
(7, 'Cycling Kings', 43);


-- We require a new requistration each year because the address, hasVehiclePass, RegistrationType, and TeamID sections may vary year to year.TeamID has to change.
INSERT INTO Riders (Name, Address, HasVehiclePass, RegistrationType, TeamID) VALUES
-- Event 1 2019 (6)
('John Doe', '123 Elm St', TRUE, 'Weeklong Rider', 1),
('Sarah Connor', '202 Birch St', TRUE, 'Weeklong Rider', 1),
('Dwight Schrute', '606 Birch St', TRUE, 'Weeklong Non-Rider', 1),
('Jane Smith', '456 Oak St', FALSE, 'Weeklong Rider', 2),
('Michael Scott', '303 Cedar St', FALSE, 'Weeklong Rider', 2),
('Pam Beesly', '707 Pine St', FALSE, 'Weeklong Rider', 2),

-- Event 1 2020 (7)
('Chris Johnson', '789 Pine St', TRUE, 'Day Pass', 3),
('Ryan Howard', '404 Willow St', TRUE, 'Day Pass', 3),
('Angela Martin', '808 Oak St', TRUE, 'Day Pass', 3),
('Katie Lee', '101 Maple St', FALSE, 'Weeklong Rider', 4),
('Jim Halpert', '505 Ash St', FALSE, 'Weeklong Rider', 4),
('Oscar Martinez', '909 Cedar St', FALSE, 'Weeklong Non-Rider', 4),
('Hill Billy Joe', '101 Farm St', TRUE, 'Weeklong Rider', 5),

-- Event 2  2021 (10)
('Jane Smith', '456 Oak St', FALSE, 'Weeklong Rider', 6),
('Michael Scott', '303 Cedar St', FALSE, 'Weeklong Rider', 6),
('Pam Beesly', '707 Pine St', FALSE, 'Weeklong Rider', 6),
('Chris Johnson', '789 Pine St', TRUE, 'Day Pass', 7),
('Ryan Howard', '404 Willow St', TRUE, 'Day Pass', 7),
('Angela Martin', '808 Oak St', TRUE, 'Day Pass', 7),
('John Doe', '123 Elm St', TRUE, 'Weeklong Rider', 8),
('Sarah Connor', '202 Birch St', TRUE, 'Weeklong Rider', 8),
('Dwight Schrute', '606 Birch St', TRUE, 'Weeklong Rider', 8),
('Hill Billy Joe', '101 Farm St', TRUE, 'Weeklong Rider', 9),

-- Event 3  2022 (6)
('Katie Lee', '101 Maple St', FALSE, 'Weeklong Non-Rider', 10),
('Jim Halpert', '505 Ash St', FALSE, 'Weeklong Non-Rider', 10),
('Oscar Martinez', '909 Cedar St', FALSE, 'Weeklong Non-Rider', 10),
('John Doe', '123 Elm St', TRUE, 'Weeklong Rider', 11),
('Sarah Connor', '202 Birch St', TRUE, 'Weeklong Rider', 11),
('Dwight Schrute', '606 Birch St', TRUE, 'Weeklong Non-Rider', 11),
 
-- Event 4  2023 (9)
('John Doe', '123 Elm St', TRUE, 'Weeklong Rider', 12),
('Sarah Connor', '202 Birch St', TRUE, 'Weeklong Rider', 12),
('Dwight Schrute', '606 Birch St', TRUE, 'Weeklong Rider', 12),
('Jane Smith', '456 Oak St', FALSE, 'Weeklong Rider', 13),
('Michael Scott', '303 Cedar St', FALSE, 'Weeklong Rider', 13),
('Pam Beesly', '707 Pine St', FALSE, 'Weeklong Rider', 13),
('Kenton Cooley', '672 Main St', TRUE, 'Day Pass', 14),
('George Hunter', '404 Jefferson St', TRUE, 'Weeklong Rider', 14),
('Hill Billy Joe', '101 Farm St', TRUE, 'Weeklong Rider', 15),

-- Event 5  2024 (4)
('Ryan Howard', '404 Willow St', TRUE, 'Day Pass', 16),
('Angela Martin', '808 Oak St', TRUE, 'Day Pass', 17),
('John Doe', '123 Elm St', TRUE, 'Weeklong Rider', 17),
('Dwight Schrute', '606 Birch St', TRUE, 'Weeklong Rider', 17),

-- Event 6  2025 (1)
('Dwight Schrute', '606 Birch St', TRUE, 'Weeklong Rider', 18);

ALTER TABLE Riders
ADD FOREIGN KEY (TeamID) REFERENCES Teams(TeamID);
 
ALTER TABLE TEAMS
ADD FOREIGN KEY (EventID) REFERENCES Events(EventID),
ADD FOREIGN KEY (CaptainID) REFERENCES Riders(RiderID);