/* retrieve the movies that have not received any review */
/* use of the $exists operator */
db.movie.find(
    {
        'ratings':{'$exists':false}
    },
    {
        'title':1,
        'ratings':1
    }
)


/* consider that sometimes ratings can be defined in a document with null */
db.movie.find(
    {
        '$or':[
            {'ratings':{'$exists':false}},
            {'ratings':null}
        ]
    },
    {
        '_id':0,
        'title':1,
    }
)

/* retrieve the movies that have received at least one review (ratings exist) */
/* consider the case of movies with ratings: null that have to be excluded */
db.movie.find(
    {
        '$or':[
            {'ratings':{'$exists':true}},
            {'ratings':{'$ne':null}}
        ]
    },
    {
        "title": 1,
        "ratings": 1
    }
)

/* retrieve the number of movies from 2010 */
db.movie.find(
    {
        'year':'2010'
    }
).count()

/* alternative solution with aggregation framework */
db.movie.aggregate(
    [
        {'$match':{'year':'2010'}},
        {'$group':{'_id':null,'number of movies':{'$sum':1}}}
    ]
)

db.movie.aggregate(
    [
        {'$group':{'_id':'$year','# movies':{'$sum':1}}}
    ]
)


db.movie.aggregate(
    [
        {'$group':{'_id':'$year','# movies':{'$sum':1}}},
        {'$match':{'_id':'2010'}} // group by id since after the 'group' operator there is no year field anymore
    ]
)

/* return the title and the year of the movies of 2010 */
db.movie.find(
    {
        'year':'2010'
    },
    {
        'title':1,
        '_id':0,
        'year':1
    }
)


/* alternative solution with aggregate */
db.movie.aggregate(
    [
        {'$match':{'year':'2010'}},
        {'$group':{'_id':{'year':'$year','title':'$title'}}}
    ]
)


db.movie.aggregate(
    [
        {'$match':{'year':'2010'}},
        {'$project':{'_id':0,'title':1,'year':1}}
    ]
)


/* retrieve the number of movies by year */
/* the '$' before a field name indicates that the value of this field from incoming document will be considered in the operation. */
/* i n this example, $year means group by the values of the year field. */
/* sort the result according to the counts in descending order and sort by year in ascending order when the counter are the same */
db.movie.aggregate(
    [
        {'$group':{'_id':'$year', 'number of movies': {'$sum':1}}},
        {'$sort':{'number of movies':-1,'_id':1}}
    ]
)

/* retrieve the overall length of movies with Leonardo DiCaprio */
db.movie.aggregate(
    [
        {'$match':{'crew.given_name':/leonardo dicaprio/i}},
        {'$group':{'_id':null,'overall length':{'$sum':'$length'}}}, // '_id':null means that all the documents will be grouped togheter in an unique group
        {'$project':{'_id':0,'person name':'Leonardo DiCaprio','overall length':1}}
    ]
)

/* retrieve the average length of movies with Leonardo DiCaprio */
db.movie.aggregate(
    [
        {'$match':{'crew.given_name':/leonardo dicaprio/i}},
        {'$group':{'_id':null,'average length':{'$avg':'$length'}}},
        {'$project':{'_id':0,'person name':'Leonardo DiCaprio','average length':1}}
    ]
)

/* retrive the number of movies per year */
db.movie.aggregate(
    [
        {'$group':{'_id':'$year','number of movies':{'$sum':1}}}
    ]
)

/* calculate the average length of movies with Leonardo DiCaprio from sum and count (different result from avg. Why?) */
/* in the following solution the 'number_of_movies' includes also movies that are not associated with a length, so the denominator is higher. */
/* In $avg, only movies with a value of length are considered. */
db.movie.aggregate(
    [
        { "$match": { "crew.given_name": "Leonardo DiCaprio" } },
        { "$group": { 
            "_id": "Leonardo DiCaprio", 
            "overall_movie_length": { "$sum": "$length" },
            "number_of_movies": { "$sum": 1 } } },
        { "$project": { "_id": 0, "actor name": "$_id",
                        "average_movie_length": { "$divide": [ "$overall_movie_length", "$number_of_movies" ] } } }
    ]
)





