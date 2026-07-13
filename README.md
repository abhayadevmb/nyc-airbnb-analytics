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

## Progress Checklist
- [x] Database configuration and schema setup
- [x] Raw GUI-driven ingestion workflow
- [x] Data cleaning and transformation pipeline
- [x] Core visualization assets from the EDA notebook
- [ ] Interactive dashboard creation
- [ ] Advanced window-function modeling and analytics queries
