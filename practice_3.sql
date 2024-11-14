-- get the official_title of Irish movie
select movie.official_title
from imdb.movie inner join imdb.produced on movie.id = produced.movie
where produced.country = 'IRL';

-- retrive all the movies that are not produced in Irland
select movie.id, movie.official_title
from imdb.movie left join imdb.produced on 
        (movie.id = produced.movie and produced.country = 'IRL')
where produced.country is null;

-- get the countries where 'Crime' movies are produced
select distinct produced.country
from imdb.produced inner join imdb.genre on produced.movie = genre.movie
where lower(genre.genre) = 'crime'; 

-- get the title of movies starring 'Anne Hathaway'
select movie.id, movie.official_title
from imdb.movie inner join imdb.crew on movie.id = crew.movie inner join
        imdb.person on person.id = crew.person
where lower(person.given_name) = 'anne hathaway'; 
-- be carefull when using lower that we have tomlower also 
-- the condition, so in this cade anne hathway must be all in lower case

-- get the ids of top 10 ranking Horror movies
select genre.movie, score / scale as "normalized score"
from imdb.genre inner join imdb.rating on genre.movie = rating.movie
where lower(genre.genre) = 'horror'
order by 2 desc
limit 10;


-- get the title of movies produced in one of the following countries: 'AUS', 'GBR' or 'IRL'
select movie.official_title, produced.country
from imdb.movie inner join imdb.produced on movie.id = produced.movie
where produced.country = 'AUS' or produced.country = 'GBR' or produced.country = 'IRL';

select official_title, country
from imdb.movie inner join imdb.produced ON movie.id = produced.movie
where country IN ('AUS', 'GBR', 'IRL');

-- get movies produced in both USA and FRA
select movie.id
from imdb.movie inner join imdb.produced on movie.id = produced.movie
where produced.country = 'USA'
INTERSECT
select movie.id
from imdb.movie inner join imdb.produced on movie.id = produced.movie
where produced.country = 'FRA';


select p_fra.movie
from imdb.produced p_usa inner join imdb.produced p_fra on 
    p_fra.movie = p_usa.movie 
where p_fra.country = 'FRA' and p_usa.country = 'USA';


select movie
from imdb.produced
where country = 'FRA' and movie in (
    select movie
    from imdb.produced
    where country = 'USA'
);

-- return movies starring Matthew McConaughey as BOTH actor and producer
select crew.movie
from imdb.crew inner join imdb.person on crew.person = person.id
where p_role = 'actor' and person.given_name = 'Matthew McConaughey'
INTERSECT
select crew.movie
from imdb.crew inner join imdb.person on crew.person = person.id
where p_role = 'producer' and person.given_name = 'Matthew McConaughey';


select crew.movie
from imdb.crew inner join imdb.person on crew.person = person.id
where p_role = 'actor' and person.given_name = 'Matthew McConaughey' and crew.movie in (
    select crew.movie
    from imdb.crew inner join imdb.person on crew.person = person.id
    where p_role = 'producer' and person.given_name = 'Matthew McConaughey'
);


select matt_1.movie
from imdb.crew matt_1 inner join imdb.person p_1 on (matt_1.person = p_1.id
    and matt_1.p_role = 'actor') inner join imdb.crew matt_2 on matt_1.movie = matt_2.movie
    inner join imdb.person p_2 on (matt_2.person = p_2.id and matt_2.p_role = 'producer')
where p_1.given_name = 'Matthew McConaughey' and p_2.given_name = 'Matthew McConaughey';
-- INNER JOIN imdb.crew matt_2 ON matt_1.movie = matt_2.movie: we join matt_2 based on movie 
-- to ensure we're looking at the same movie where Matthew McConaughey has both roles.


select matt_1.movie
from imdb.crew matt_1 inner join imdb.person p_1 on (matt_1.person = p_1.id
    and p_1.given_name = 'Matthew McConaughey') inner join imdb.crew matt_2 on matt_1.movie = matt_2.movie
    inner join imdb.person p_2 on (matt_2.person = p_2.id and p_2.given_name = 'Matthew McConaughey')
where  matt_1.p_role = 'actor' and  matt_2.p_role = 'producer';



-- retunr the movies starring Matthew McConaughey as actor or producer
select crew.movie
from imdb.crew inner join imdb.person on crew.person = person.id
where p_role = 'actor' and person.given_name = 'Matthew McConaughey'
UNION
select crew.movie
from imdb.crew inner join imdb.person on crew.person = person.id
where p_role = 'producer' and person.given_name = 'Matthew McConaughey'

-- return movies without rating
select movie.id
from imdb.movie 
EXCEPT
select rating.movie
from imdb.rating
where rating.score is not null; -- be carefull to the condition


select movie.id
from imdb.movie 
where movie.id not in (
    select rating.movie
    from imdb.rating
    where rating.score is not null
);


select movie.id
from imdb.movie left join imdb.rating on movie.id = rating.movie
where rating.score is null;


-- return movies that are not Thriller: 
-- the condition does not refer to a single row, but to a movie, which may have several rows associated
-- Reasoning: you do NOT want to filter out rows that have the value 'Thriller', but rather movies that have 'Thriller' as one of their genres.
-- Therefore, the condition cannot be verified at the level of a single record.
-- Instead, it should be verified at the level of a block of rows referring to the same movie.
select movie.id, movie.official_title
from imdb.movie left join imdb.genre on (movie.id = genre.movie and lower(genre.genre) = 'thriller')
where genre.genre is null;

-- get all the movies
select movie.id, movie.official_title
from imdb.movie
EXCEPT -- get the thriller movies
select movie.id, movie.official_title
from imdb.movie inner join imdb.genre on movie.id = genre.movie
where lower(genre.genre) = 'thriller';


select movie.id, movie.official_title
from imdb.movie
where movie.id not in (
    select genre.movie
    from imdb.genre
    where lower(genre.genre) = 'thriller'
);


-- get movies produced in Australia or those never rated lower than 8.5
select produced.movie
from imdb.produced
where produced.country = 'AUS'
UNION
(
    select rating.movie -- we are taking all the rated movies
    from imdb.rating
    EXCEPT -- excluding movies rated below 8.5
    select rating.movie
    from imdb.rating
    where rating.score / rating.scale < 0.85
);

select produced.movie
from imdb.produced
where produced.country = 'AUS' 
UNION
select movie
from imdb.rating 
where movie not in (
    select movie 
    from imdb.rating
    where rating.score / rating.scale < 0.85
    );

-- return the length of the longest movie in the database
select max(length)
from imdb.movie;

# return the longest movie in the database
# returning the movie with the max length is different from returning the value of the max length ! 
# you need to use nested query to obtain the correct result
select *
from imdb.movie
where length = (
    select max(length)
    from imdb.movie
);


-- retrieve the oldest movie
select *
from imdb.movie
where year = (
    select min(year)
    from imdb.movie
)

-- for each actor count the number of movies
select count(movie), person
from imdb.crew
where p_role = 'actor'
group by person;

-- find the actor with the highest number of movies
select count(movie), person.given_name
from imdb.crew inner join imdb.person on crew.person = person.id
where p_role = 'actor'
group by person.given_name
order by 1 desc
limit 1;


-- find the movie with the highest number of cast members
select count(crew.person), movie.official_title
from imdb.crew inner join imdb.movie on crew.movie = movie.id
group by movie.official_title
order by 1 DESC
limit 1;


-- return the given_name of the actors with more than 50 movies
select count(crew.movie), person.given_name
from imdb.crew inner join imdb.person on crew.person = person.id
where crew.p_role = 'actor'
group by crew.person, person.given_name
having count(crew.movie) > 50;


-- select alive actor --> select actor without death date 
select person.id -- BE CAREFULL WHEN USING EXCEPT, THE FIRST AND SECOND SELECT MUST SHARE THE SAME ATTRIBUTE
from imdb.person inner join imdb.crew on person.id = crew.person
where crew.p_role = 'actor'
EXCEPT
select person.id
from imdb.person
where person.death_date is not null;

select distinct person.id
from imdb.person inner join imdb.crew on person.id = crew.person
where crew.p_role = 'actor' and person.id not in (
    select person.id
    from imdb.person
    where person.death_date is not null
)

select distinct person.id 
from imdb.crew left join imdb.person on crew.person = person.id
where crew.p_role = 'actor' and death_date is null

-- for each alive actor, count the number of movies, 
-- and return the year of her first and last movie along with her given_name
select person.id, given_name, count(crew.movie), min(year), max(year)
from imdb.crew left join imdb.person on crew.person = person.id inner join 
    imdb.movie on crew.movie = movie.id
where crew.p_role = 'actor' and death_date is null 
group by person.id, given_name;



