select date, store_id, product_id,
 CASE
    WHEN days_of_supply < 1 THEN 'High'
    WHEN days_of_supply < 3 THEN 'Medium'
    ELSE 'Low'
END as stockout_risk
from low_inventory_flags;