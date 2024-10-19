-- Active: 1727863777244@@127.0.0.1@5432@imdb@imdb

-- retrive the full content of the movie table
select *
from imdb.movie;

-- retrieve the movies that are produced in '2010'
-- show id, official_title and length in the query result
select id, official_title, length
from imdb.movie
where year = '2010';

-- retrieve the movies of 2010 with duration grater than one hour
select id, official_title, length
from imdb.movie
where year = '2010' and length > 60; 

-- supported logical operators are: AND, OR, NOT
-- A AND B means that both A, B must be true
-- A OR B means that at least A or B must be true
-- NOT A means that the negation of A must be true

-- get the movies where the year is between 2000 and 2010 or the duration is between 60 and 120 minutes
-- use brackets to specify the precedence of evaluation among and/or operators
select id, official_title, length, year
FROM imdb.movie
WHERE (year >= '2000' and year <= '2010') or (length >= 60 and length <= 120);

-- the IN operator can be used to enumerate the list of values to consider
-- IN returns true if the attribute value is equal to one of the value in the list
-- WHERE year IN ('2000', '2001', '2002', '2003', '2004', '2005', '2006', '2007', '2008', '2009', '2010') or (length >= 60 and length <= 120);
-- BETWEEN is an alternative operator to condier an interval of values 
-- WHERE year between '2000' and '2010' or length between 60 and 120;

select id, official_title, year, length
from imdb.movie
where year between '2000' and '2010' or length between 60 and 120;

-- get the movies with title 'the man who knew too much'
select *
from imdb.movie
where lower(official_title) = 'the man who knew too much';

-- with lower we can reduce the string to a lowercase
-- upper function is available for the opposite

-- retrieve the movies about murder
-- LIKE operator
-- wildcards of like:
-- %: this wildcard represents any string of any length
-- _: this wildcard represents a string of exactly one character

select *
from imdb.movie
where lower(official_title) like '%murder%';

-- get the movies that are not produced in 2010

select *
from imdb.movie
where year <> '2010';

-- get the movies where the length or the year are specified (not null)

-- what happens to a movie without values on year with this query?
-- null is not a values and it is not considered in any comparison

select *
from imdb.movie
where year is null;

-- get the movies with values on year
select *
from imdb.movie
where year is not null;

-- consider this operation
insert into imdb.movie(id, official_title, year, length) values ('383838', '', '2010', 67);
insert into imdb.movie(id, official_title, year, length) values ('438474', '', '2010', 67);
-- possible errors:
-- id duplication

-- get the movies with empty/blank values in title
-- TRIM drops heading and trailing blanks in a string

select *
from imdb.movie
where trim(official_title) = '';

-- in this case TRIM removes the space chatacter or other specified characters from the start or end of a string

--get the people that are alive
select given_name
from imdb.person
where death_date is null;

select id as "id code", given_name as "person name", birth_date "date of birth"
from imdb.person
where "death_date" is null;

-- get the name of persons with birth_date after 1970 and sort the result by birth_date (ascending order) and given_name (descending order) where birth_date is the same
select given_name as "person name", birth_date as "date of birth"
from imdb.person
where birth_date >= '1971-01-01'
order by 2, 1 desc;

-- alternative syntax:
-- order by birth_date ASC, given_name DESC