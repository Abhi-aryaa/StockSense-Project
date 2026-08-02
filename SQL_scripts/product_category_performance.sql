-- create table product_category as 
-- select distinct product_id, category from sales_table;

create table category_performance_monthly
SELECT month,
    p.category,

    COUNT(*) AS total_products,

    ROUND(AVG(m.turnover_ratio),2) AS avg_category_turnover,


    SUM(m.movement='Fast Moving') AS fast_products,
    SUM(m.movement='Medium Moving') AS medium_products,
    SUM(m.movement='Slow Moving') AS slow_products

FROM monthly_inventory_turnover m

JOIN product_category p
ON m.product_id = p.product_id

GROUP BY m.month, p.category

ORDER BY avg_category_turnover DESC;

drop table product_category_performance;

