/*
===============================================================================
Table        : order_reviews
Description  : Stores customer reviews and ratings for completed orders.
Source File  : olist_order_reviews_dataset.csv
Dependencies : orders (Foreign key added later)
===============================================================================
*/

CREATE TABLE order_reviews
(
    review_id VARCHAR(50) NOT NULL,
    order_id VARCHAR(50) NOT NULL,
    review_score INTEGER NOT NULL,
    review_comment_title VARCHAR(100),
    review_comment_message TEXT,
    review_creation_date TIMESTAMP NOT NULL,
    review_answer_timestamp TIMESTAMP,

    CONSTRAINT pk_order_reviews
        PRIMARY KEY (review_id)
);

-- Constraints

-- Notes