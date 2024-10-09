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
-- WHERE year IN ('200', '2001', '2002', '2003', '2004', '2005', '2006', '2007', '2008', '2009', '2010') or (length >= 60 and length <= 120);
-- BETWEEN is an alternative operator to condier an interval of values 
-- WHERE year between '2000' and '2010' or length between 60 and 120;

select id, official_title, year, length
from imdb.movie
where year between '2000' and '2010' or length between 60 and 120;
