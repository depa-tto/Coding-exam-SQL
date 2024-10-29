-- get the code of movies that are produced in USA and FRA: both countries
-- the query asks fro two records of produced: one record about fra, another record about usa, and both about the same movie
-- this is a solution based on self-join of the table produced
select *
from imdb.produced p_usa inner join imdb.produced p_ita on p_usa.movie = p_ita.movie
where p_usa.country = 'USA' and p_ita.country = 'ITA';

-- alternative solution based on set operation
-- intersect is a set operation that returns the records that belong to both the queries bound by the intersection
-- constraints: i) the queries to combine must have the same number of attributes in the projection (select), and ii) each attribute in projection must be compatible on domain (data type) with the attribute in the other query in the same position
select movie, official_title
from imdb.produced inner join imdb.movie on movie.id = produced.movie
where country = 'USA'
INTERSECT
select movie, official_title
from imdb.produced inner join imdb.movie on movie.id = produced.movie
where country = 'FRA';

-- it is important to keep the key of the movies in the select, otherwise it is possible that different movies with same title produce a false positive in the results
-- in the following example, My Movie is returned by the following query because the movie code is missing in select
-- My Movie is related to different movie codes, and should not be included in result since the two movies are not produced in BOTH USA and FRA
SELECT official_title
from imdb.produced inner join imdb.movie on movie.id = produced.movie
where country = 'USA'
INTERSECT
SELECT official_title
from imdb.produced inner join imdb.movie on movie.id = produced.movie
where country = 'FRA';

-- example
produced
movie  | country
001         USA
002         FRA

movie
id  |  title
001     My Movie       2024
002     My Movie       1936

-- union operation
-- return movies that are produced in at least one country among USA and FRA
-- are movies from both returned? yes
-- are movies from both returned twice? no
-- use UNION ALL to return the records in the intersect twice
select movie, official_title
from imdb.produced inner join imdb.movie on movie.id = produced.movie
where country = 'USA'
UNION
select movie, official_title
from imdb.produced inner join imdb.movie on movie.id = produced.movie
where country = 'ITA';

-- this can be written as:
-- without distinct it is equivalent to UNION ALL
select distinct movie, official_title
from imdb.produced inner join imdb.movie on movie.id = produced.movie
where country = 'USA' or country = 'ITA';

-- return the movies that are produced only in USA
SELECT movie, official_title
from imdb.produced inner join imdb.movie on movie.id = produced.movie
where country = 'USA'
EXCEPT
SELECT movie, official_title
from imdb.produced inner join imdb.movie on movie.id = produced.movie
where country <> 'USA';

-- return the movies that are BOTH thriller and horror
select *
from imdb.genre m_th inner join imdb.genre m_ho on m_ho.movie = m_th.movie
where m_ho.genre = 'Horror' and m_th.genre = 'Thriller';

-- alternative syntax
select movie
from imdb.genre
where genre = 'Horror'
INTERSECT
select movie
from imdb.genre
where genre = 'Thriller';

-- alternative syntax based on the notion of nested query (subquery)
select movie
from imdb.genre
where genre = 'Thriller' and movie in (
    select movie
    from imdb.genre
    where genre = 'Horror'
)

-- return persons that are born and died in the same country
-- solution 1
select birth.person, birth.country as "country of birth", death.country as "country of death"
from imdb.location birth inner join imdb.location death on birth.person = death.person
where birth.d_role = 'B' and death.d_role = 'D' and birth.country = death.country;

-- solution 2
select person, country
from imdb.location
where d_role = 'B'
INTERSECT
select person, country
from imdb.location
where d_role = 'D';


-- other kinds of join
-- consider this join
select *
from imdb.movie inner join imdb.produced ON movie.id = produced.movie;

-- is it possible that a movie is missing in the result of the previous query? yes, when the movie does not have any relation with the records in produced

-- to include movies that are not present in produced (spurious records), use an external/lateral join
-- in this case we use a left join: it is the result of inner + the spurious records of the table on the left side of the join (spurious means records without any link with records with the table on the right

select *
from imdb.movie left join imdb.produced ON movie.id = produced.movie;

-- return the movies without genre
select id, official_title
from imdb.movie
where id not in (
    select distinct movie
    from imdb.genre
);

select id
from imdb.movie
EXCEPT
SELECT movie
from imdb.genre

select official_title
from imdb.movie left join imdb.genre on movie.id = genre.movie
where genre is null;

-- this is equivalent to the following
-- right join means that you add the spurious records in the table on the right of the join operation in addtion to the result of the inner join
select movie.id
from imdb.genre right join imdb.movie on movie.id = genre.movie
where genre.movie is null;