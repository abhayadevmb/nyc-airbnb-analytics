-- Challenge #4: The Commercial Host Syndicate (Mega-Hosts)
-- Identify the top 5 largest host operations by total listings

select "host name",
  count(distinct id) total_listings,
  count(distinct "neighbourhood group") boroughs_operated_in,
  round(avg(price)::numeric, 2) avg_price,
  round(sum(price)::numeric, 2) daily_revenue
from listings l
group by "host name"
order by total_listings desc
limit 5;
