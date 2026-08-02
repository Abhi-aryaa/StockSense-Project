SELECT

CASE

WHEN discount=0 THEN 'No Discount'

WHEN discount<=10 THEN '0-10%'

WHEN discount<=20 THEN '10-20%'

ELSE '>20%'

END discount_group,

sum(units_sold),
avg(units_sold)
FROM sales_table

GROUP BY discount_group;