/* retrieve the movies with unique title */
db.movie.aggregate(
    [
        {'$group':{'_id':'$title','# of movies':{'$sum':1}}},
        {'$match':{'# of movies':1}},
        {'$project':{'_id':0,'unique movie title':'$_id'}}
    ]
)

/* retrieve the number of movies with unique title */
db.movie.aggregate(
    [
        {'$group':{'_id':'$title','nom':{'$sum':1}}},
        {'$match':{'nom':1}},
        {'$group':{'_id':null,'movie_count':{'$sum':1}}},
        {'$project':{'_id':0,'number of movies with unique title':'$movie_count'}}
    ]
)

/* retrieve the movies with duplicate title */
db.movie.aggregate(
    [
        {'$group':{'_id':'$title','nom':{'$sum':1}}},
        {'$match':{'nom':{'$gte':2}}},
        {'$project':{'_id':0,'movie':'$_id'}}
    ]
)

/* retrieve the number of persons in the crew of each movie */
db.movie.aggregate(
    [
        {'$unwind':'$crew'},
        {'$group':{'_id':{'title':'$title'},'people in crew':{'$sum':1}}}
    ]
)


/* we can use $size to count the number of elements in a list field */
/* https://www.mongodb.com/docs/manual/reference/operator/aggregation/size/ */
/* attention: an error is raised if the field is not an array */
db.movie.aggregate(
    [
        { "$match": { "crew": {"$type": "array"} } },
        { "$project": {"title": 1, "number of persons in the crew": { "$size": "$crew" } } }
    ]
)


/* alternative with $cond, $if, $else */
db.movie.aggregate(
    [
        { "$project": { "title": 1, "number of persons in the crew": { "$cond": { "if": { "$isArray": "$crew" }, "then": { "$size": "$crew" }, "else": "NA" } } } }
    ])


/* to test the behavior of $unwind, we find movies with a crew containing less than 5 persons */
db.movie.aggregate(
    [
        {'$unwind':'$crew'},
        {'$group':{'_id':'$title','pic':{'$sum':1}}},
        {'$match':{'pic':{'$lte':5}}}
    ]
)


/*  more efficient as it directly calculates the array size using $size, without needing to $unwind or $group the documents */
db.movie.aggregate(
    [
        { "$match": { "crew": {"$type": "array"} } },
        { "$project": {"title": 1, "number of persons in the crew": { "$size": "$crew" } } },
        { "$match": { "number of persons in the crew": { "$lte": 5 } } }
    ]
)


/* retrieve the average number of persons in the crew of each movie */
db.movie.aggregate(
    [
        {'$unwind':'$crew'},
        {'$group':{'_id':'$title','sum_people':{'$sum':1}}},
        {'$group':{'_id':null,'avg people':{'$avg':'$sum_people'}}}
    ]
)


/* retrieve the title and the score of movies rated in november 2017 */
/* solution with aggregation */
db.movie.aggregate(
    [   
        {'$unwind':'$ratings'},
        {'$match':{'ratings.rating_date':{'$gte':ISODate('2017-11-01'),'$lte':ISODate('2017-11-31')}}},
        {'$project':{'_id':0,'ratings.score':1,'title':1}}
    ]
)


/* solution without aggregation */
db.movie.find(
    {
        'ratings':{'$elemMatch':
            {'rating_date':{'$gte':ISODate('2017-11-01'),
                '$lte':ISODate('2017-11-30')}}
        }
    },
    {
        'title':1,
        'ratings.score':1,
        '_id':0
    }
)


/* retrieve the people that participated to more than 10 movies */
db.movie.aggregate(
    [
        {'$unwind':'$crew'},
        {'$group':{'_id':{'pid':'$crew.person_id','pna':'$crew.given_name'},'nom':{'$sum':1}}},
        {'$match':{'nom':{'$gt':10}}}
    ]
)


/* retrieve the actors that participated to more than 10 movies */
/* only consider "actor" as a role */
db.movie.aggregate(
    [
        {'$unwind':'$crew'},
        {'$match':{'crew.role':'actor'}},
        {'$group':{'_id':{'pid':'$crew.person_id','pna':'$crew.given_name'},'nom':{'$sum':1}}},
        {'$match':{'nom':{'$gt':10}}}
    ]
)


/* retrieve the whole number of ratings provided in 2017 */
/* solution without aggregation */
db.movie.find(
    {
        'ratings':{'$elemMatch':{
            'rating_date':{'$gte':ISODate('2017-01-01'),
                '$lte':ISODate('2017-12-31')
            }
        }}
    }
).count()

/* solution with aggregation */
db.movie.aggregate(
    [
        {'$unwind':'$ratings'},
        {'$match':{'ratings.rating_date':
            {'$gte':ISODate('2017-01-01'),
            '$lte':ISODate('2017-12-31')}}},
        {'$group':{'_id':null,'movies rated in 2017':{'$sum':1}}}
    ]
)


/* altervative solution */
db.movie.aggregate([
	{ "$unwind": "$ratings" },
	{ "$project": {"_id": 0, 
                   "year": {"$year": "$ratings.rating_date"}
                 } },
    { "$match": { "year": 2017 } },
	{ "$group": { "_id": "$year", "Number of ratings": { "$sum": 1 } } }
]
)