/* select the movies from 2012 */
db.movie.find(
    {
        'year':'2012'
    }
)

/*
$ne: not equal
$eq: equal
$gte: greater than or equal to
$lte: less than or equal to
$gt: greater than 
$lt: less than 
$in: within a list of values
*/


/* select the movies of 2010 with length greater than 2 hours */
db.movie.find(
    {
        'year':'2010',
        'length':{'$gte':120}
    }
)

/* select the movies of 2010 with length between 1 and 2 hours */
db.movie.find(
    {
        'year':'2010',
        'length':{'$gte':60,'$lte':120}
    }
)


/* retrieve the movies with a duration/length greater than 120 and not belonging to 2010 */
db.movie.find(
    {
        'year':{'$ne':'2010'},
        'length':{'$lte':120}
    }
)

/* alternative solution based on $and */
db.movie.find(
    {
        '$and':[
            {'year':{'$ne':'2010'}},
            {'length':{'$gte':120}}
        ]
    }
)

/* $and, $or */
/* retrieve the movies with length between 60 AND 120 minutes of duration OR year of production in 2010, 2011, 2012 */
/* the find command can have a second argument that is the filtering on the projection */
db.movie.find(
    {
        '$or':[
            {'year':{'$in':['2010','2011','2012']}},
            {'length':{'$gte':60,'$lte':120}}
        ]
    },
    {
        '_id':0,
        'title':1,
        'year':1,
        'length':1
    }
)

/* sort the result of the previous command */ 
/* docs are sorted according to the values of the year field in descending order (1) */
/* when the year value is the same on two documents, the title is used for sorting in ascending order (-1) */
db.movie.find(
    {
        '$or':[
            {'year':{'$in':['2010','2011','2012']}},
            {'length':{'$gte':60,'$lte':120}}
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
        'year':-1,
        'title':1
    }
)


/* count the documents in the result of a find */
db.movie.find(
    {
        '$or':[
            {'year':{'$in':['2010','2011','2012']}},
            {'length':{'$gte':60,'$lte':120}}
        ]
    },
    {
        '_id':0,
        'title':1,
        'year':1,
        'length':1
    }
).count()


/* retrieve the list of movies with Leonardo DiCaprio */
db.movie.find(
    {
      "crew.give_name": "Leonardo DiCaprio"
    },
    { 
      "_id": 0,
      "title": 1,
      "crew.give_name.$": 1
    }
)



/* use of regular expressions for matching documents with approximation */
/* in this example, we search for leonardo dicaprio with case insensitive match */
/* for details about regular expressions in MongoDB: */
/* https://www.mongodb.com/docs/manual/reference/operator/query/regex/ */
db.movie.find(
    {
      "crew.give_name": { "$regex": /leonardo dicaprio/i }
    }
)

/* alternativs syntax */
db.movie.find(
    {
      "crew.give_name": /leonardo dicaprio/i
    })



/* in this example, we match the values containing the string "dicaprio" with case insensitive match */
/* .* means a string of any length */
db.movie.find(
    {
        'crew.given_name':{'$regex':/.*dicaprio.*/i}
    },
    {
        'crew.given_name.$':1,
        '_id':0,
        'title':1
    }
)

/* filtering with dates */
/* retrieve the docs with reviews on October 31st 2017 */
/* dates are not strings: this example is syntactically correct, but no results are found */
db.movie.find(
    {
        'ratings.rating_date':ISODate('2017-10-31')
    },
    {
        '_id':0,
        'ratings.rating_date.$':1,
        'title':1
    }
)



db.movie.find(
    {
      "ratings.rating_date": new Date("2017-10-31")
    },
    {
        '_id':0,
        'ratings.rating_date.$':1,
        'title':1
    }
)

    
/* get the movies that are rated in october 2017 */
/* these solutions are correct only if a single review is contained in the ratings list of a movie */
db.movie.find(
    {
        'ratings.rating_date':{'$lte':ISODate('2017-10-31'),
                                '$gte':ISODate('2017-10-01')}
    },
    {
        '_id':0,
        'title':1,
        'ratings.rating_date.$':1
    }
)


/* get the movies with Leonardo DiCaprio as an actor */
/* this solution is not correct because a crew field can satisfy both the conditions but with different nested items */
db.movie.find(
    {
      "crew.give_name": "Leonardo DiCaprio",
      "crew.role": "actor"
    },
    { 
      "_id": 0,
      "title": 1,
      "crew.give_name.$": 1
    })

/* this is an example of matching document that is not about Leonardo DiCaprio as an actor: false positive */
    // {
        // "title": "XXX",
        // "crew": [
        // { "give_name": "Leonardo DiCaprio",
        //    "role": "producer" },
        // { "give_name": "Edward Norton",
        //    "role": "actor" }  
        // ]
    // }


/* this solution is correct: use elemMatch */
db.movie.find(
    {
        'crew':{'$elemMatch':
            {'given_name':/leonardo dicaprio/i,
            'role':/actor/i
            }
        }
    },
    { 
    "_id": 0,
    "title": 1,
    "crew.give_name.$": 1
    }
)


/* find the movies with Dicaprio as an actor rated in November 2017 */
/* this solution is not completely safe */
db.movie.find(
    {
        'crew':{'$elemMatch':
            {'given_name':/leonardo dicaprio/i,
                'role':/actor/i}
        },
        'ratings.rating_date':{'$lte':ISODate('2017-11-30'),
                                '$gte':ISODate('2017-11-01')
        }
    },
    {
        '_id':0,
        'title':1,
        'ratings.rating_date.$':1
    }
)

/* this is a false positive with respect to the previous query */
// {
// "title": "YYY",
// "ratings": [
//    {
//    "rating_date": new Date("2016-08-20"),
//    "score": 8.2 
//    },
//    {
//    "rating_date": new Date("2020-03-15"),
//    "score": 4.5
//    }
// ]
// }



/* correct solution */
db.movie.find(
    {
        'crew':{'$elemMatch':
            {'given_name':/leonardo dicaprio/i,
                'role':/actor/i
            }
        },
        'ratings':{'$elemMatch':
            {'rating_date':{'$gte':ISODate('2017-11-01')},
            'rating_date':{'$lte':ISODate('2017-11-31')}
            }
        }
    },
    {
        '_id':0,
        "title": 1,
        "ratings": 1,
    }
)


db.movie.find(
    {
        'crew':{'$elemMatch':
            {'given_name':/leonardo dicaprio/i, 'role':'actor'}
        },
        'ratings':{'$elemMatch':
            {'rating_date': {'$gte': new Date ('2017-11-01'), '$lte': new Date('2017-11-31')}}}
    },
    {
        '_id':0,
        "title": 1,
        "ratings": 1,
    }
)