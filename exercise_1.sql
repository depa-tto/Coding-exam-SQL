-- Retrieve the order_id and the product_name for each order submitted on Monday (order_dow = 1)
select op.order_id, p.product_name
from order_products op inner join products p on op.product_id = p.product_id
    inner join orders o on o.order_id = op.order_id
where o.order_dow = 1;


-- SAME AS ABOVE BUT WITHOUT INNER JOIN


-- Retrieve the order_id and the name of products that are added as first in the cart of each order (add_to_cart_order = 1)


-- Retrieve the order_id and the product_name for each order submitted between the hours 15 and 17


-- Retrieve the id of orders where the first product added to the cart is the same as the one in the order_id = 2411567



-- Retrieve the name of products that are ordered on Monday (order_dow = 1) from the coffee aisle. Sort the result by the product name


-- Retrieve the id of products that are never ordered on Tuesday (order_dow = 2)



-- Retrieve the id of products from the coffee aisle that are never ordered on Tuesday (order_dow = 2)


-- Retrieve the average number of products for each order
-- HINT: create a view with product counts for each order as intermediate step


-- For each department, retrieve the number of ordered products.
-- Show the department_name in the result.
-- Sort the result by the number of products in descending order


-- Refine the previous query by returning only the departments with more than 1M of ordered products




-- For each product in the coffee aisle, retrieve the number of orders submitted on Tuesday (order_dow = 2).
-- Include the products that are never ordered in the result (if they exist)


-- Retrieve the id of users that submitted orders on BOTH Monday (order_dow = 1) and Tuesday (order_dow = 2).

