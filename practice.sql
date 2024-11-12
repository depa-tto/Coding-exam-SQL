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




