SELECT

customer_id,

COUNT(*)

FROM customers

GROUP BY customer_id

HAVING COUNT(*)>1;


SELECT

review_id, order_id,

COUNT(*)

FROM order_reviews

GROUP BY review_id, order_id

HAVING COUNT(*)>1;