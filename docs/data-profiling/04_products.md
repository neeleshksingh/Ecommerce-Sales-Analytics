# Products Table Profiling

> **Physical-schema note:** the category relationship discussed below is conceptual; the implemented foreign key is intentionally omitted. See [`../constraints.md`](../constraints.md).

---

## Purpose

The **Products** table stores descriptive metadata about every product available on the e-commerce platform. It contains information such as product category, dimensions, weight, description length, and the number of product images. This table is primarily used for product categorization, logistics analysis, catalog management, and product-level reporting.

---

## One Row Represents

Each row represents **one unique product** available on the e-commerce platform along with its category and physical characteristics.

---

## Columns

| Column                     | Description                                        |
| -------------------------- | -------------------------------------------------- |
| product_id                 | Unique identifier for each product.                |
| product_category_name      | Category to which the product belongs.             |
| product_name_lenght        | Number of characters in the product name.          |
| product_description_lenght | Number of characters in the product description.   |
| product_photos_qty         | Number of product images available in the catalog. |
| product_weight_g           | Weight of the product in grams.                    |
| product_length_cm          | Length of the product in centimeters.              |
| product_height_cm          | Height of the product in centimeters.              |
| product_width_cm           | Width of the product in centimeters.               |

---

## Primary Key

`product_id`

---

## Foreign Keys

| Column                | References                                              |
| --------------------- | ------------------------------------------------------- |
| product_category_name | product_category_name_translation.product_category_name |

---

## Expected Data Types

| Column                     | Data Type |
| -------------------------- | --------- |
| product_id                 | VARCHAR   |
| product_category_name      | VARCHAR   |
| product_name_lenght        | INTEGER   |
| product_description_lenght | INTEGER   |
| product_photos_qty         | INTEGER   |
| product_weight_g           | INTEGER   |
| product_length_cm          | INTEGER   |
| product_height_cm          | INTEGER   |
| product_width_cm           | INTEGER   |

---

## Business Importance

This table provides descriptive information about products available on the platform. It supports:

- Product categorization.
- Catalog management.
- Logistics and shipping planning.
- Product performance analysis.
- Warehouse storage planning.
- Shipping cost estimation (when combined with Order Items).
- Business reporting at the product category level.

---

## Business Questions This Table Can Answer

- Which product categories have the largest catalog?
- Which product categories contain the heaviest products?
- Which products have the largest dimensions?
- Which products have the highest number of catalog images?
- Which products have incomplete catalog information?
- Which categories have the highest number of products?
- Which products are never ordered? _(After joining with Order Items)_
- Which product categories generate the highest revenue? _(After joining with Order Items)_

---

## Possible KPIs

### Product KPIs

- Total Products
- Products per Category
- Average Product Weight
- Average Product Length
- Average Product Width
- Average Product Height
- Average Number of Product Images
- Largest Product Category

### Catalog KPIs

- Products Missing Category
- Products Missing Images
- Products Missing Dimensions

### Logistics KPIs

- Average Product Weight
- Largest Products
- Smallest Products
- Average Product Volume

---

## Analytical Opportunities

- Product Category Analysis
- Product Catalog Analysis
- Product Dimension Analysis
- Product Weight Analysis
- Warehouse Space Optimization
- Shipping Cost Analysis
- Product Performance Analysis (after joining with Order Items)
- Revenue Analysis by Product Category
- Product Popularity Analysis

---

## Data Validation Rules

- `product_id` must be unique.
- `product_category_name` should exist in the Category Translation table.
- `product_name_lenght` should be greater than zero.
- `product_description_lenght` should be greater than zero.
- `product_photos_qty` cannot be negative.
- `product_weight_g` must be greater than zero.
- `product_length_cm` must be greater than zero.
- `product_height_cm` must be greater than zero.
- `product_width_cm` must be greater than zero.

---

## Possible Data Quality Issues

- Duplicate product IDs.
- Missing product category.
- Missing product dimensions.
- Missing product weight.
- Missing product image count.
- Invalid category names.
- Zero or negative product dimensions.
- Zero or negative product weight.
- Incomplete product metadata.

---

## Observations

- Product prices are **not stored** in this table.
- Historical selling prices are stored in the **Order Items** table.
- Product dimensions are useful for logistics and shipping calculations.
- Product weight directly affects shipping costs.
- Product categories require translation using the **Category Translation** table.
- This table stores descriptive product information rather than transactional sales data.

---

## Relationships

| Parent Table         | Child Table | Relationship |
| -------------------- | ----------- | ------------ |
| Products             | Order Items | One-to-Many  |
| Category Translation | Products    | One-to-Many  |

---

## Future SQL Analysis

This table can be used for:

- Product Category Analysis
- Product Catalog Analysis
- Product Dimension Analysis
- Product Weight Analysis
- Product Distribution Analysis
- Product Popularity Analysis
- Revenue by Product Category
- Best Selling Products
- Least Selling Products
- Catalog Quality Analysis

---

## Interview Notes

Possible interview questions related to this table:

- Why is the product price not stored in the Products table?
- Why are product dimensions stored in this table?
- How do product dimensions affect logistics?
- Why is `product_category_name_translation` stored in a separate table?
- Which table should be joined to calculate product revenue?
- Can a product exist without being ordered?
- How would you find products that have never been sold?
- Why is this considered a dimension table rather than a transaction table?
