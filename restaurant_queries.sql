-- 1 obj EXPLORE THE ITEM TABLE
select *
from menu_items;

select count(*)
from menu_items;

select *
from menu_items
order by price;

select *
from menu_items
order by price desc;

select *
from menu_items
where category = 'Italian';

select *
from menu_items
where category = 'Italian'
order by price;

select category, count(menu_item_id) as num_dishes
from menu_items
group by category;

select category, avg(price) as avg_price
from menu_items
group by category;

-- 2 obj EXPLORE THE ORDERS TABLE
select *
from order_details;

select min(order_date), max(order_date)
from order_details;

select count(distinct order_id) as num_orders
from order_details;

select count(*) as num_orders
from order_details;

select order_id, count(item_id) as num_dishes
from order_details
group by order_id
order by num_dishes desc;

-- how many orders that have >12 items in the order
select count(*)
from (select order_id, count(item_id) as num_dishes
      from order_details
      group by order_id
      having count(item_id) > 12) as num_orders;

-- 3 obj ANALYZE CUSTOMER BEHAVIOR
select *
from order_details od
         left join menu_items mi
                   on od.item_id = mi.menu_item_id;

select item_id, count(*) as num_purchases
from order_details od
         left join menu_items mi
                   on od.item_id = mi.menu_item_id
group by item_id;

select item_id, category, count(*) as num_purchases
from order_details od
         left join menu_items mi
                   on od.item_id = mi.menu_item_id
group by item_id, category
order by count(*) desc;

-- top 5 orders that spent the most money
select order_id, sum(price)
from order_details od
         left join menu_items mi
                   on od.item_id = mi.menu_item_id
group by order_id
order by sum(price) desc
limit 5;

select category, count(*)
from order_details od
         left join menu_items mi
                   on od.item_id = mi.menu_item_id
where order_id = 440
group by category;

select order_id, category, count(*)
from order_details od
         left join menu_items mi
                   on od.item_id = mi.menu_item_id
where order_id in (440, 2075, 1957, 330, 2675)
group by order_id, category
order by order_id;