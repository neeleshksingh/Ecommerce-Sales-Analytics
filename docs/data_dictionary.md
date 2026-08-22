# Data dictionary

Definitions follow `sql/01_schema`. `NN` means `NOT NULL`; key status reflects the physical schema. Source misspellings `lenght` are preserved for load compatibility.

## Customers and sellers

| Table | Column | Type | Null/key | Meaning |
|---|---|---|---|---|
| customers | customer_id | varchar(50) | NN, PK | Order-associated customer record ID |
| customers | customer_unique_id | varchar(50) | NN | Cross-order customer identity |
| customers | customer_zip_code_prefix | integer | NN | Customer ZIP prefix |
| customers | customer_city | varchar(100) | NN | Source city; conditionally trimmed |
| customers | customer_state | char(2) | NN | State code; conditionally trimmed |
| sellers | seller_id | varchar(50) | NN, PK | Seller identity |
| sellers | seller_zip_code_prefix | integer | NN | Seller ZIP prefix |
| sellers | seller_city | varchar(100) | NN | Source city; conditionally trimmed |
| sellers | seller_state | char(2) | NN | State code; conditionally trimmed |

## Orders, items, payments, and reviews

| Table | Column | Type | Null/key | Meaning |
|---|---|---|---|---|
| orders | order_id | varchar(50) | NN, PK | Order identity |
| orders | customer_id | varchar(50) | NN, FK | References `customers.customer_id` |
| orders | order_status | varchar(20) | NN | Lifecycle status; conditionally trimmed |
| orders | order_purchase_timestamp | timestamp | NN | Purchase timestamp |
| orders | order_approved_at | timestamp | nullable | Approval timestamp |
| orders | order_delivered_carrier_date | timestamp | nullable | Carrier handoff timestamp |
| orders | order_delivered_customer_date | timestamp | nullable | Customer delivery timestamp |
| orders | order_estimated_delivery_date | timestamp | NN | Promised delivery timestamp |
| order_items | order_id | varchar(50) | NN, PK/FK | Order; first part of line key |
| order_items | order_item_id | integer | NN, PK | Line sequence within order |
| order_items | product_id | varchar(50) | NN, FK | Purchased product |
| order_items | seller_id | varchar(50) | NN, FK | Fulfilling seller |
| order_items | shipping_limit_date | timestamp | NN | Seller shipping deadline |
| order_items | price | decimal(10,2) | NN | Item selling price; check `>= 0` |
| order_items | freight_value | decimal(10,2) | NN | Item freight charge; check `>= 0` |
| order_payments | order_id | varchar(50) | NN, PK/FK | Paid order |
| order_payments | payment_sequential | integer | NN, PK | Payment sequence within order |
| order_payments | payment_type | varchar(50) | NN | Payment method |
| order_payments | payment_installments | integer | NN | Installment count; zero permitted |
| order_payments | payment_value | decimal(10,2) | NN | Transaction amount; check `>= 0` |
| order_reviews | review_id | varchar(50) | NN, PK | Review ID; first composite key part |
| order_reviews | order_id | varchar(50) | NN, PK/FK | Reviewed order; second key part |
| order_reviews | review_score | integer | NN | Rating; check 1–5 |
| order_reviews | review_comment_title | varchar(100) | nullable | Optional title |
| order_reviews | review_comment_message | text | nullable | Optional body |
| order_reviews | review_creation_date | timestamp | NN | Review creation timestamp |
| order_reviews | review_answer_timestamp | timestamp | nullable | Platform answer timestamp |

## Products and category translation

| Table | Column | Type | Null/key | Meaning |
|---|---|---|---|---|
| products | product_id | varchar(50) | NN, PK | Product identity |
| products | product_category_name | varchar(100) | nullable | Portuguese category; trimmed; no FK |
| products | product_name_lenght | integer | nullable | Source-provided name length |
| products | product_description_lenght | integer | nullable | Source-provided description length |
| products | product_photos_qty | integer | nullable | Catalog photo count |
| products | product_weight_g | integer | nullable | Weight in grams |
| products | product_length_cm | integer | nullable | Length in cm |
| products | product_height_cm | integer | nullable | Height in cm |
| products | product_width_cm | integer | nullable | Width in cm |
| product_category_translation | product_category_name | varchar(100) | NN, PK | Portuguese lookup key; trimmed |
| product_category_translation | product_category_name_english | varchar(100) | NN | English label; trimmed |

All nullable numeric product attributes have non-negative checks; SQL CHECK semantics allow nulls.

## Geolocation

| Column | Type | Null/key | Meaning |
|---|---|---|---|
| geolocation_zip_code_prefix | integer | NN, no key | ZIP prefix; repeats |
| geolocation_lat | decimal(10,8) | NN | Latitude |
| geolocation_lng | decimal(11,8) | NN | Longitude |
| geolocation_city | varchar(50) | NN | City; conditionally trimmed |
| geolocation_state | char(2) | NN | State code; conditionally trimmed |

No database transformations rename columns or replace nulls.
