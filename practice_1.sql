select official_title as "title"
from imdb.movie
where year = '2012';

select official_title, year, "length"
from imdb.movie 
where year = '2010' and length > 60;

select *
from imdb.movie
where length between 60 and 120 or "length" is null;

select *
from imdb.movie 
where year in ('2010', '2011', '2012');

select official_title as "title", year 
from imdb.movie
where year in ('2010', '2011', '2012')
order by 2, 1 desc;

select official_title
from imdb.movie
where official_title ilike '%murder%';

select official_title
from imdb.movie
where lower(official_title) like '%murder%';

select official_title as "title", year 
from imdb.movie inner join imdb.genre on movie.id = genre.movie
where lower(genre.genre) = 'comedy';


select official_title, rating.score / rating.scale as "rate"
from imdb.movie inner join imdb.rating on movie.id = rating.movie
where rating.score / rating.scale > 0.8
order by 2 desc;


select movie.official_title as "title", crew.p_role, person.given_name
from imdb.movie inner join imdb.crew on movie.id = crew.movie inner join imdb.person on person.id = crew.person
where movie.year = '2010' and lower(crew.p_role) = 'actor';


-- extract the title of movies that have a different title in a released country
select distinct movie.official_title
from imdb.movie inner join imdb.released on movie.id = released.movie
where movie.official_title <> released.title or released.title is null;


-- extract the titles of movies that are similar more than 0.5
select p_1.official_title, p_2.official_title, sim.score
from imdb.movie p_1 inner join imdb.sim on p_1.id = sim.movie1 inner join imdb.movie p_2 on p_2.id = sim.movie2
where sim.score > 0.5 and sim.score <> 1
order by 3 desc;

-- extract all the movies that have never been rated
select movie.id, movie.official_title, rating.*
from imdb.movie left join imdb.rating on movie.id = rating.movie 
where score is null;

-- extract the person that are not involved in crew
select person.id, person.given_name
from imdb.person left join imdb.crew on person.id = crew.person
where crew.person is null;

select person.id, person.given_name
from imdb.crew right join imdb.person on crew.person = person.id
where crew.person is null;

-- extract the movies that are not involved in crew
select movie.id, movie.official_title, crew.movie
from imdb.movie left join imdb.crew on movie.id = crew.movie
where crew.movie is null;

-- extract the movies that are not released in Italy
select movie.id, movie.official_title, released.country
from imdb.movie left join imdb.released on (movie.id = released.movie and released.country = 'ITA')
where released.country is null;

select movie.id, movie.official_title
from imdb.movie 
EXCEPT
select movie.id, movie.official_title
from imdb.movie inner join imdb.released on movie.id = released.movie
where released.country = 'ITA';

select movie.id, movie.official_title
from imdb.movie
where movie.id not in (
    select released.movie
    from imdb.released
    where released.country = 'ITA'
);

-- extract all the movies for which we do not know the director 
select movie.id, movie.official_title
from imdb.movie left join imdb.crew on (movie.id = crew.movie and lower(crew.p_role) = 'director')
where crew.p_role is null;

select movie.id, movie.official_title
from imdb.movie
EXCEPT
select movie.id, movie.official_title
from imdb.movie inner join imdb.crew on movie.id = crew.movie
where lower(crew.p_role) = 'director';

select movie.id, movie.official_title
from imdb.movie
where movie.id not in (
    select crew.movie
    from imdb.crew
    where lower(crew.p_role) = 'director'
);


-- extract the movies that are produced in both Italy and USA
select p_ita.movie
from imdb.produced p_ita inner join imdb.produced p_usa on p_ita.movie = p_usa.movie
where p_ita.country = 'ITA' and p_usa.country = 'USA';

select movie
from imdb.produced
where country = 'ITA' and movie in (
    select movie
    from imdb.produced
    where country = 'USA'
)

select movie
from imdb.produced
where country = 'ITA'
INTERSECT
select movie
from imdb.produced
where country = 'USA'

-- extarct the movies that are produced in Italy and USA and no other country
select movie
from imdb.produced
where country = 'ITA'
INTERSECT
select movie
from imdb.produced
where country = 'USA'
EXCEPT
select movie
from imdb.produced
where country <> 'ITA' and country <> 'USA';


select p_ita.movie
from imdb.produced p_ita inner join imdb.produced p_usa on p_ita.movie = p_usa.movie left join 
    imdb.produced p_other on (p_ita.movie = p_other.movie and p_other.country <> 'ITA' and p_other.country <> 'USA')
where p_ita.country = 'ITA' and p_usa.country = 'USA' and p_other.country is null;

-- extract the id of pairs of actors that are involved in the same movie
select p1.person, p2.person
from imdb.crew p1 inner join imdb.crew p2 on p1.movie = p2.movie
where p2.person <> p1.person and lower(p1.p_role) = 'actor' and lower(p2.p_role) = 'actor';


-- extract the movies that are produced in ITA or USA
select movie
from imdb.produced
where country = 'ITA'
UNION
select movie
from imdb.produced
where country = 'USA';

select distinct movie
from imdb.produced
where country = 'ITA' or country = 'USA';

-- extract the movie taht is the longest one in duration among those of 2012
select official_title, length
from imdb.movie
where year = '2012' and length = (
    select max("length")
    from imdb.movie
    where year = '2012'
);

-- return the number of movies from 2012
select count(*) as "number of movies"
from imdb.movie
where year = '2012';

-- return the number of movies from 2012 with a duration
select count(length)
from imdb.movie
where year = '2012';

-- return the number of different year values in which movies are produced
select count(distinct year)
from imdb.movie;

-- return the number of movies for each year
select year, count(*)
from imdb.movie
group by year
order by 1 desc;

-- show the longest movie for each year
select max(length), year
from imdb.movie
group by year
order by 1 desc;

-- show the number of countries in which any movie is released and show the title of the movie
select count(country), movie, official_title
from imdb.released inner join imdb.movie on movie.id = released.movie
group by movie, official_title;

-- retrive the number of movies by year
select count(*) as "number of movies", year
from imdb.movie
group by year;

-- retrive the number of stored for which the title is defined
select count(*)
from imdb.movie
where official_title is not null;

-- retrive the number of movies, for each person, where they are involved as actors
select count(*)
from imdb.crew
where lower(p_role) = 'actor'
group by person;


-- what about people that are not actors
select count(*), person.id, crew.p_role
from imdb.person left join imdb.crew on (person.id = crew.person and lower(p_role) = 'actor')
where crew.p_role is null
group by person.id, crew.p_role;

-- return the people that are not involved in any movie
select distinct person.id
from imdb.person
EXCEPT
select crew.person
from imdb.crew

-- return the people that are involved in more than 10 movies
select crew.person, count(movie)
from imdb.crew
group by crew.person
having count(movie) > 10;

-- return the people that are involved in more than 10 movies as actors
select crew.person, count(movie)
from imdb.crew
where lower(crew.p_role) = 'actor'
group by crew.person
having count(movie) > 10
order by 2 desc;

-- retrive the average movie length for each year
select avg(length), year
from imdb.movie
group by year
order by year;

-- retrive the movies with more than 10 actors in the crew
select crew.movie, movie.official_title, count(crew.person)
from imdb.crew inner join imdb.movie on movie.id = crew.movie
where lower(p_role) = 'actor'
group by crew.movie, movie.official_title
having count(crew.person) > 10;

-- retrive the people that played more than one role in a specific movie
select crew.person, crew.movie
from imdb.crew
group by crew.person, crew.movie
having count(distinct crew.p_role) > 1;

-- retrive the people that played more than one role movies
select crew.person
from imdb.crew
group by crew.person
having count(distinct crew.p_role) > 1;
