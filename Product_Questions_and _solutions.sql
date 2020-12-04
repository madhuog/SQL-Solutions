
# 1. Join all the tables and create a new table called combined_table.
#    (market_fact, cust_dimen, orders_dimen, prod_dimen, shipping_dimen)

create table combined_all as (
select product_category,product_sub_category,p.prod_id,
       o.order_id,order_date,order_priority,o.ord_id,
       c.cust_id,customer_name,Province,Region,Customer_segment,
       ship_mode,ship_date,s.ship_id,
       sales,discount,Order_quantity,profit,shipping_cost,product_base_margin
from cust_dimen c 
join market_fact m on c.cust_id = m.cust_id
join orders_dimen o on m.ord_id=o.ord_id
join shipping_dimen s on s.order_id=o.order_id
join prod_dimen p on p.prod_id=m.prod_id
);

select * from combined_all
order by prod_id;



#   2. Find the top 3 customers who have the maximum number of orders

select c.*,m.number_of_orders  from cust_dimen c,
(select cust_id,count(distinct(ord_id)) as number_of_orders from market_fact group by cust_id) m
where c.cust_id=m.cust_id
order by number_of_orders desc
limit 3;



#  3. Create a new column DaysTakenForDelivery that contains the date difference of Order_Date and Ship_Date.

select  o.order_id,order_date,ship_date,datediff(ship_date,order_date) as DaysTakenForDelivery
 from orders_dimen o 
inner join shipping_dimen s on o.order_id=s.order_id
order by DaysTakenForDelivery desc;


#  4. Find the customer whose order took the maximum time to get delivered.

select  c.cust_id,c.customer_name,o.order_id,order_date,ship_date,
		datediff(ship_date,order_date) as DaysTakenForDelivery
from orders_dimen o 
inner join shipping_dimen s on o.order_id=s.order_id 
inner join market_fact m on s.ship_id=m.ship_id
inner join cust_dimen c on c.cust_id=m.cust_id
where datediff(ship_date,order_date) in 
(select max(datediff(ship_date,order_date)) from orders_dimen o 
inner join shipping_dimen s on o.order_id=s.order_id);


#  5. Retrieve total sales made by each product from the data (use Windows function)

select distinct m.Prod_id,Product_Category,Product_Sub_Category,
       round(sum(sales) over( partition by Prod_id),2) as total_sales 
from market_fact m
inner join prod_dimen p on m.Prod_id=p.Prod_id
order by total_sales desc; 


#   6. Retrieve total profit made from each product from the data (use windows function)

select distinct m.prod_id,Product_Category,Product_Sub_Category,
				round(sum(profit) over (partition by prod_id),2) as total_profit
from market_fact m 
inner join prod_dimen p on m.prod_id=p.prod_id
order by total_profit desc;        


#   7. Count the total number of unique customers in January and how many of them came back every month over the entire year in 2011

select distinct cust_id from combined_all
where month(order_date)=1 and year(order_date)=2011
and cust_id in (select distinct cust_id from combined_all where month(order_date)=2 and year(order_date)=2011)
and cust_id in (select distinct cust_id from combined_all where month(order_date)=3 and year(order_date)=2011)
and cust_id in (select distinct cust_id from combined_all where month(order_date)=4 and year(order_date)=2011)
and cust_id in (select distinct cust_id from combined_all where month(order_date)=5 and year(order_date)=2011)
and cust_id in (select distinct cust_id from combined_all where month(order_date)=6 and year(order_date)=2011)
and cust_id in (select distinct cust_id from combined_all where month(order_date)=7 and year(order_date)=2011)
and cust_id in (select distinct cust_id from combined_all where month(order_date)=8 and year(order_date)=2011)
and cust_id in (select distinct cust_id from combined_all where month(order_date)=9 and year(order_date)=2011)
and cust_id in (select distinct cust_id from combined_all where month(order_date)=10 and year(order_date)=2011)
and cust_id in (select distinct cust_id from combined_all where month(order_date)=11 and year(order_date)=2011)
and cust_id in (select distinct cust_id from combined_all where month(order_date)=12 and year(order_date)=2011);


#   8. Retrieve month-by-month customer retention rate since the start of the business.(using views)

create view month_by_month_vw as 
(
);