-- CREATE TABLE monthly_inventory_turnover AS
-- SELECT
--     DATE_FORMAT(date, '%Y-%m') AS month,
--     store_id,
--     product_id,

--     SUM(units_sold) AS total_units_sold,
--     ROUND(AVG(inventory_level),2) AS avg_inventory,

--     ROUND(
--         SUM(units_sold) / NULLIF(AVG(inventory_level),0),
--         2
--     ) AS turnover_ratio

-- FROM sales_table

-- GROUP BY
--     DATE_FORMAT(date,'%Y-%m'),
--     store_id,
--     product_id;
--     
-- SELECT
--     MIN(turnover_ratio) AS min_turnover,
--     MAX(turnover_ratio) AS max_turnover,
--     AVG(turnover_ratio) AS avg_turnover
-- FROM monthly_inventory_turnover;

-- drop table monthly_inventory_turnover;

create table monthly_inventory_turnover as
WITH turnover AS (
    SELECT
        DATE_FORMAT(date, '%Y-%m') AS month,
        store_id,
        product_id,
        SUM(units_sold) AS total_units_sold,
        AVG(inventory_level) AS avg_inventory,
        SUM(units_sold) / NULLIF(AVG(inventory_level),0) AS turnover_ratio
    FROM sales_table
    GROUP BY
        DATE_FORMAT(date,'%Y-%m'),
        store_id,
        product_id
)

SELECT
    *,
    CASE
        WHEN turnover_group = 1 THEN 'Slow Moving'
        WHEN turnover_group = 2 THEN 'Medium Moving'
        ELSE 'Fast Moving'
    END AS movement
FROM (
    SELECT
        *,
        NTILE(3) OVER (partition by month  ORDER BY turnover_ratio) AS turnover_group
    FROM turnover
) t;


-- drop table monthly_inventory_inventory;
-- drop table monthly_inventory_tu;
select * from monthly_inventory_turnover
where movement = 'Slow Moving';

