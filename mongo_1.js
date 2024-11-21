// find the movies of 2010
db.movie.find(
    {
        'year':'2010'
    }
)

// find the movies of 2010 and show me only the id, title and the year
db.movie.find(
    {
        'year':'2010'
    },
    {
        'movie_id':1,
        'title':1,
        'year':1,
        '_id':0 // not shown in the final result
    }
)

// find the movies of 2010 and show me only the id, title and year
// sort the rusult by title
db.movie.find(
    {
        'year':'2010'
    },
    {
        '_id':1,
        'title':1,
        'year':1
    }
).sort(
    {
        'title':1
    }
)


db.movie.find(
    {
        'year':'2010'
    },
    {
        'movie_id':1,
        'title':1,
        'year':1,
        'length':1 
    }
).sort(
    {
        'title':1,
        'length':-1 // -1 means descending order
    }
)


// retunr the movies from 2010 with length grater than 60 minutes
db.movie.find(
    {
        'year':'2010',
        'length': {'$gt':60}
    }
)

// return the movies that are not from 2010
db.movie.find(
    {
        'year':{'$ne':'2010'}
    }
)

// retrive the number of movies of 2010 and greater than 60
db.movie.find(
    {
        'year':'2010',
        'length':{'$gt': '60'}
    },
    {
        '_id':0,
        'title':1,
        'year':1,
        'length':1
    }
).count()


// retrive the movies with length between 60 and 120 minutes
db.movie.find(
    {
        'length':{'$gt':60,
                '$lt':120}
    },
    {
        '_id':0,
        'title':1,
        'year':1,
        'length':1    
    }
)

// alternative solution with the $and operator
db.movie.find(
    {
        '$and': [
            {'length':{'$gt':60}},
            {'length':{'$lt':120}}
        ]
    },
    {
        '_id':0,
        'title':1,
        'year':1,
        'length':1
    }
)

// retrive the movies of 2010 or 2011 with length between 60 and 120
// sort the result by title(desc order)
db.movie.find(
    {
        '$and': [
            {'length': {'$gt': 60}},
            {'length': {'$lt': 120}}
        ],
        '$or': [
            {'year':'2010'},
            {'year':'2011'}
        ]
    },
    {
        '_id':0,
        'title':1,
        'year':1,
        'length':1
    }
).sort(
    {
        'title':-1
    }
)

// alternative solution using the '$in' operator
db.movie.find(
    {
        '$and': [
            {'length': {'$gt':60}},
            {'length': {'$lt':120}},
            {'year': {'$in': [
                '2010','2011'
            ]}}
        ]
    },
    {
        '_id':0,
        'title':1,
        'year':1,
        'length':1
    }
).sort(
    {
        'title': -1
    }
)


// retrive the titles of movies with actor that have 'Caprio' in their name
db.movie.find(
    {
        'crew.given_name': {'$regex': /.*caprio.*/i} 
        // means that we want all the string that has every possible char before/after 'caprio'
        // i specifies that we want the searching to be case-insensitive
    },
    {
        'title':1,
        'crew.given_name.$':1 
        // '.$' allows us to show just the first nested option in the object that satisfy the conditions
    }
)


// retrive the movies that have not received any review
db.movie.find(
    {
        'ratings': {'$exists': false}
    },
    {
        'title':1
    }
)



// retrive the movies that have been rated on oct 31st 2017
db.movie.find(
    {
        'ratings.rating_date': ISODate('2017-10-31')
        // ISODate in in the US date format
    },
    {
        'title':1,
        'ratings.rating_date.$':1
    }
)


// retrive the movies that have been rated in nov 2017
db.movie.find(
    {
        'ratings.rating_date': {
            '$gte': ISODate('2017-11-01'),
            '$lte': ISODate('2017-11-31')
        }
    },
    {
        'title':1,
        'ratings.rating_date.$':1
    }
)


// retrive the movies that have been rated in nov 2017 where leonardo di caprio is a producer
db.movie.find(
    {
        'ratings.rating_date':{
            '$gte': ISODate('2017-11-01'),
            '$lte': ISODate('2017-11-31')},
        'crew': {'$elemMatch': {
            'given_name': 'Leonardo DiCaprio',
            'role':'producer'
        }}
    },
    {
        'title':1
    }
)


// AGGREGATION PIPELINE

// return the number of movies for each year
db.movie.aggregate(
    [
        {'$group': {'_id': {'year':'$year'}, 'number of movies': {'$sum':1}}}
    ]
)

// return the number of movies for each year and sort the result by year
db.movie.aggregare(
    [
        {'$group': {'_id':{'year':'$year'}, 'number of movies': {'$sum':1}}},
        {'$sort': {'_id':1}}
    ]
)

// sort the result by number of movies in descending order 
db.movie.aggregate(
    [
        {'$group': {'_id': {'year': '$year'}, 'number of movies': {'$sum': 1}}},
        {'$sort': {'number of movies': -1}}
    ]
)



