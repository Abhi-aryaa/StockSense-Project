SELECT

weather_condition,

AVG(units_sold),
sum(units_sold),

AVG(inventory_level)

FROM sales_table

GROUP BY weather_condition;