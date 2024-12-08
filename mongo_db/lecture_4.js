/* retrieve the orders submitted on Tuesday (order_dow = 2) between 8 and 20 */
db.orders.find(
    {
        'order_dow':2,
        'order_hour_of_day':{'$gte':8,'$lte':20}
    }
)


/* orders submitted on Tuesday (order_dow = 2) between 8 and 20 where at least 
one product contains the string "soda" (case insensitive match). In the result,
only the fields order_id, order_dow, order_hour_of_day are shown as well as 
the contents (all the fields) of the first soda-matching product. 
The result is sorted by user_id in ascending order. */
db.orders.find(
    {
        'order_dow':2,
        'order_hour_of_day':{'$gte':8,'$lte':20},
        'products.product_name':{'$regex':/soda/i}
    },
    {
        '_id':0,
        'order_id':1,
        'order_dow':1,
        'order_hour_day':1,
        'products.product_name.$':1
    }
).sort(
    {
        'user_id':1
    }
)


/* count the TOTAL(so '_id':null) number of ORDERS submitted on Tuesday (order_dow = 2) between 8 and 20 where "soda" is ordered. Use aggregate. */
/* counts the total number of orders that include at least one soda product during the same time frame. */
db.orders.aggregate(
    [
        {'$match':{'order_dow':2,'order_hour_of_day':{'$gte':8,'$lte':20},
                    'products.product_name':{'$regex':/soda/i}}},
        {'$group':{'_id':null,'number of orders':{'$sum':1}}}

    ]
)


/* counts the TOTAL(so '_id':null) number of individual soda PRODUCTS ordered on Tuesdays between 8 and 20. */
db.orders.aggregate(
    [
        {'$unwind':'$products'},
        {'$match':{'order_dow':2,'order_hour_of_day':{'$gte':8,'$lte':20},
                    'products.product_name':{'$regex':/soda/i}}},
        {'$group':{'_id':null,'number of products':{'$sum':1}}}

    ]
)


/* retrieve the orders submitted on Tuesday (order_dow = 2) between 8 and 20 where "soda" is ordered as first product in the cart (add_to_cart_order).
In this case, the regular expression requires that "soda" is exactly the value of product_name (case insensitive match).
In regular expressions:
^: represents the beginning of the field value
$: represents the end of the field value */
db.orders.find(
    {
        'order_dow':2,
        'order_hour_of_day':{'$gte':8,'$lte':20},
        'products':{'$elemMatch':{
            'add_to_cart_order':1,
            'product_name':{'$regex':/^soda$/i}
        }}
    },
    {
        "_id": 0, 
        "order_id": 1,
        "order_dow": 1,
        "order_hour_of_day": 1,
        "products.product_name.$": 1
    }
)


/* retrieve the orders in which both order_dow and order_hour_of_day are not provided */
db.orders.find(
    {
        '$and':[
            {'order_dow':{'$exists':false}},
            {'order_hour_of_day':{'$exists':false}}
        ]
    }
)


db.orders.find(
    {
        '$and':[
            {
                '$or':[
                        {'order_dow':null},
                        {'order_dow':{'$exists':false}}
                ]
            },
            {
                '$or':[
                    {'order_hour_of_day':null},
                    {'order_hour_of_day':{'$exists':false}}
                ]
            }
        ]
    }
)


/* remember the '$and' syntax. The value of $and must be an array of conditions thats why the have '$and':[]...
{
    "$and": [
        { <condition1> },
        { <condition2> },
        ...
    ]
}
*/

/* retrieve the number of orders by dow and sort the result by dow */
db.orders.aggregate(
    [
        {'$group':{'_id':'$order_dow','num of orders':{'$sum':1}}},
        {'$sort':{'_id':1}} // we have to sort by '_id' since the fild 'order_dow' does not exist anymore after the '$group'
    ]
)

/* retrieve the orders submitted on Monday (order_dow = 1) and for each of them, return the number of products. 
Sort the result by the number of products in descending order */
db.orders.aggregate(
    [
        {'$unwind':'$products'},
        {'$match':{'order_dow':1}},
        {'$group':{'_id':'$order_id','n of products':{'$sum':1}}},
        {'$sort':{'n of products':-1}}
    ]
)


/* unwind example
{ "order_id": 101, "products": ["apple", "banana", "mango"] }
{ "order_id": 102, "products": ["watermalon", "orange"] }

after unwind
{ "order_id": 101, "products": "apple" }
{ "order_id": 101, "products": "banana" }
{ "order_id": 101, "products": "mango" }

{ "order_id": 102, "products": "watermalon" }
{ "order_id": 102, "products": "orange" }

RESULT:
    { "order_id": 101, "number of poducts": 3 }
    { "order_id": 102, "number of poducts": 2 }

so by grouping by 'order_id' and the summing we count how many products we have
in each order
*/

/* alternative solution with $size */
db.orders.aggregate(
    [
        {"$match": {"order_dow": 1, "products": { "$type": "array" } } },
        {"$project": { "order_id": 1, "number of poducts": { "$size": "$products" } } }
    ])


/* a document in the result describes a beverage product with corresponding number of orders in which it is contained  */ 
db.orders.aggregate(
    [
        {'$unwind':'$products'},
        {'$match':{'products.department':'beverages'}},
        {'$group':{'_id':'$products.product_id','number of order':{'$sum':1}}}
    ]
)

/* retrieve the products of department "beverages" that have been ordered more than 100 times */
db.orders.aggregate(
    [
        {'$unwind':'$products'},
        {'$match':{'products.department':'beverages'}},
        {'$group':{'_id':'$products.product_id','# times ordered':{'$sum':1}}},
        {'$match':{'# times ordered':{'$gt':100}}}
    ]
)


/* for each order submitted on Monday (order_dow = 1), retrieve the number of products by aisle */
db.orders.aggregate(
    [
        {'$unwind':'$products'},
        {'$match':{'order_dow':1}},
        {'$group':{'_id':'$products.aisle_id','# products':{'$sum':1}}}
    ]
)


db.orders.aggregate(
    [
        {"$match": {"order_dow": 1 } },
        {"$unwind": "$products"},
        {"$group": {"_id": {"aid": "$products.aisle_id", "aname": "$products.aisle" }, "Number of products": { "$sum": 1 } } }
    ]
)


/* for each order submitted on Monday (order_dow = 1), retrieve the number of products and the average number of products per aisle */
db.orders.aggregate([
	{ "$unwind": "$products" },
	{ "$match": { "order_dow": 1} },
	{ "$group": { "_id": {"o_id": "$order_id", "a_id": "$products.aisle_id" }, "Number of products in aisle": { "$sum": 1 } } },
	{ "$group": { "_id": "$_id.o_id" , "Number of products": { "$sum": "$Number of products in aisle" }, "Avg number of products per aisle": { "$avg": "$Number of products in aisle" } } }
]);


