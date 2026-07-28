SELECT

MIN(price),

MAX(price),

AVG(price),

PERCENTILE_CONT(.5)

WITHIN GROUP

(ORDER BY price)

FROM order_items;