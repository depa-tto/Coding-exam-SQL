// How many orders were set on Tuesday at 12:00?
db.orders.find(
    {
        'order_dow':2,
        'order_hour_of_day':12
    }
).count()

// Count the total number of orders for each day of the week
db.orders.aggregate(
    [
        {'$group':{'_id':'$order_dow','#_orders':{'$sum':1}}},
        {'$sort':{'#_orders':-1}}
    ]
)

// Count the total number of orders for each day of the weekend (saturday, sunday)
db.orders.aggregate(
    [
        {'$match':{'$or':[{'order_dow':{'$gt':5}}, {'order_dow':null}]}},
        {'$group':{'_id':'$order_dow', '#_orders':{'$sum':1}}}
    ]
)

// Select the lists of products ordered by each user at each hour of day
// here '$push' creates an array containing the values of the products.product_name field for each group.
db.orders.aggregate(
    [
        {'$unwind':'$products'},
        {'$group':{'_id':{'user':'$user_id','hour':'$order_hour_of_day'},'orders':{'$push':'$products.product_name'}}},
        {'$project':{'_id':0, 'user_id':'$_id.user', 'order_hour':'$_id.hour', 'orders':1}}
    ]
)


// Retrieve the 10 aisles with most purchases at nighttime (from 9 pm to 6 am) 
db.orders.aggregate(
    [
        {'$match':{'$or':[{'order_hour_of_day':{'$gte':21}},{'order_hour_of_day':{'$lte':6}}]}},
        {'$unwind':'$products'},
        {'$group':{'_id':'$products.aisle_id','#_products':{'$sum':1}}},
        {'$project':{'_id':0,'aisle_id':'$_id','#_products':1}},
        {'$sort':{'#_products':-1}},
        {'$limit':10}
    ]
)


// Count the number of orders that contain at least 20 products
db.orders.aggregate(
    [
        {'$match':{'products':{'$type':'array'}}},
        {'$project':{'order_id':1, '#_products':{'$size':'$products'}}},
        {'$match':{'#_products':{'$gte':20}}},
        {'$group':{'_id':null, '#_orders':{'$sum':1}}}
    ]
)


// After using the $unwind operator on the products contained in order 473748, try to restore the original data.
db.orders.aggregate(
    [
        {"$match": {"order_id": 473748}},
        {"$unwind": "$products"},
        {"$group": {"_id": "$order_id", "products": { "$push": 
            {"product_id": "$products.product_id",
            "product_name": "$products.product_name",
            "aisle_id": "$products.aisle_id",
            "aisle": "$products.aisle",
            "department_id": "$products.department_id",
            "department": "$products.department",
            "add_to_cart_order": "$products.add_to_cart_order",
            "reordered": "$products.reordered"}}}}
    ]
)


// Select all order ids for user 1 and put them in a list
db.orders.aggregate(
    [
        {'$match':{'user_id':1}},
        {'$group':{'_id':'$user_id', 'orders':{'$push':'$order_id'}}}
    ]
)


//  How many orders contain both Tomatoes and Mozzarella?
db.orders.aggregate(
    [
        {'$unwind':'$products'},
        {'$match':{'$or':[{'products.product_name':{'$regex':/^Tomamto$/i}}, {'products.product_name':{'$regex':/^Mozzarella$/i}}]}},
        {'$group':{'_id':null, '#_orders':{'$sum':1}}}
    ]
)



// On average, how many products does an order include?
db.orders.aggregate(
    [
        {'$unwind':'$products'},
        {'$group':{'_id':'$order_id', '#_orders':{'$sum':1}}},
        {'$group':{'_id':null, 'avg_orders':{'$avg':'$#_orders'}}}
    ]
)


/* According to a traditional example in microeconomics, spirits and products for babies are complement products (positively correlated).
Get orders that contain at least one item of aisle "spirits" and one of aisle "diapers wipes" or "baby accessories" in the first 5 purchased items */
db.oredrs.aggregate(
    [
        {
            "$match": {
                "$and": [
                    {"products":{"$elemMatch": {"aisle":"spirits", "add_to_cart_order": {"$lte": 5}}}},
                    {"$or": [
                        {"products": {"$elemMatch": {"aisle":"diapers wipes", "add_to_cart_order": {"$lte": 5}}}},
                        {"products": {"$elemMatch": {"aisle":"baby accessories", "add_to_cart_order": {"$lte": 5}}}}
                    ]}
                ]
            }
        },
        {"$project":{"_id":"$order_id", "all_aisles":"$products.aisle"}},
        {"$sort":{"_id":1}}
    ]
)

