/* {"_id": Objectld("5ea754e59183e253671f26ff"),
id: 'FL3838',
company: 'Lufthansa',
departure_time: new Date("2022-05-18T16:00:00Z"),
arrival_time: new Date("2022-05-18T19:30:00Z"),
delay: 10
dep_airport: {
    code: 'LIN'
    name: 'Milano Linate',
    city: 'Milan',
    country: 'Italy'
}
arr_airport: {
    code: 'FCO'
    name: 'Roma Fiumicino',
    city: 'Rome',
    country: 'Italy'
}} */

/* Consider the given document example of the flights collection in a MongoDB
database and address the given queries:*/

/* A. Retrieve the id of Italian domestic flights (flights with departure and arrival in Italy); */
db.flights.find(
    {
        'dep_airport.country':'Italy',
        'arr_airport.country':'Italy'
    },
    {
        '_id':0,
        'id':1
    }
)


/* B. Return the name of airports where the overall delay considering all the incoming
flights is greater than 5 hours (a flight is incoming on the airport of arrival); */
db.flights.aggregate(
    [
        {'$group':{'_id':{'code':'$arr_airport.code','name':'$arr_airport.name'},'tot_delay':{'$sum':'$delay'}}},
        {'$match':{'tot_delay':{'$gte':300}}},
        {'$project':{'_id':0, 'airport_name':'$_id.name'}}
    ]
)


/* C. Retrieve the overall delay collected by flights departing from the city of Milan
and arriving in the city of Rome. */
db.flights.aggregate(
    [
        {'$match':{'dep_airport.city':'Milan','arr_airport.city':'Rome'}},
        {'$group':{'_id':null,'tot_delay':{'$sum':'$delay'}}}
    ]
)
