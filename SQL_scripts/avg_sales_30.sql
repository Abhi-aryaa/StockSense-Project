create view avg_sales_30_days as
SELECT 
    date,
    store_id,
    product_id,
    AVG(units_sold) OVER (
        PARTITION BY store_id, product_id 
        ORDER BY date 
        ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
    ) AS avg_last_30_days
FROM sales_table
ORDER BY store_id, product_id, date;

select * from sales_table;