-- drop table low_inventory_flags;
CREATE view low_inventory_flags AS
SELECT 
    s.date,
    s.store_id,
    s.product_id,
    s.inventory_level,
    a.avg_last_30_days,
    ROUND(s.inventory_level / NULLIF(a.avg_last_30_days, 0), 1) AS days_of_supply
FROM sales_table s
JOIN avg_sales_30_days a 
    ON s.date = a.date 
    AND s.store_id = a.store_id 
    AND s.product_id = a.product_id;
    
-- drop table critical_low_inventory_flags;
-- CREATE view critical_low_inventory_flags AS
-- SELECT *
-- FROM low_inventory_flags
-- WHERE days_of_supply < 1
-- ORDER BY days_of_supply ASC;

create table reorder_status as
select date, store_id, product_id,
 CASE
    WHEN days_of_supply < 2 THEN 'Critical'
    WHEN days_of_supply < 4 THEN 'Reorder Soon'
    ELSE 'Healthy'
END as inventory_health
from low_inventory_flags;

SELECT
    MIN(days_of_supply),
    MAX(days_of_supply),
    AVG(days_of_supply)
FROM low_inventory_flags;

select * from low_inventory_flags;