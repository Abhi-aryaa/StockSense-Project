create table product_performance_montlhy
SELECT month,
    product_id,

    COUNT(*) AS total_products,

    ROUND(AVG(turnover_ratio),2) AS avg_turnover,


    SUM(movement='Fast Moving') AS fast_products,
    SUM(movement='Medium Moving') AS medium_products,
    SUM(movement='Slow Moving') AS slow_products

FROM monthly_inventory_turnover

GROUP BY month, product_id

ORDER BY avg_turnover DESC;
