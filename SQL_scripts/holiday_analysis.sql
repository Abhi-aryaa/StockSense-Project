SELECT

holiday_promotion,

AVG(units_sold),
sum(units_sold),
AVG(price)

FROM sales_table

GROUP BY holiday_promotion;

