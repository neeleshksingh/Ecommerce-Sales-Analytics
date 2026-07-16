# Customers

| Column                   | Data Type | Description                                                                   |
| ------------------------ | --------- | ----------------------------------------------------------------------------- |
| customer_id              | VARCHAR   | Unique identifier for each customer record.                                   |
| customer_unique_id       | VARCHAR   | Unique identifier representing the actual customer across multiple purchases. |
| customer_zip_code_prefix | INTEGER   | ZIP code prefix of the customer's location.                                   |
| customer_city            | VARCHAR   | Customer's city.                                                              |
| customer_state           | CHAR(2)   | Customer's state.                                                             |

---

# Orders

| Column                        | Data Type | Description                                                  |
| ----------------------------- | --------- | ------------------------------------------------------------ |
| order_id                      | VARCHAR   | Unique identifier of the order.                              |
| customer_id                   | VARCHAR   | Identifier of the customer who placed the order.             |
| order_status                  | VARCHAR   | Current status of the order.                                 |
| order_purchase_timestamp      | TIMESTAMP | Date and time when the order was placed.                     |
| order_approved_at             | TIMESTAMP | Date and time when the payment was approved.                 |
| order_delivered_carrier_date  | TIMESTAMP | Date and time when the order was handed over to the carrier. |
| order_delivered_customer_date | TIMESTAMP | Date and time when the customer received the order.          |
| order_estimated_delivery_date | TIMESTAMP | Estimated delivery date provided to the customer.            |

---

# Order Items

| Column              | Data Type     | Description                                                 |
| ------------------- | ------------- | ----------------------------------------------------------- |
| order_id            | VARCHAR       | Identifier of the order.                                    |
| order_item_id       | INTEGER       | Sequential identifier of the product within the same order. |
| product_id          | VARCHAR       | Identifier of the purchased product.                        |
| seller_id           | VARCHAR       | Identifier of the seller fulfilling the order item.         |
| shipping_limit_date | TIMESTAMP     | Deadline by which the seller should ship the product.       |
| price               | DECIMAL(10,2) | Selling price of the product at the time of purchase.       |
| freight_value       | DECIMAL(10,2) | Shipping charge associated with the order item.             |

---

# Products

| Column                     | Data Type | Description                                        |
| -------------------------- | --------- | -------------------------------------------------- |
| product_id                 | VARCHAR   | Unique identifier of the product.                  |
| product_category_name      | VARCHAR   | Category to which the product belongs.             |
| product_name_lenght        | INTEGER   | Number of characters in the product name.          |
| product_description_lenght | INTEGER   | Number of characters in the product description.   |
| product_photos_qty         | INTEGER   | Number of product images available in the catalog. |
| product_weight_g           | INTEGER   | Weight of the product in grams.                    |
| product_length_cm          | INTEGER   | Length of the product in centimeters.              |
| product_height_cm          | INTEGER   | Height of the product in centimeters.              |
| product_width_cm           | INTEGER   | Width of the product in centimeters.               |

---

# Sellers

| Column                 | Data Type | Description                               |
| ---------------------- | --------- | ----------------------------------------- |
| seller_id              | VARCHAR   | Unique identifier of each seller.         |
| seller_zip_code_prefix | INTEGER   | ZIP code prefix of the seller's location. |
| seller_city            | VARCHAR   | Seller's city.                            |
| seller_state           | CHAR(2)   | Seller's state.                           |

---

# Order Payments

| Column               | Data Type     | Description                                        |
| -------------------- | ------------- | -------------------------------------------------- |
| order_id             | VARCHAR       | Identifier of the order.                           |
| payment_sequential   | INTEGER       | Sequence number of the payment for the same order. |
| payment_type         | VARCHAR       | Payment method used by the customer.               |
| payment_installments | INTEGER       | Number of installments selected for the payment.   |
| payment_value        | DECIMAL(10,2) | Amount paid in the payment transaction.            |
