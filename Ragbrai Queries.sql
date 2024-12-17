USE Ragbrai;

-- Query 1: What is the second town that riders visited last year?
SELECT TownName
FROM HostTowns
JOIN EventHostTowns ON HostTowns.TownID = EventHostTowns.TownID
JOIN Events ON EventHostTowns.EventID = Events.EventID
WHERE Events.EventYear = 2023
ORDER BY EventHostTowns.StartDate
LIMIT 1 OFFSET 1;

-- Query 2: How many riders were on "Team Tina" last year and who was the team captain?
SELECT Teams.TeamName, (SELECT Riders.Name
        FROM Riders
        WHERE Riders.RiderID = Teams.CaptainID) AS CaptainName,
       (SELECT COUNT(*)
        FROM Riders
        WHERE Riders.TeamID = Teams.TeamID) AS RiderCount
FROM Teams
JOIN Events ON Teams.EventID = Events.EventID
WHERE Teams.TeamName = 'Team Tina' 
  AND Events.EventYear = 2023
GROUP BY Teams.TeamID;

-- Query 3: In what years has 'Team Corn Huskers' participated?
SELECT Events.Eventyear AS Year, Teams.TeamName
FROM Events
JOIN Teams ON Events.EventID = Teams.EventID
WHERE Teams.TeamName = 'Team Corn Huskers';

-- Query 4: How many years has Ragbrai travelled through Ford Dodge, Iowa?
SELECT Events.EventYear AS Year, HostTowns.TownName
FROM Events
JOIN EventHostTowns ON Events.EventID = EventHostTowns.EventID
JOIN HostTowns ON EventHostTowns.TownID  = HostTowns.TownID
WHERE HostTowns.TownName = 'Ford Dodge, Iowa';

-- Query 5: How many riders purchased a vehicle pass this year?
SELECT Events.EventYear AS Year, COUNT(Riders.RiderID) AS Riders, Riders.HasVehiclePass AS VehiclePass
FROM Riders
JOIN Teams ON Riders.TeamID = Teams.TeamID
JOIN Events ON Teams.EventID = Events.EventID
WHERE HasVehiclePass = True
	AND Events.EventYear = 2024;
    
-- SP1: For the first stored procedure, input a year (X) and a number of years (Y) to determine riders that participated for the Yth time on X year.
-- For example, which riders participated for the 10th time in 2024.
DELIMITER $$
DROP PROCEDURE IF EXISTS SP1_DetermineNthParticipation;
CREATE PROCEDURE SP1_DetermineNthParticipation(IN yearX INT, IN numY INT)
BEGIN
    SELECT Riders.Name, COUNT(*) AS ParticipationCount
    FROM Riders
    JOIN Teams ON Riders.TeamID = Teams.TeamID
    JOIN Events ON Teams.EventID = Events.EventID
    WHERE Events.EventYear <= yearX
    GROUP BY Riders.Name
    HAVING ParticipationCount = numY;
END $$

DELIMITER ;

-- SP1 Q1 ANSWER: Chris Johnson, Katie Lee, Jim Halpert, Oscar Martinez
CALL SP1_DetermineNthParticipation(2024, 2);
-- SP1 Q2 ANSWER: John Doe, Dwight Schrute
CALL SP1_DetermineNthParticipation(2024, 5);
-- SP1 Q3 ANSWER: Kenton Cooley, George Hunter
CALL SP1_DetermineNthParticipation(2023, 1);

-- SP2: Assume that towns are visited from west to east. For the second procedure, your goal is to be able to use the procedure to output the order
-- that towns will be visited (hint: use their GPS coordinates). You may choose how to achieve this (for example, you may design the procedure to call
-- it once to get information on a given year, or multiple times to get information on each race day).
DELIMITER $$
DROP PROCEDURE IF EXISTS SP2_OrderOfTownsVisited;
CREATE PROCEDURE SP2_OrderOfTownsVisited(IN eventYear INT)
BEGIN
    SELECT HostTowns.TownName, HostTowns.Latitude, HostTowns.Longitude
    FROM HostTowns 
    JOIN EventHostTowns ON HostTowns.TownID = EventHostTowns.TownID
    JOIN Events ON EventHostTowns.EventID = Events.EventID
    WHERE Events.EventYear = eventYear
    ORDER BY HostTowns.Longitude ASC, HostTowns.Latitude ASC;
END $$

DELIMITER ;

-- SP2 Q1 OUTPUT: 
-- (Here we are sorting by longitude primarily and the latitude varies except for when the longitude is identical, it is then sorted)
-- NAME         LATITUDE    LONGITUDE
-- Ames, Iowa	41.885000	-94.100000
-- Ford Dodge, Iowa	42.035000	-93.430000
-- Burlington, Iowa	41.100000	-93.000000
-- Mason City, Iowa	42.250000	-93.000000
-- Cedar Rapids, Iowa	41.500000	-92.800000
-- Iowa City, Iowa	41.700000	-92.200000
CALL SP2_OrderOfTownsVisited(2019);

/*
FUTURE PLANS, QUESTION:
Finally, if you were the manager of the development team for this project, describe what your next goals for the project would be.
For example, would you create additional stored procedures? What would they do? Would you add additional data? Etc.
ANSWER: 
I would add a table for Rider-Team assignments, which would allow us to maintain consistent rider and team records across multiple years. 
This would eliminate the need to recreate rider and team registrations each year, reduce redundancy, and simplify updates for changes such
 as vehicle passes and registration types. We would then be able to update the rider details each year for the vehicle pass and type of registration.
For example, how the EventHostTowns table is an intermediary between the Events and HostTowns tables. I would also implement data validation for 
important attributes like names and HostTowns to not have any letters and ensure phone numbers and other variables have the correct amount of numbers.

I would add more information to the riders, teams, hostTowns, and events tables. For example, I would add date of birth, gender as an enum
('Male', 'Female', 'Non-binary', 'Prefer not to say'), medical conditions, primary phone number, secondary phone number, email, first name,
last name, emergency conatact (with the information listed already), registration date, and a boolean for eligible to compete based on age,
payment, and other factors. For teams I would add attributes for team color, team motto, registration date, number of members, team phone
contact, team email contact, achievements, and boolean if the team is eligible to compete if they have the right amount of eligible members.
For HostTowns it might be a good idea to add population, state, country, description, accomodations available, historical significance, contact
person name, contact phone, and contact email. For Events it might be a good idea to add number of participants, total distance, event 
coordinator (name, phone, email), weather conditions expected, event theme, sponsorship details, incidents reported, time for each team for
each leg of the race, total time for each team, and each team name and rider name linked to the place they got in the race.

I really like the SP that automatically calculates the best order of the cities for the race based on location. This makes the planning much simpler.
For additional stored procedures I would add one that could list a specified rider's name, age, description, and accomplishments. This could be
used by the announcer to announce the racers during the broadcast. One SP could calculate the total distance of the race based on the gps 
coordinates. This is useful to know if the race is the correct distance. One SP could generate a report for the event as a whole to display total
riders, vehicle passes sold, how many of each registration type was sold, average rider age, and average completion time. This is used for analysis
of the race and to rate success of the event. One SP could list the top three finishing team names, team member names, team accomplishments,
team completion time, and team motto. I would also add an SP that could pull up the emergency contact details for a given rider. This information
is very important to notify family/friends as soon as possible.
*/