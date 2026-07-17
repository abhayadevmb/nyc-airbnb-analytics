-- Challenge #1: Neighborhood Investment Radar
-- Top 10 neighborhoods by average nightly price (minimum 100 listings)

select "neighbourhood",
       "neighbourhood group",
       round(avg("price")::numeric, 2) as avg_nightly_price,
       count(distinct id) as total_listings,
       round(avg("review rate number")::numeric, 1) as avg_review
from listings
where "neighbourhood group" is not null
group by "neighbourhood", "neighbourhood group"
having count(distinct id) >= 100
order by avg_nightly_price desc
limit 10
