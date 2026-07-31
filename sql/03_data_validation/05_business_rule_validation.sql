-- review_score

select review_score, count(*)

from order_reviews

group by review_score

having review_score BETWEEN 1 AND 5