-- Challenge #2: Price Tier Market Segmentation
-- Classify listings into Budget/Mid-Range/Premium/Luxury and analyze each segment

select case
        when price <= 300 then 'Budget'
        when price > 300 and price <= 600 then 'Mid-Range'
        when price > 600 and price <= 900 then 'Premium'
        else 'Luxury'
    end as price_range,
    round((count(distinct "id")*100.0) / (select count(*) from listings), 2) as market_share,
    count(distinct "id") as total_listings,
    round(avg(price)::numeric, 2) as avg_price,
    round(avg("review rate number")::numeric, 1) as avg_review,
    round(avg("minimum nights")::numeric, 1) as avg_min_nights,
    round(avg("availability 365")::numeric, 1) as avg_availability
from listings
group by price_range
order by avg_price
