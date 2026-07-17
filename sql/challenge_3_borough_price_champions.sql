-- Challenge #3: Borough Price Champions
-- Top 3 highest-priced neighborhoods per borough (minimum 50 listings)

WITH neighborhood_stats AS (
    SELECT 
        "neighbourhood group" AS borough,
        "neighbourhood",
        ROUND(AVG("price")::numeric, 2) AS avg_price,
        COUNT(DISTINCT "id") AS total_listings,
        ROUND(AVG("review rate number")::numeric, 1) AS avg_review
    FROM listings
    WHERE "neighbourhood group" IS NOT NULL
    GROUP BY "neighbourhood group", "neighbourhood"
    HAVING COUNT(DISTINCT "id") >= 50
),
ranked_neighborhoods AS (
    SELECT 
        borough,
        DENSE_RANK() OVER(PARTITION BY borough ORDER BY avg_price DESC) AS borough_rank,
        neighbourhood,
        avg_price,
        total_listings,
        avg_review
    FROM neighborhood_stats
)
SELECT * 
FROM ranked_neighborhoods
WHERE borough_rank <= 3
ORDER BY borough, borough_rank;
