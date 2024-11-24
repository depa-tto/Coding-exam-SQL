-- Retrieve the first and last name of actors that
-- played in the movie ‘Interstellar’ (id = 0816692)
select person.given_name
from imdb.crew inner join imdb.person on person.id = crew.person
    inner join imdb.movie on movie.id = crew.movie
where lower(movie.official_title) = 'Interstellar';

-- Retrieve all the movies with related ratings
-- Also movies that are not associated with any
-- rating are included in the result
select movie.official_title, rating.score
from imdb.movie left join imdb.rating on movie.id = rating.movie
order by 2;

-- Retrieve the persons without a bio
select person.given_name
from imdb.person 
where bio is null;

-- Retrieve the movies with length higher than
-- ‘Interstellar’ (sort result by title)
select m_other.official_title
from imdb.movie as m_int, imdb.movie as m_other 
where lower(m_int.official_title) = '‘Interstellar’' and m_other.length > m_int.length
order by 1;

-- Retrive the official title of the longest movie
select official_title, length
from imdb.movie
where length = (
    select max("length")
    from imdb.movie
);

-- Retrieve the number of movies in the db
select count(movie)
from imdb.movie;

-- Retrieve the number of movies released in 2010
select count(movie)
from imdb.movie
where year = '2010';


-- Retrieve the number of different roles that appear in the crew
select count(distinct crew.p_role)
from imdb.crew

--Retrieve the number of persons with known birthdate (non-null birth_date)
select count(person.given_name)
from imdb.person
where person.birth_date is not null;

select count(person.birth_date)
from imdb.person;


-- Retrieve the number of actors for each movie
select count(crew.person)
from imdb.crew
where crew.p_role = 'actor'
group by crew.movie;


-- Retrieve the movies with a cast composed of more than 10 actors
select crew.movie, count(crew.person)
from imdb.crew
where crew.p_role = 'actor'
group by crew.movie
having count(crew.person) > 10;


-- Retrieve the movies with length higher than 120 
-- minutes and cast composed of more than 10 actors
select crew.movie
from imdb.crew inner join imdb.movie on movie.id = crew.movie
where movie.length > 120 and crew.p_role = 'actor'
group by crew.movie
having count(crew.person) > 10;


-- Retrieve the persons that are born OR dead in Italy (iso3 code = ITA)
select location.person
from imdb.location
where location.d_role = 'birth' and location.country = 'ITA'
UNION 
select location.person
from imdb.location
where location.d_role = 'death' and location.country = 'ITA';


select location.person
from imdb.location
where (location.d_role = 'birth' and location.country = 'ITA') or
        (location.d_role = 'death' and location.country = 'ITA');


-- Retrieve the persons that are born AND dead in Italy (iso3 code = ITA)
select location.person
from imdb.location
where location.d_role = 'birth' and location.country = 'ITA'
INTERSECT
select location.person
from imdb.location
where location.d_role = 'death' and location.country = 'ITA';


select location.person
from imdb.location
where (location.d_role = 'birth' and location.country = 'ITA') and
        (location.d_role = 'death' and location.country = 'ITA');


-- Retrieve the persons that are born in Italy (iso3 code = ITA), but dead elsewhere
select location.person
from imdb.location
where location.d_role = 'birth' and location.country = 'ITA'
INTERSECT
select location.person
from imdb.location
where location.d_role = 'death' and location.country <> 'ITA';


select location.person
from imdb.location
where location.d_role = 'birth' and location.country = 'ITA'
EXCEPT
select location.person
from imdb.location
where location.d_role = 'death' and location.country = 'ITA';


-- Retrieve the movies that have a genre in common with the ‘Interstellar’ movie
select id, official_title
from imdb.movie inner join imdb.genre on movie.id = genre.movie
where genre.genre = ANY (
    select genre.genre
    from imdb.movie inner join imdb.genre on movie.id = genre.movie
    where official_title = 'Interstellar'
);

select id, official_title
from imdb.movie inner join imdb.genre on movie.id = genre.movie
where genre.genre in (
    select genre.genre
    from imdb.movie inner join imdb.genre on movie.id = genre.movie
    where official_title = 'Interstellar'
);

-- Retrieve the movies that have not been released in Italy (iso3 code = ITA)
select movie.id
from imdb.movie
EXCEPT
select released.movie
from imdb.released
where released.country = 'ITA';


select movie.id
from imdb.movie
where movie.id not in (
    select released.movie
    from imdb.released
    where country = 'ITA'
);


-- Retrieve the movies that have a rating higher 
-- than the average of ratings of the ‘Interstellar’ movie (id = 0816692)
select distinct movie
from imdb.rating
where score > (
    select avg(score)
    from rating
    where movie = '0816692'
);



