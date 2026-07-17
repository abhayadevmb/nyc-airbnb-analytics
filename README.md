# NYC Airbnb Analytics

> [!WARNING]
> WORK IN PROGRESS — Database configuration, raw GUI-driven ingestion, cleaning, and the core visualization assets are complete. Next steps focus on advanced analytical queries and dashboarding.

## Overview
This repository analyzes 102,024 raw NYC Airbnb listing rows covering geospatial, financial, and host-related attributes. The workflow uses PostgreSQL for storage and Python for cleaning, transformation, and exploratory analysis.

## Tech Stack
- PostgreSQL 18
- pgAdmin 4
- DBeaver Enterprise
- Python 3 with Pandas, NumPy, Matplotlib, and Seaborn

## Database Schema
```sql
CREATE TABLE nyc_airbnb_raw (
    "id" BIGINT,
    "NAME" TEXT,
    "host id" BIGINT,
    "host_identity_verified" TEXT,
    "host name" TEXT,
    "neighbourhood group" TEXT,
    "neighbourhood" TEXT,
    "lat" DOUBLE PRECISION,
    "long" DOUBLE PRECISION, 
    "country" TEXT,
    "country code" TEXT,
    "instant_bookable" TEXT,
    "cancellation_policy" TEXT,
    "room type" TEXT,
    "Construction year" DOUBLE PRECISION, 
    "price" DOUBLE PRECISION,
    "service fee" DOUBLE PRECISION,
    "minimum nights" DOUBLE PRECISION,
    "number of reviews" DOUBLE PRECISION,
    "last review" TEXT,
    "reviews per month" DOUBLE PRECISION,
    "review rate number" DOUBLE PRECISION,
    "calculated host listings count" DOUBLE PRECISION,
    "availability 365" DOUBLE PRECISION,
    "house_rules" TEXT
);
```

## Data Cleaning Pipeline
- Imputed missing values using targeted median and mode strategies for operational columns.
- Cleaned the `price` and `service fee` fields by removing `$` symbols and commas before casting them to numeric types.
- Standardized text naming conventions, whitespace, and casing for fields such as `host_identity_verified` and `neighbourhood group`.
- Normalized mixed date delimiters in `last review` into uniform ISO dates in `YYYY-MM-DD` format.

## Exploratory Analysis
The notebook in [notebooks/eda.ipynb](notebooks/eda.ipynb) produces four core visualization assets:

1. Pricing distribution and room-type spread — a histogram of nightly prices (restricted to the core market) paired with a room-type boxplot. The analysis highlights the main concentration of listings in the lower-to-mid price range and the relative pricing spread across room types.

![Pricing distribution and room-type spread](assets/plots/pricing_distribution.png)

2. Borough supply and price comparison — listing counts and average nightly price by borough. Manhattan and Brooklyn lead in listing volume, while average prices remain relatively close across boroughs.

![Borough supply and price comparison](assets/plots/borough_market.png)

3. Room-type market share and pricing — a pie chart of inventory mix and a bar chart of average nightly price by room type. Entire homes/apartments and private rooms dominate the market, while hotel rooms carry the highest average price.

![Room-type market share and pricing](assets/plots/room_type_market.png)

4. Minimum-night and review activity — a histogram of minimum-night requirements and a review-volume bar chart by room type. The data shows a short-stay-oriented market, with review activity concentrated in the most common listing categories.

![Minimum-night and review activity](assets/plots/booking_activity.png)

## Business Intelligence Queries

### 1. Neighborhood Investment Radar — [challenge_1_neighbourhood_investment_radar.sql](sql/challenge_1_neighbourhood_investment_radar.sql)

**Business Question**: Which NYC neighborhoods offer the strongest short-term rental pricing power while maintaining enough market depth (100+ listings) to ensure statistical reliability?

| rank | neighbourhood | borough | avg\_nightly\_price | total\_listings | avg\_review |
|------|---------------|-----------|-----------|----------------|------------|
| 1 | Gravesend | Brooklyn | 707.46 | 140 | 3.3 |
| 2 | Briarwood | Queens | 700.83 | 121 | 3.5 |
| 3 | Concourse | Bronx | 674.43 | 123 | 3.1 |
| 4 | Longwood | Bronx | 670.97 | 133 | 3.3 |
| 5 | Brownsville | Brooklyn | 670.27 | 153 | 3.5 |
| 6 | East Elmhurst | Queens | 669.22 | 483 | 3.4 |
| 7 | NoHo | Manhattan | 664.96 | 140 | 3.3 |
| 8 | Inwood | Manhattan | 660.65 | 547 | 3.2 |
| 9 | Queens Village | Queens | 660.12 | 145 | 3.2 |
| 10 | Brighton Beach | Brooklyn | 658.40 | 168 | 3.4 |

**Key Insights**:
- Manhattan is not the price leader — Gravesend (Brooklyn) and Briarwood (Queens) command the highest average nightly rates among statistically significant neighborhoods.
- The Bronx appears twice in the top 5 (Concourse, Longwood), revealing undervalued micro-markets where acquisition costs are lower but rental yields remain competitive.
- East Elmhurst (483 listings) and Inwood (547 listings) offer the deepest market liquidity in the top 10, making them the safest bets for consistent occupancy.
- Guest ratings cluster tightly between 3.1 and 3.5 across all top neighborhoods, indicating no quality penalty for choosing outer-borough locations.

**Strategic Action**: Prioritize East Elmhurst and Inwood for scale-oriented acquisitions (high volume + strong pricing), and Gravesend/Briarwood for boutique high-yield plays (top pricing + lower acquisition costs).

### 2. Price Tier Market Segmentation — [challenge_2_price_tier_segmentation.sql](sql/challenge_2_price_tier_segmentation.sql)

**Business Question**: How does the NYC Airbnb market distribute across price tiers (Budget ≤$300, Mid-Range $301–$600, Premium $601–$900, Luxury $901+), and do higher-priced tiers deliver better guest satisfaction or operational metrics?

| price\_range | market\_share | total\_listings | avg\_price | avg\_review | avg\_min\_nights | avg\_availability |
|-------------|--------------|----------------|-----------|------------|----------------|-----------------|
| Budget | 21.66 | 22,101 | 174.98 | 3.3 | 8.2 | 141.6 |
| Mid-Range | 26.22 | 26,755 | 451.48 | 3.3 | 7.8 | 142.2 |
| Premium | 25.99 | 26,515 | 749.00 | 3.3 | 7.9 | 139.2 |
| Luxury | 26.12 | 26,653 | 1,050.13 | 3.3 | 8.0 | 141.1 |

**Key Insights**:
- The market splits nearly evenly across Mid-Range, Premium, and Luxury (~26% each), with Budget slightly smaller at 21.66% — NYC supports all four price segments without a single dominant tier.
- Guest satisfaction is completely flat at 3.3 across all tiers — paying 6× more ($1,050 vs. $175) buys zero improvement in ratings, signaling a service quality gap in the upper tiers.
- Minimum nights and availability barely vary (~8 days, ~141 days), meaning hosts across all price points use near-identical booking strategies.

**Strategic Action**: Avoid competing on price alone — since satisfaction and operational metrics are identical across tiers, the winning strategy is to differentiate on guest experience (amenities, response times, curated local guides). The Budget tier's smaller 21.66% share suggests moderate undersupply worth exploring.

### 3. Borough Price Champions — [challenge_3_borough_price_champions.sql](sql/challenge_3_borough_price_champions.sql)

**Business Question**: For a localized, borough-by-borough expansion strategy, what are the top 3 highest-priced neighborhoods within each borough that have proven market depth (50+ listings)?

| borough | borough\_rank | neighbourhood | avg\_price | total\_listings | avg\_review |
|---------|-------------|---------------|-----------|----------------|------------|
| Bronx | 1 | Throgs Neck | 684.70 | 56 | 3.4 |
| Bronx | 2 | Highbridge | 676.03 | 67 | 3.0 |
| Bronx | 3 | Concourse | 674.43 | 123 | 3.1 |
| Brooklyn | 1 | Columbia St | 712.23 | 88 | 3.4 |
| Brooklyn | 2 | Gravesend | 707.46 | 140 | 3.3 |
| Brooklyn | 3 | Coney Island | 695.26 | 50 | 3.1 |
| Manhattan | 1 | Stuyvesant Town | 680.92 | 83 | 3.2 |
| Manhattan | 2 | NoHo | 664.96 | 140 | 3.3 |
| Manhattan | 3 | Inwood | 660.65 | 547 | 3.2 |
| Queens | 1 | Briarwood | 700.83 | 121 | 3.5 |
| Queens | 2 | Kew Gardens Hills | 690.39 | 66 | 3.3 |
| Queens | 3 | Cambria Heights | 686.49 | 78 | 3.3 |
| Staten Island | 1 | Stapleton | 699.23 | 64 | 3.7 |
| Staten Island | 2 | St. George | 651.93 | 125 | 3.4 |
| Staten Island | 3 | West Brighton | 638.02 | 59 | 3.0 |

**Key Insights**:
- Brooklyn's Columbia St ($712) is the single most expensive neighborhood in the entire dataset among those with 50+ listings — beating every Manhattan neighborhood.
- Manhattan's top spots are surprisingly modest (none break $700). The borough's massive supply (44K+ listings) spreads demand and compresses top-tier pricing.
- Staten Island's Stapleton ($699, 3.7 rating) carries the highest guest satisfaction of any neighborhood in this table, while commanding near-top pricing — a hidden gem for operators prioritizing guest experience.
- The Bronx is highly competitive on pricing — Throgs Neck ($685) outprices all of Manhattan's top 3, offering the strongest price-to-acquisition-cost ratio in the city.

**Strategic Action**: Expand into Columbia St (Brooklyn) and Throgs Neck (Bronx) for premium pricing with lower real estate competition, and Stapleton (Staten Island) for the best satisfaction-to-price ratio in the city.

## Progress Checklist
- [x] Database configuration and schema setup
- [x] Raw GUI-driven ingestion workflow
- [x] Data cleaning and transformation pipeline
- [x] Core visualization assets from the EDA notebook
- [ ] Interactive dashboard creation
- [ ] Advanced window-function modeling and analytics queries
