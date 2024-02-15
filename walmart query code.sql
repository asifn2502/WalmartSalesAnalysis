create database if not exists salesDataWalmart
create table if not exists sales(
invoice_id varchar(30) not null primary key,
branch varchar(5) not null,
city varchar(30) not null,
customer_type varchar(30) not null,
gender varchar(10) not null,
product_line varchar(100) not null,
unit_price decimal(10,2) not null,
quantity int not null,
VAT decimal(6,4) not null,
total decimal(12,4) not null,
date datetime not null,
time time not null,
payment_method varchar(15) not null,
cogs decimal(10,2) not null,
gross_margin_pct decimal(11,9),
gross_income decimal(12,4) not null,
rating decimal(2,1)
);
select * from sales;
----------------------------------------------------------------------------------
------------------------------------feature engineering-------------------------------
---time_of_day
select 
     time,
     (case
     when 'time' between "00:00:00" and "12:00:00" then "morning"
     when 'time' between "12:01:00" and "16:00:00" then "afternoon"
     else "evening"
     end
     ) as time_of_date
from sales;

alter table sales add column time_of_day varchar(20);

update sales
set time_of_day = (
	case
     when 'time' between "00:00:00" and "12:00:00" then "morning"
     when 'time' between "12:01:00" and "16:00:00" then "afternoon"
     else "evening"
     end
);

--day_name

select date,DAYNAME(date) as day_name from sales;

alter table sales add column day_name varchar(10);
update sales set day_name = DAYNAME(date);

---month_name

select date,MONTHNAME(date) from sales;

alter table sales add column month_name varchar(10);
update sales set month_name = MONTHNAME(date);


----------- --------------------------------------------------------------------------------------
--------------------- --------------------Generic-------------------------------------------------

---How many unique cities does the data have?

select distinct city from sales;

----In which city is each branch?

select distinct branch from sales;

select distinct city,branch from sales;

-----------------------------------------------------------------------------------------------------------------
------------------------ product-------------------------------------------------------------------------------
---How many unique product lines does the data have?

select count(distinct product_line) from sales;

----What is the most common payment  method?

select payment_method,count(payment_method) as cnt from sales
group by payment_method
order by cnt DESC; 

---what is the most selling product line?
select product_line,count(product_line) as cnt from sales
group by product_line
order by cnt DESC;

-----what is the total revenue by month?

select month_name as month,
sum(total) as total_revenue from sales
group by month_name
order by total_revenue DESC;

----what month had the largest COGS?
select month_name as month,
sum(cogs) as cogs from sales
group by month_name
order by cogs DESC;

----what product line had the largest revenue?

select product_line,sum(total) as total_revenue from sales
group by product_line
order by total_revenue DESC;

--- what is the city with the largest revenue?

select branch,city,sum(total) as total_revenue from sales
group by city,branch
order by total_revenue DESC;

---what product line had the largest VAT?

select product_line,avg(VAT) as avg_tax from sales
group by product_line
order by avg_tax DESC;

--which branch sold more products than average product sold?

select branch,sum(quantity) as qty from sales 
group by branch
having sum(quantity) > (select avg(quantity) from sales);

---what is the most common product line by gender?

select gender,product_line,count(gender) as total_cnt from sales
group by gender,product_line
order by total_cnt desc;

---what is the average rating of each product line?

select round(avg(rating),2) as avg_rating,product_line from sales
group by product_line
order by avg_rating DESC;

-- ---------------------------------------------------------------------------------------------------------------------------
-- -------------------------------sales--------------------------------------------------------------------------------

--number of sales in each time of the day per weekday?

select time_of_day,count(*) as total_sales from sales
where day_name = "monday"
group by time_of_day
order by total_sales desc;

---which of the customer types brings the most revenue?

select customer_type,sum(total) as total_rev from sales
group by customer_type
order by total_rev desc;

---which city has the largest tax percent/VAT(value added tax)?

select city,avg(VAT) as VAT from sales
group by city
order by VAT desc;

--which customer type pays the most in VAT?
select customer_type,avg(vat) as VAT from sales
group by customer_type
order by VAT desc;

-- -----------------------------------------------------------------------------------------------------------------------
-- -----------------------------customers--------------------------------------------------------------------------------
---how many unique customer types does the data have?
select distinct customer_type from sales;

--how may unique payment method does the data have?
select distinct payment_method from sales;

--which customer type buys the most?
select customer_type,count(*) as cstm_cnt from sales
group by customer_type;

---what is the gender of most of the customer?
select gender,count(*) as gender_cnt from sales
group by gender
order by gender_cnt desc;

---what is the gender distributation per branch?
select gender,count(*) as gender_cnt from sales
where branch = "B"
group by gender
order by gender_cnt desc;

---which time of the day do customers give most rating?
select time_of_day,AVG(rating) as avg_rating from sales
group by time_of_day
order by avg_rating desc;

---which time of the day do customer give most rating per branch?
select time_of_day,AVG(rating) as avg_rating from sales
where branch = "A"
group by time_of_day
order by avg_rating desc;

---which day do the week has the best avg ratings?
select day_name,
avg(rating) as avg_rating from sales
group by day_name
order by avg_rating desc;

---which day do the week has the most best average rating per branch?
select day_name,AVG(rating) as avg_rating from sales
where branch = "A"
group by day_name
order by avg_rating desc;

-- ----------------------Revenue and Profit calculation---------------
-- -------------------------------------------------------------
-- -calculate cogs?

SELECT unit_price, quantity, unit_price * quantity AS COGS
FROM sales;

--calculate VAT?

SELECT unit_price, quantity, unit_price * quantity AS COGS, (unit_price * quantity) * 0.05 AS VAT
FROM sales;

-- --

