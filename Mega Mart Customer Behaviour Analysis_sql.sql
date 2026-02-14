select * from customer

select gender, sum(purchase_amount) as revenue
from customer
group by gender;

--Q. which customers used a discount but still spent more than the avg purchase amount.

select customer_id, purchase_amount
from customer
where discount_applied = 'Yes' and
purchase_amount >= (select avg(purchase_amount) from customer);

--Q. which are  the top 5 products with the highest average review rating.

select item_purchased, ROUND(AVG(review_rating)::numeric, 2) AS avg_rating
from customer
group by item_purchased
order by avg(review_rating) desc
limit 5

--Q. compare avg purchase amounts between standard and express shipping

select shipping_type,round(avg(purchase_amount),2) as avg_purchase_amt
from customer
group by shipping_type
having shipping_type in ('Express','Standard')

---Q. Do susbscribed customers spend more? compare avg spend and total revenue between subscribers and non-subscribers.

select subscription_status,count(customer_id) as total_customer, 
round(avg(purchase_amount),2) as avg_spend, sum(purchase_amount) as total_rev
from customer
group by subscription_status
order by total_rev, avg_spend desc;

--Q. which 5 products have the highest percent of purchases with discounts applied?

select item_purchased, 
100*sum(case when discount_applied = 'Yes' then 1 else 0 end)/count(*) as discount_rate
from customer
group by item_purchased
order by discount_rate desc
limit 5;


--Q. segment customers into new, returning, and loyal based on their total
--number of previous pruchases and showth ecount of each segment

with customer_type as(
select customer_id, previous_purchases,
case
    when previous_purchases=1 then 'new customer'
	when previous_purchases between 1 and 10 then 'returning customer' 
	else 'loyal customer'
    end as customer_segment
from customer
)

select customer_segment, count(*) as no_of_cus
from customer_type
group by customer_segment

Q. top 3 purchased products within each category

with cte as(
select category, item_purchased, count(customer_id) as total_orders,
row_number() over(partition by category order by count(customer_id) desc) as rn
from customer
group by category, item_purchased
)
select rn, category, item_purchased, total_orders
from cte
where rn<=3

--Q. are customrs who are repeat buyers (more than 5 previous purchases) also likely to subscribe?

select subscription_status,count(customer_id) as repeat_buyers
from customer
where previous_purchases >5
group by subscription_status

--QQ. what is the revenue contribution of each age group?
select * from customer

select age_group, sum(purchase_amount) as revenue
from customer
group by age_group
order by revenue desc;












