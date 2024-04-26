-- Write SQL queries to answer these questions using the data you have loaded into your database/data warehouse:
--I have tried to attempt the Python and SQL challenge using SQL queries only.
--I do not have evidence to support by SQL queries for this challenge because I could not create the ETL/ELT pipeline using python.

-- 1. Find the top 5 users that post the longest posts (excl. the post title).
select
    u."name" as actual_name
    ,u."username" as user_name
    ,length(p."body") as length_of_posts
from users u
    join posts p on u."id" = p."userId"
order by length(p."body")
limit 5
;
-- 2. For each of these top 5 users, calculate their average post length (incl. the post title).
select
    u."userId" as userid
    ,u."username" as user_name
    ,length(p."body") as length_of_posts
    ,avg(length(p.body)+length(p.title)) as avg_post_length
from users u
    join posts p on u."id" = p."userId"
group by u."userId"
order by avg(length(p.body)+length(p.title)) desc
limit 5
;
-- 3. Identify the day of the week when the most `lengthy` posts are created (mock date using the `id` of posts as the day offset from the UNIX epoch).
**Unattempted**

--I could successfully download the CSV file and have evidence to support my SQL queries

-- 1. Retrieve total sales revenue, number of units sold, and average price per unit for each item type for the first quarter of 2017.
select 
    t."Item Type" as "Item Type" 
    ,sum(t."Total Revenue") as total_sales_revenue 
    ,count(t."Units Sold") as units_sold 
    ,avg("Unit Price") as average_price_per_unit 
from  ps_table t  
    where (t."Order Date" >= '2017-01-01' 
        and t."Order Date" <= '2017-03-31') 
group by t."Item Type"
;

-- 2. Identify the top 3 item types by sales revenue for each region in the last quarter.
with rank_sales as (
    select 
        t."Region"
        ,t."Item Type"
        ,sum(t."Total Revenue") as total_sales_revenue
        ,RANK() over (partition by t."Region" order by sum(t."Total Revenue") desc) as sales_rank
    from ps_table t
    where t."Order Date" between '2017-01-01' and '2017-03-31'
    group by t."Region", t."Item Type"
)
select 
    r."Region"
    ,r."Item Type"
    ,r.total_sales_revenue
    ,r.sales_rank
from rank_sales r
where r.sales_rank <= 3    --to get top 3 ranks only
;

-- 3. Calculate the year-over-year growth in sales revenue for each item type.
with Date_Year as (
    select 
    strftime('%Y', t."Order Date") as final_year  --to extract the year from the date
    ,t."Item Type"
    ,t."Total Revenue"
    from ps_table t
)
select 
    d.final_year
    ,d."Item Type"
    ,d."Total Revenue"
    ,LAG(d."Total Revenue", 1) OVER (partition by d."Item Type" order by d.final_year) as Previous_Year_Revenue
    ,round(((d."Total Revenue" - LAG(d."Total Revenue", 1) OVER (partition by d."Item Type" order by d.final_year)) / LAG(d."Total Revenue", 1) OVER (partition by d."Item Type" order by d.final_year)) * 100,2) as YoY_Growth_percent
from 
    Date_Year d
group by d."Item Type"
        ,d.final_year
;