CREATE TABLE forecast_analysis_sales AS

SELECT

    date,
    store_id,
    product_id,

    units_sold,
    demand_forecast,

    round((demand_forecast - units_sold),2) AS forecast_deviation,

    round(ABS(demand_forecast - units_sold),2) AS forecast_error,

    ROUND(
        ABS(demand_forecast - units_sold)
        / NULLIF(units_sold,0) * 100,
        2
    ) AS forecast_error_pct,

    CASE

        WHEN ABS(demand_forecast - units_sold)
             <= 0.05 * units_sold
        THEN 'Accurate'

        WHEN demand_forecast > units_sold
        THEN 'Over Forecast'

        ELSE 'Under Forecast'

    END AS forecast_status

FROM sales_table;

drop table forecast_analysis ;