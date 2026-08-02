select date, store_id, product_id,
CASE
    WHEN days_of_supply > 3 THEN 'Overstocked'
    WHEN days_of_supply > 2 THEN 'Healthy'
    ELSE 'Low Inventory'
END as inventory_health
from low_inventory_flags;