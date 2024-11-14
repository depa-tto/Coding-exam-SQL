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


# return movies without rating


