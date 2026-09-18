------------------------------------------- pizzhut project------------------------------------------------------------------------------------------------



 --Q1.  Retrieve the total number of orders placed.?


 SELECT COUNT(order_id)as total_orders FROM orders


 --Q2.Calculate the total revenue generated from pizza sales.
 select * from pizzas 
 select * from order_details


 select  round(sum  (order_details.quantity * pizzas.price), 2) as total_revenue
 from order_details join pizzas 
 on  order_details . pizza_id = pizzas. pizza_id


 --Q3.Identify the highest-priced pizza.
 select  * from pizza_types
 select * from pizzas
 select top 1  pizza_types.name , pizzas.price 
 from pizza_types join pizzas 
 on pizza_types.pizza_type_id = pizzas.pizza_type_id
 order by  pizzas.price desc 


-- Q5.Identify the most common pizza size ordered.
select quantity , count(order_details_id) as order_details from  order_details
group by quantity

select pizzas.size ,count(order_details.order_details_id) as order_count
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size order by order_count desc



-----------------------------------------------------------------------------
select pizzas.size ,count(order_details.quantity) as order_count
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size order by order_count desc

--Q6.List the top 5 most ordered pizza types along with their quantities.

 select top (5) pizza_types.name  ,sum(order_details.quantity) as total_quanties
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name order by total_quanties desc

-----------------------------------------------------Intermediate:-----------------------------------------------------------------------
--Q7.Join the necessary tables to find the total quantity of each pizza category ordered.

select pizza_types.category,  sum(order_details.quantity) as total_quantity from 
pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id
join pizza_types 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
group  by pizza_types.category 

--Q8.Determine the distribution of orders by hour of the day.

select datepart (hour ,time) as order_hour, count(order_id)as total_orders from orders
group by datepart (hour ,time)
order by total_orders desc	


--Q9.Join relevant tables to find the category-wise distribution of pizzas.
select category , count(name)as total_type from pizza_types
group by category




--Q10.Group the orders by date and calculate the average number of pizzas ordered per day.


select avg (quantity) as per_day_avg from
(select  orders.date , sum (order_details.quantity ) as quantity from 
orders join  order_details 
on orders.order_id = order_details.order_id
group by date) as order_quantity





--Q11.Determine the top 3 most ordered pizza types based on revenue.
 
select top (3) pizza_types.name,sum (pizzas.price* order_details.quantity) as total_revenue from 
pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id
join pizza_types
on pizzas.pizza_type_id = pizza_types.pizza_type_id
group by name
order by total_revenue desc




--------------------------------------------Advanced:-------------------------------------------------------------------------------
--Q12.Calculate the percentage contribution of each pizza type to total revenue.
select  pizza_types.category,round(sum (pizzas.price* order_details.quantity)/ (select sum  (order_details.quantity * pizzas.price) 
 from order_details join pizzas 
 on  order_details . pizza_id = pizzas. pizza_id)*100,2)
as total_revenue from 
pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id
join pizza_types
on pizzas.pizza_type_id = pizza_types.pizza_type_id
group by category
order by total_revenue desc
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
with pizza_category as (
select pizza_types.category,sum(pizzas.price*order_details.quantity) as total_revenue
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id
join pizza_types
on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by category 
),
total_revenue as(
 select  round(sum  (order_details.quantity * pizzas.price), 2) as total_revenue
 from order_details join pizzas 
 on  order_details . pizza_id = pizzas. pizza_id
) 
select pizza_category.category , pizza_category.total_revenue ,round((pizza_category.category/total_revenue.total_revenue)*100,2) as p
from pizza_category 
cross join total_revenue

--Q13.Analyze the cumulative revenue generated over time.
select date,sum(total_revenue) over (order by date) as cum_revenue from
(select orders.date ,
sum(pizzas.price * order_details.quantity) as total_revenue from pizzas
join order_details
 on order_details.pizza_id = pizzas.pizza_id
 join orders 
 on orders.order_id = order_details.order_id
 group by date) as sales


--Q14.Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select name , revenue ,category from  
(select category ,name, revenue ,
rank() over(partition by category order by revenue desc ) as rn 
from 
(select pizza_types.category , pizza_types.name,sum((order_details.quantity)*pizzas.price) as revenue 
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id 
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category , pizza_types.name) as a) as b 
where rn <= 3





WITH pizza_category AS (
    SELECT 
        pt.category,
        SUM(p.price * od.quantity) AS category_revenue
    FROM order_details od
    JOIN pizzas p
        ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt
        ON pt.pizza_type_id = p.pizza_type_id
    GROUP BY pt.category
),
total_revenue AS (
    SELECT 
        SUM(od.quantity * p.price) AS total_rev
    FROM order_details od
    JOIN pizzas p 
        ON od.pizza_id = p.pizza_id
)
SELECT 
    pc.category,
    pc.category_revenue,
    ROUND((pc.category_revenue / tr.total_rev) * 100, 2) AS percentage_contribution
FROM pizza_category pc
CROSS JOIN total_revenue tr;