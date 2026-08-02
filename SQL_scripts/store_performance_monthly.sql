-- select distinct store_id from sales_table;

-- create view product_store as
-- select distinct product_id, store_id from sales_table;

create table store_perfromance as 
SELECT month, 
    store_id,

    COUNT(*) AS total_products,

    ROUND(AVG(turnover_ratio),2) AS avg_turnover,


    SUM(movement='Fast Moving') AS fast_products,
    SUM(movement='Medium Moving') AS medium_products,
    SUM(movement='Slow Moving') AS slow_products

FROM monthly_inventory_turnover


GROUP BY month, store_id

ORDER BY avg_turnover DESC;
