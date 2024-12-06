CREATE TABLE airport (
    id char (3) PRIMARY KEY,
    name varchar(50) NOT NULL,
    city char(3) NOT NULL REFERENCES city (code) ON DELETE CASCADE
)

CREATE TABLE city (
    code char(3) PRIMARY KEY,
    name varchar (50) NOT NULL,
    population integer,
    country varchar (50)
)

CREATE TABLE flight (
    departure char(3),
    arrival char(3).
    flight date date,
    departure time time,
    arrival time time,
    delay integer,
    PRIMARY KEY
    (departure, arrival, departure time),
    FOREIGN KEY (departure) REFERENCES
    airport(id) ON UPDATE CASCADE,
    FOREIGN KEY (arrival) REFERENCES
    airport(id) ON UPDATE CASCADE
)


Consider the database airport and choose the "true" statement:
A. UPDATE airport SET id='BGY' WHERE id='001' ; always generates error
B. UPDATE flight SET delay=30 WHERE departure='BGY'; always generates error
C. DELETE FROM city WHERE code='MIL' ; never generates error
D. DELETE FROM airport WHERE id='BGY' ; never generates error
-- all correct answers


Consider the database airport and related constraints (see the SQL above). Choose the "false" statement:
A. A city can have multiple airports
B. Multiple flights can depart from a given airport in a day
C. Two flights cannot have the same departure and the same arrival -- correct
D. flight can depart and arrive in the same airport


-- retrieve the airport name and the city name of cities with more than 1M population. Sort the
-- result by city name and airport name;
select a.name, c.name
from airport.airport a inner join airport.city on a.id = c.code 
where c.population > 1000000
order by 2,1


-- retrieve the airport name where no flights arrived in May 2020;
select a.id, a.name
from airport.airport 
except 
select f.arrival
from airport.flight 
where f.flight_date >= '2020-05-01' and f.flight_date <= '2020-05-31'


select a.name 
from airport.airport a
where a.id not in(
    select f.arrival
    from airport.flight
    where f.flight_date >= '2020-05-01' and f.flight_date <= '2020-05-31'
)

-- retrieve the international flights (namely, the flights with different country of departure and
-- arrival). Return the airport name of departure and arrival of the flight in the result;



-- retrieve the delay of the most delayed flight departed from "Milano Linate" airport;



-- retrieve the airport names where more than 5 delayed flights arrived in May 2020.