# Order Reviews Table Profiling

> **Physical-schema note:** the implemented primary key is (`review_id`, `order_id`), and source data contains repeated review IDs and repeated order IDs. See [`../data_model.md`](../data_model.md).

---

## Purpose

The **Order Reviews** table stores customer feedback submitted after an order has been delivered. It contains the review score, review title, review message, and timestamps related to the review process. This table helps measure customer satisfaction and service quality.

---

## One Row Represents

Each row represents **one customer review** associated with a completed order.

---

## Columns

| Column                  | Description                                             |
| ----------------------- | ------------------------------------------------------- |
| review_id               | Unique identifier of the review.                        |
| order_id                | Identifier of the reviewed order.                       |
| review_score            | Rating given by the customer (1–5).                     |
| review_comment_title    | Short title of the customer's review.                   |
| review_comment_message  | Detailed review message provided by the customer.       |
| review_creation_date    | Date when the review was created.                       |
| review_answer_timestamp | Timestamp when the review was answered by the platform. |

---

## Primary Key

`review_id`

> **Note:** Although `review_id` is intended to uniquely identify a review, it is good practice to verify uniqueness during data validation because real-world datasets can contain anomalies.

---

## Foreign Keys

| Column   | References      |
| -------- | --------------- |
| order_id | Orders.order_id |

---

## Expected Data Types

| Column                  | Data Type |
| ----------------------- | --------- |
| review_id               | VARCHAR   |
| order_id                | VARCHAR   |
| review_score            | INTEGER   |
| review_comment_title    | VARCHAR   |
| review_comment_message  | TEXT      |
| review_creation_date    | TIMESTAMP |
| review_answer_timestamp | TIMESTAMP |

---

## Business Importance

This table captures customer satisfaction after an order is completed.

It supports:

- Customer satisfaction analysis.
- Service quality measurement.
- Product quality evaluation.
- Seller performance evaluation.
- Customer experience reporting.

---

## Business Questions This Table Can Answer

- What is the average review score?
- How many 5-star reviews are received?
- How many 1-star reviews are received?
- Which orders received poor ratings?
- What percentage of reviews are positive?
- What percentage of reviews are negative?
- Which sellers receive the highest ratings? _(after joining with Sellers and Order Items)_
- Which product categories receive the best ratings? _(after joining with Products)_

---

## Possible KPIs

### Review KPIs

- Total Reviews
- Average Review Score
- 5-Star Review Percentage
- 1-Star Review Percentage
- Positive Review Rate
- Negative Review Rate

### Customer Satisfaction KPIs

- Average Customer Rating
- Review Response Time
- Reviewed Orders %
- Unreviewed Orders %

---

## Analytical Opportunities

- Customer Satisfaction Analysis
- Rating Distribution Analysis
- Sentiment Analysis
- Seller Performance Analysis
- Product Rating Analysis
- Delivery vs Review Score Analysis
- Review Trend Analysis

---

## Data Validation Rules

- `review_id` should be unique.
- `order_id` should exist in the Orders table.
- `review_score` must be between 1 and 5.
- `review_creation_date` should not be NULL.
- `review_answer_timestamp` should be greater than or equal to `review_creation_date`.
- `review_comment_title` may be NULL.
- `review_comment_message` may be NULL.

---

## Possible Data Quality Issues

- Duplicate review IDs.
- Missing review score.
- Missing order ID.
- Missing review creation date.
- Invalid review score.
- Review timestamp occurring before creation date.
- Empty review comments.

---

## Observations

- Not every review contains a written comment.
- Customers may provide only a rating without a comment.
- Reviews help evaluate customer satisfaction rather than product sales.
- Review information is stored separately to maintain normalization.
- Review scores can be analyzed alongside delivery performance and seller performance.

---

## Relationships

| Parent Table | Child Table   | Relationship        |
| ------------ | ------------- | ------------------- |
| Orders       | Order Reviews | One-to-One (1:0..1) |

---

## Future SQL Analysis

- Review Score Distribution
- Customer Satisfaction Analysis
- Seller Rating Analysis
- Product Rating Analysis
- Review Trend Analysis
- Delivery Time vs Review Score
- Positive vs Negative Review Analysis
- Average Rating by State
