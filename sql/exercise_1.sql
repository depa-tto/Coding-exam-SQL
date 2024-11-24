-- Retrieve the order_id and the product_name for each order submitted on Monday (order_dow = 1)
select op.order_id, p.product_name
from order_products op inner join products p on op.product_id = p.product_id
    inner join orders o on o.order_id = op.order_id
where o.order_dow = 1;

-- SAME AS ABOVE BUT WITHOUT INNER JOIN
select op.order_id, product_name
from order_products op, products p
where op.order_id in (
    select o.order_id
    from orders o
    where order_dow = 1
) and op.product_id = p.product_id;

-- Retrieve the order_id and the name of products that are added as first in the cart of each order (add_to_cart_order = 1)
select op.order_id, p.product_name, op.add_to_cart_order
from order_products op inner join products p on op.product_id = p.product_id
where op.add_to_cart_order = 1;


-- Retrieve the order_id and the product_name for each order submitted between the hours 15 and 17
select op.order_id, p.product_name, o.order_hour_of_day
from order_products op inner join products p on op.product_id = p.product_id
    inner join orders o on o.order_id = op.order_id
where o.order_hour_of_day in (15,16,17);


-- Retrieve the id of orders where the first product added to the cart is the same as the one in the order_id = 2411567
select op1.order_id
from order_products op1 inner join order_products op2 on op1.product_id = op2.product_id 
where op2.order_id = 2411567 and op1.add_to_cart_order = 1 and op2.add_to_cart_order = 1;
 

-- Retrieve the name of products that are ordered on Monday (order_dow = 1) from the coffee aisle. Sort the result by the product name
select distinct p.product_name, a.aisle, o.order_dow
from products p inner join order_products op on p.product_id = op.product_id
    inner join orders o on o.order_id = op.order_id 
        inner join aisles a on a.aisle_id = p.aisle_id
where o.order_dow = 1 and a.aisle = 'coffee'
order by 1;

-- Retrieve the id of products that are never ordered on Tuesday (order_dow = 2)
select p.product_id
from products p
EXCEPT
select distinct op.product_id
from order_products op inner join orders o on op.order_id = o.order_id
where o.order_dow = 2;


select p.product_id
from products p 
where p.product_id not in (
    select distinct op.product_id
    from order_products op inner join orders o on op.order_id = o.order_id
    where o.order_dow = 2
);

-- Retrieve the id of products from the coffee aisle that are never ordered on Tuesday (order_dow = 2)
select p.product_id
from products p inner join aisles a on p.aisle_id = a.aisle_id
where a.aisle = 'coffee'
EXCEPT
select distinct op.product_id
from order_products op inner join orders o on op.order_id = o.order_id
where o.order_dow = 2;

select p.product_id
from products p inner join aisles a on p.aisle_id = a.aisle_id
where a.aisle = 'coffee' and p.product_id not in (
    select distinct op.product_id
    from order_products op inner join orders o on op.order_id = o.order_id
    where o.order_dow = 2
);



-- Retrieve the average number of products for each order
-- HINT: create a view with product counts for each order as intermediate step
select avg(p_count)
from (
    select count(op.product_id) as "p_count"
    from order_products op
    group by op.order_id
) as product_counts;

with product_counts as (
    select count(op.product_id) as p_count
    from order_products op
    group by op.order_id
)
select avg(product_counts.p_count)
from product_counts;

-- For each department, retrieve the number of ordered products.
-- Show the department_name in the result.
-- Sort the result by the number of products in descending order
select count(op.product_id), d.department
from departments d inner join products p on d.department_id = p.department_id
    inner join order_products op on op.product_id = p.product_id
group by d.department_id, d.department
order by 1 desc;

-- Refine the previous query by returning only the departments with more than 100 000 of ordered products
select count(op.product_id), d.department
from departments d inner join products p on d.department_id = p.department_id
    inner join order_products op on op.product_id = p.product_id
group by d.department_id, d.department
having count(op.product_id) > 100000
order by 1 desc;



-- For each product in the coffee aisle, retrieve the number of orders submitted on Tuesday (order_dow = 2).
-- Include the products that are never ordered in the result (if they exist)
select count(o.order_id), p.product_id, p.product_name
from products p inner join aisles a on p.aisle_id = a.aisle_id
    left join order_products op on op.product_id = p.product_id
        left join orders o on o.order_id = op.order_id and o.order_dow = 2 
where lower(a.aisle) = 'coffee' 
group by p.product_id, p.product_id, p.product_name;

-- Retrieve the id of users that submitted orders on BOTH Monday (order_dow = 1) and Tuesday (order_dow = 2).
select user_id
from orders
where order_dow = 1 
INTERSECT
select distinct user_id
from orders
where order_dow = 2;


select distinct o1.user_id
from orders o1 inner join orders o2 on o1.user_id = o2.user_id
where o1.order_dow = 1 and o2.order_dow = 2



-----------------------------------------------------------------------------------------------------------------------------------

--Given those schema answer the question
create table aisles (
    aisle_id integer primary key,
    aisle    varchar(50)
);

create table departments (
    department_id integer primary key,
    department    varchar(15)
);

create table products (
    product_id    integer primary key,
    product_name  varchar(300),
    aisle_id      integer references aisles(aisle_id),
    department_id integer references departments(department_id) ON UPDATE CASCADE ON DELETE CASCADE
);

create table orders (
    order_id               integer primary key,
    user_id                integer,
    order_number           integer,
    order_dow              integer,
    order_hour_of_day      integer,
    days_since_prior_order real
);

create table order_products (
    order_id          integer references orders(order_id),
    product_id        integer references products(product_id),
    add_to_cart_order integer,
    reordered         integer,
    primary key (order_id, product_id)
);

-- tick the statement that generates an error
DELETE FROM order_products WHERE order_id = 5; -- No error
DELETE FROM products WHERE product_id = 8292;  -- Error -> no action in order_products
DELETE FROM orders WHERE order_id = 4848; -- Error -> no action in order_products
DELETE FROM order_products WHERE product_id = 0494; -- No error


-- tick the statement that cannot generate an error
DELETE FROM aisles WHERE aisle_id = 5; --Error: missing cascade on products
DELETE FROM departments WHERE department_id = 8; --Error in order_products (delete department -> cascade on products -> no action order_products
UPDATE aisles SET aisle_id = 4 WHERE aisle_id = 5; -- Can generate an error if id already exists and in products table
UPDATE departments SET department_id = 7 WHERE department_id = 8; -- Can generate an error if id already exists
UPDATE departments SET department = 'data science' WHERE department_id = 8; -- NO ERROR