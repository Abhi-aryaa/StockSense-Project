StockSense: SQL-Based Inventory Optimization & Forecast Accuracy Analysis

Capstone Project — Summer Analytics 2025, Consulting & Analytics Club, IIT Guwahati

A SQL-driven inventory monitoring and optimization system built for a simulated multi-store retail chain, covering stock-level tracking, reorder-point estimation, turnover analysis, and demand forecast accuracy — visualized in an interactive Power BI dashboard.

1. Problem Statement

Urban Retail Co. (the case-study business behind this brief) is a growing retail chain struggling with:

Frequent stockouts of fast-moving products
Overstocking of slow-moving items, tying up capital
Poor visibility into SKU performance across stores and regions
No real-time insight into reorder needs or forecast reliability

The mission: design a SQL-driven inventory monitoring and optimization solution that converts raw sales/inventory data into actionable business insight.

2. Dataset
Source: Synthetic retail inventory dataset (daily granularity)
Scope: 30 unique products × 5 stores, Jan 2022 – Dec 2023 (~109,500 rows)
Key columns: date, store_id, product_id, category, region, inventory_level, units_sold, units_ordered, demand_forecast, price, discount, weather_condition, holiday_promotion, competitor_pricing, seasonality

Note: the original business brief describes a 5,000+ SKU retail network — this dataset is a representative sample used to design and validate the same SQL logic that would scale to the full catalog.

3. Tech Stack
Layer	Tools
Data storage & querying	MySQL 8.0
Analysis	SQL (window functions, CTEs, NTILE, joins)
Visualization	Power BI Desktop (DAX measures, data modeling, slicers)
4. Workflow
4.1 Data Preparation
Renamed all columns to snake_case (e.g. Store ID → store_id)
Converted date from text to a proper SQL DATE type
4.2 Inventory Snapshot

Base reference table (inventory_snapshot) holding date, store_id, product_id, inventory_level, units_sold, units_ordered for every day — the foundation for all downstream stock-level queries.

4.3 Rolling 30-Day Demand Average
sql
AVG(units_sold) OVER (
    PARTITION BY store_id, product_id
    ORDER BY date
    ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
) AS avg_last_30_days

Calculates each row's trailing 30-day average demand per store-product combination, correctly handling partial windows early in a product's history.

4.4 Days of Supply
days_of_supply = inventory_level ÷ avg_last_30_days

A daily, per-row estimate of how many days of stock remain at the recent selling pace — recalculated every day as a live monitoring signal, not a one-time forecast.

4.5 Inventory Health Classification (Reorder Status)

Rows classified via threshold bands on days_of_supply:

Critical: < 2 days
Reorder Soon: < 4 days
Healthy: otherwise
4.6 Stockout Risk

Same days_of_supply metric, re-banded into High / Medium / Low risk tiers — a severity lens distinct from the health classification above.

4.7 Overstock Detection

Currently derived from the same days_of_supply metric (high values flagged as overstocked). See Limitations below for a planned refinement.

4.8 Monthly Inventory Turnover
turnover_ratio = SUM(units_sold) ÷ AVG(inventory_level)

Calculated per month, store, and product — measuring how efficiently stock moves.

4.9 Movement Classification (Fast / Medium / Slow)
sql
NTILE(3) OVER (PARTITION BY month ORDER BY turnover_ratio)

Products are split into three tiers within each month, so "fast-moving" is always relative to that month's distribution rather than a fixed global cutoff.

4.10 Category / Product / Store Performance Rollups

Monthly aggregates (avg turnover, count of fast/medium/slow products) sliced by category, product, and store — supporting drill-down analysis at multiple levels of granularity.

4.11 Discount & Promotion Analysis

Explored how discount bands (No Discount / 0–10% / 10–20% / >20%) and holiday_promotion flags correlate with sales volume — supporting evidence for demand-driver hypotheses.

4.12 Forecast Accuracy Analysis
forecast_deviation   = demand_forecast − units_sold
forecast_error       = ABS(forecast_deviation)
forecast_error_pct   = forecast_error ÷ units_sold × 100

Each row classified as Accurate (within 5% error), Over Forecast, or Under Forecast.

4.13 Weather Analysis

Explored (weather_condition vs. sales) but found inconclusive for actionable decisions — scoped out of the final model.

5. Key Insights
Forecast accuracy is only ~25% across the dataset — a substantial majority of demand predictions are meaningfully off.
80%+ of SKUs are flagged Critical on any given day — an unusually high rate that points to systemic under-forecasting as a likely root cause, not just poor reordering logic.
Inventory turnover has declined from ~23 to ~19–20 over the two-year window, suggesting products are moving more slowly over time.
Movement tiers (Fast/Medium/Slow) and category/store rollups reveal meaningful variation in performance that a single global inventory policy would miss.

Business takeaway: improving demand forecasting is likely a higher-leverage fix than tightening reorder thresholds alone, since poor forecasts appear to be an upstream driver of the stockout problem.

6. Dashboard

Two-page Power BI report:

Page 1 — Executive Overview

KPI cards: Forecast Accuracy %, % Critical Stock, Avg Turnover, Total Stores, Total SKUs
Inventory health & forecast status breakdown (donut charts)
Top-10 highest-risk SKUs table
Dynamic, slicer-responsive "Key Insights" summary text
product_id / store_id slicers (synced across both pages)

Page 2 — Trends

Turnover ratio trend (monthly)
Inventory health trend (monthly, stacked)
Forecast status trend (monthly)
Product movement by store

Data model uses a star schema (Store and Product lookup tables as hubs) to support clean, reliable cross-filtering via slicers.

7. Repository Structure
StockSense-Project/
├── SQL_Scripts/
│   ├── 01_data_cleaning.sql
│   ├── 02_inventory_snapshot.sql
│   ├── 03_avg_sales_30_days.sql
│   ├── 04_reorder_status.sql
│   ├── 05_stockout_risk.sql
│   ├── 06_overstock.sql
│   ├── 07_monthly_inventory_turnover.sql
│   ├── 08_category_performance.sql
│   ├── 09_product_performance.sql
│   ├── 10_store_performance.sql
│   ├── 11_discount_analysis.sql
│   ├── 12_holiday_analysis.sql
│   └── 13_forecast_analysis.sql
├── Power_BI/
│   └── StockSense_Dashboard.pbix
├── Dashboard_Screenshots/
│   ├── page1_overview.png
│   └── page2_trends.png
├── Exported_CSVs/
└── README.md
8. How to Run
Import the raw dataset into MySQL as sales_table
Run scripts in SQL_Scripts/ in numbered order
Open Power_BI/StockSense_Dashboard.pbix in Power BI Desktop
Update the data source connection to point to your local MySQL instance
Refresh the data model
9. Limitations & Planned Improvements
Overstock detection currently reuses the days_of_supply metric rather than being derived independently from turnover/movement data. A more robust version would cross-reference low turnover and high inventory to confirm genuine overstock, rather than relying on a single days-of-supply signal.
Supplier-level analysis wasn't possible — the dataset has no supplier identifier column. units_ordered vs. units_sold gaps could serve as a rough proxy for reorder reliability in a future iteration.
price and competitor_pricing are not yet analyzed. A natural next step is a competitive pricing study — e.g., calculating price − competitor_pricing to see whether being priced above/below competitors correlates with units_sold, and whether that relationship changes during holiday_promotion periods or across discount bands. This would extend the demand-driver analysis already done for discounts and promotions to a genuinely unexplored dimension of the dataset.
