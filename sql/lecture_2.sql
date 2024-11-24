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

-- join operation
-- allow to link records in different tables
-- get the title of movies produced in 90' (1990-1999) that are Thrillers

select *
from imdb.movie, imdb.genre
where movie.id = genre.movie and movie.year between '1990' and '1999' and lower(genre.genre) = 'thriller';

-- alternative syntax
select *
from imdb.movie inner join imdb.genre on movie.id = genre.movie
where movie.year between '1990' and '1999' and lower(genre.genre) = 'thriller';

-- get the title of movies that are thrillers
select *
from imdb.movie inner join imdb.genre on movie.id = genre.movie
where lower(genre.genre) = 'thriller';

-- inner join means that movies (e.g., 0076737) that have no links in table genre are excluded from the result of the join
select *
from imdb.movie inner join imdb.genre on movie.id = genre.movie;


-- get the title of movies with score grater than 8 on a scale of 10
-- DISTINCT eliminates duplicate results from the query
-- select id, official_title, score / scale as "scaled score"
select id, official_title, score/scale as "scaled score"
from imdb.movie, imdb.rating
where movie.id = rating.movie and score > 8 and scale = 10
order by 2 desc;


-- insert one more rating for the movie 0468569
insert into imdb.rating(check_date, source, movie, scale, votes, score) values ('2024-10-02', 'SM', '0468569', 10, 1, 8.4);

-- get only id and official title of movies with rating over 8 on 10
-- use distinct to remove possible duplications
select distinct id, official_title, score, scale, score/scale as "scaled score"
from imdb.movie inner join imdb.rating on movie.id = rating.movie
where score > 8 and scale = 10
order by 3 desc;

-- get the movie title and the name of actors and characters involved in movies of 2010 or 2011
-- report only actors where the name of the character is specified (not null)

-- primary key of crew: movie, person, p_role
-- is distinct needed? is it possible to have duplicates in the result of this query? no

select official_title, person, "character", p_role, year, given_name
from imdb.movie inner join imdb.crew on movie.id = crew.movie inner join imdb.person on crew.person = person.id
where year between '2010' and '2011' and character is not null and p_role = 'actor';


select distinct movie.id as movie_id, official_title, person.id as person_id, given_name, "character"
from imdb.crew inner join imdb.movie on movie.id = movie inner join imdb.person on crew.person = person.id
where year between '2010' and '2011' and p_role = 'actor' and character is not null;


-- get the countries and the official title of movies where thriller movies are produced
select official_title, country
from imdb.movie inner join imdb.produced on movie.id = produced.movie inner join imdb.genre on movie.id = genre.movie
where lower(genre) = 'thriller';


-- get the countries where thriller movies are produced
select distinct country
from imdb.produced inner join imdb.genre on produced.movie = genre.movie
where genre = 'Thriller';

-- get the code of movies that are produced in USA and FRA: both countries
-- the query asks for two records of produced: one record about fra, another record about usa, and both about the same movie
-- this is not a correct solution: always empty result
select *
from imdb.produced
where country = 'USA' and country = 'FRA';

-- this is not a correct solution: a movie produced only in fra or in usa is returned in the result
select *
from imdb.produced
where country = 'USA' or country = 'FRA';

-- this is equivalent to the previous one: not a correct solution
select *
from imdb.produced
where country in( 'USA', 'FRA');


-- get the code of movies that are produced in USA and FRA: both countries
-- the query asks for two records of produced: one record about fra, another record about usa, and both about the same movie
-- this is a correct solution
select *
from imdb.produced p_usa inner join imdb.produced p_fra on p_usa.movie = p_fra.movie
where p_usa.country = 'USA' and p_fra.country = 'FRA';


select official_title, p_ita.country, p_usa.country
from imdb.produced p_usa inner join imdb.produced p_ita on p_usa.movie = p_ita.movie inner join imdb.movie on movie.id = p_ita.movie
where p_usa.country = 'USA' and p_ita.country = 'ITA';
