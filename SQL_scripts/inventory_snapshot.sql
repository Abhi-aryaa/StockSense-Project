SELECT `Date`,`Store ID`, `Product ID`, `Inventory Level`, `Units Sold`, `Units Ordered`
FROM sales_table
LIMIT 10;
ALTER TABLE sales_table 
MODIFY COLUMN `Date` DATE;
SELECT `Date`,`Store ID`, `Product ID`, `Inventory Level`, `Units Sold`, `Units Ordered`
FROM sales_table order by `Date`,`Store ID`, `Product ID`;

ALTER TABLE sales_table RENAME COLUMN `Date` TO date;
ALTER TABLE sales_table RENAME COLUMN `Store ID` TO store_id;
ALTER TABLE sales_table RENAME COLUMN `Product ID` TO product_id;
ALTER TABLE sales_table RENAME COLUMN `Category` TO category;
ALTER TABLE sales_table RENAME COLUMN `Region` TO region;
ALTER TABLE sales_table RENAME COLUMN `Inventory Level` TO inventory_level;
ALTER TABLE sales_table RENAME COLUMN `Units Sold` TO units_sold;
ALTER TABLE sales_table RENAME COLUMN `Units Ordered` TO units_ordered;
ALTER TABLE sales_table RENAME COLUMN `Demand Forecast` TO demand_forecast;
ALTER TABLE sales_table RENAME COLUMN `Price` TO price;
ALTER TABLE sales_table RENAME COLUMN `Discount` TO discount;
ALTER TABLE sales_table RENAME COLUMN `Weather Condition` TO weather_condition;
ALTER TABLE sales_table RENAME COLUMN `Holiday/Promotion` TO holiday_promotion;
ALTER TABLE sales_table RENAME COLUMN `Competitor Pricing` TO competitor_pricing;
ALTER TABLE sales_table RENAME COLUMN `Seasonality` TO seasonality;

select date, store_id, product_id, inventory_level, units_sold, units_ordered from sales_table order by date , store_id, product_id;
create table inventory_snapshot as
select date, store_id, product_id, inventory_level, units_sold, units_ordered from sales_table order by date , store_id, product_id;