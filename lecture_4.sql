-- for each movie, count the involved persons by role
-- sort result by movie
select count(distinct person), movie, p_role, official_title
from imdb.crew inner join imdb.movie on crew.movie = movie.id
group by movie, p_role, official_title
order by 2;

-- for each genre, count the number of movies
select count(movie), genre
from imdb.genre
group by genre;


-- return the countries where more than 10 movies are produced
-- so for each country count the number of movies and retunr the ones having more than 10
select country, count(movie)
from imdb.produced
group by country
having count(movie) > 10;


-- return the countries where more than 10 horror movies are produced
select country, count(produced.movie)
from imdb.produced inner join imdb.genre on produced.movie = genre.movie
where genre.genre = 'Horror'
group by country
having count(produced) > 10;


-- return the number of persons born in each country
-- insert a country in the result also when zero persons are born there
-- we need an external join to include spurious countries (countries without born persons)
-- the condition on d_role = 'B' must be contextual to the join (so in from clause),
-- otherwise the effect of external join is canceled and spurious records are eliminated from the result (and countries without born persons are excluded)
select iso3, name, count(*), count(person)
from imdb.country left join imdb.location on (country.iso3 = location.country and d_role = 'B')
group by country.iso3, name;


-- return the countries where no person is born (preliminary to solve the preious query)
-- return the countries in the country table that are not belonging to the set of countries in the location table with d_role = 'B'
select country.iso3
from imdb.country
EXCEPT
select location.country
from imdb.location
where d_role = 'B';


select country.iso3
from imdb.country left join imdb.location on (country.iso3 = location.country and location.d_role = 'B')
where location.d_role is null;

-- for each person, count the number of actor presences into movies
select id, given_name, count(crew.person)
from imdb.crew inner join imdb.person on crew.person = person.id
where p_role = 'actor'
group by id, given_name;


select id, given_name, count(crew.person)
from imdb.person left join imdb.crew on person.id = crew.person and p_role = 'actor'
group by id, given_name;

-- The first query will only count actors, returning no results for non-actors. 
-- The second query returns all persons, with 0 for those who have no actor entries.



-- alternative
-- cte (common table expression)
-- cte are useful to decompose a complex query in to steps
-- https://www.postgresql.org/docs/current/queries-with.html
-- solve first this problem: find the link between persons and movies
-- then, count the records for each person
with actors as (
select *
from imdb.crew
where p_role = 'actor')
select person.id, given_name, count(actors.person)
from imdb.person left join actors on person.id = actors.person
group by person.id, given_name;


-- find the horror movies that are distributed in Italy and count the number of actors for each of them
-- first, find horror movies
-- then find those distributed in italy
-- then count the actors
select movie.id, official_title, count(crew.person)
from imdb.movie inner join imdb.genre on movie.id = genre.movie 
    inner join imdb.released on released.movie = movie.id 
    inner join imdb.crew on crew.movie = movie.id
where lower(genre.genre) = 'horror' and released.country = 'ITA' and crew.p_role = 'actor'
group by movie.id;


with horror_movies as (
    select *
    from imdb.genre
    where genre = 'Horror'
), horror_italy_movies as (
select released.movie
from imdb.released inner join horror_movies ON released.movie = horror_movies.movie
where country = 'ITA'
)
select crew.movie, count(*)
from imdb.crew inner join horror_italy_movies on crew.movie = horror_italy_movies.movie
where p_role = 'actor'
group by crew.movie;



-- find the movie with the highest number of actors
-- first: find the number of actors for each movie
-- then, find the max value on the counters
-- finally, return the movie that has the max value

select count(person), movie
from imdb.crew
where p_role = 'actor'
group by movie
order by 1 DESC
limit 1;


with movie_counts as (
    select movie, count(*) as m_count
    from imdb.crew
    where p_role = 'actor'
    group by movie
), top_count as (
    select max(m_count) as m_top
    from movie_counts
)
select movie_counts.*
from movie_counts inner join top_count on m_count = m_top;



-- alternative solution without cte
select movie, count(*) as m_count
from imdb.crew
where p_role = 'actor'
group by movie
having count(*) >= all (
    select count(*) 
    from imdb.crew
    where p_role = 'actor'
    group by movie
);