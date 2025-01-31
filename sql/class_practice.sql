-- retrive the order_id and the product_name for each order submitted on mondey
select p.product_name, op.order_id
from products p inner join order_products op on p.product_id = op.product_id 
    inner join orders o on o.order_id = op.order_id
where o.order_dow = 1;

-- retrive the order_id and the name of products that are added as first in the cart of each order
select p.product_name, op.order_id, op.add_to_cart_order
from products p inner join order_products op on p.product_id = op.product_id
where op.add_to_cart_order = 1;


-- retrive the id of orders where the first product added to the cart is the same as the one in the oder_id = 2411567
-- nested query
select order_id
from order_products
where add_to_cart_order=1 and product_id in (
    select product_id
    from order_products
    where order_id = 2411567 and add_to_cart_order=1
);


-- self join
select op1.order_id
from order_products op1 inner join order_products op2 on op1.product_id = op2.product_id
where op2.order_id = 2411567 and op1.add_to_cart_order = 1 and op2.add_to_cart_order = 1;


-- cte
with first_item as (
    select product_id
    from order_products
    where order_id = 2411567 and add_to_cart_order = 1
)
select op.order_id
from order_products op, first_item fi
where add_to_cart_order = 1 and op.product_id = fi.product_id;


-- retrive the id of products that are never ordered on tuesday
select product_id -- remember to select all the products not only the ones in the order_products sub-table
from products
EXCEPT
select distinct op.product_id
from order_products op inner join orders o on o.order_id = op.order_id
where o.order_dow = 2;


select product_id 
from products
where product_id not in (
    select distinct op.product_id
    from order_products op inner join orders o on o.order_id = op.order_id
    where o.order_dow = 2
);



-- retrive the average number of products in the orders
with order_count as (select count(product_id) as product_count
from order_products
group by order_id)
select avg(product_count)
from order_count;


-- For each department, retrieve the number of ordered products.
-- Show the department_name in the result.
-- Sort the result by the number of products in descending order
select count(op.product_id), d.department
from products p inner join departments d on p.department_id = d.department_id
    inner join order_products op on op.product_id = p.product_id
group by p.department_id,  d.department
order by 1 desc;


-- departments(department_id, department)
-- aisles(aisle_id, aisle)
-- products(product_id, product_name, aisle_id, department_id)
-- orders(order_id, user_id, order_number, order_dow, order_hour_of_day, days_since_prior_order)
-- order_products(order_id, product_id, add_to_cart_order, reordered)

-- tick the statement that cannot generate an error
A. DELETE FROM aisles WHERE aisle_id = 5;
B. DELETE FROM departments WHERE department_id = 8;
C. UPDATE aisles SET aisle_id = 4 WHERE aisle_id = 5;
D. UPDATE departments SET department_id = 7 WHERE department_id = 8;
E. UPDATE departments SET department = 'data science' WHERE department_id = 8; -- correct answer


-- tick the statement that generates an error
A. DELETE FROM order_products WHERE order_id = 5;
B. DELETE FROM products WHERE product_id = 8292;
C. DELETE FROM orders WHERE order_id = 4848; -- correct answer
D. DELETE FROM order_products WHERE product_id = 0494;
