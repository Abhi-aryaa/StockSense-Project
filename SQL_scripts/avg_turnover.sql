drop view product_turnover_summary;
CREATE view product_turnover_summary AS

SELECT
    product_id,

    ROUND(AVG(turnover_ratio),2) AS avg_turnover,

    MIN(turnover_ratio) AS min_turnover,

    MAX(turnover_ratio) AS max_turnover,

    STDDEV(turnover_ratio) AS turnover_variation

FROM monthly_inventory_turnover
GROUP BY product_id;

-- drop table overall_inventory_turnover;
create table overall_inventory_turnover as 
SELECT
    *,
    CASE
        WHEN grp = 1 THEN 'Slow'
        WHEN grp = 2 THEN 'Medium'
        ELSE 'Fast'
    END AS movement
FROM (
    SELECT
        *,
        NTILE(3) OVER (ORDER BY avg_turnover) AS grp
    FROM product_turnover_summary
) AS p;

-- drop view avg_turnover_category;
create view avg_turnover_category as 
SELECT
    o.product_id,
    s.category,
    o.avg_turnover,
    o.movement
FROM overall_inventory_turnover o
LEFT JOIN
(
    SELECT DISTINCT
        product_id,
        category
    FROM sales_table
) s
ON o.product_id = s.product_id;

select * from avg_turnover_category where movement = 'Fast' ;






