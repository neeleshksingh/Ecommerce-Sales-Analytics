/*
===============================================================================
File        : 02_document_data_quality_exceptions.sql
Description : Documents known data quality exceptions identified during the
              validation phase. These records are intentionally NOT modified
              because they represent valid business scenarios or source dataset
              limitations.
===============================================================================
*/

-- ============================================================================
-- Exception 1 : Orders with zero payment value
-- ============================================================================

SELECT
    'Orders with payment_value = 0' AS exception_name,
    COUNT(*) AS affected_rows
FROM order_payments
WHERE payment_value = 0;

-- ============================================================================
-- Exception 2 : Orders with zero payment installments
-- ============================================================================

SELECT
    'Orders with payment_installments = 0' AS exception_name,
    COUNT(*) AS affected_rows
FROM order_payments
WHERE payment_installments = 0;

-- ============================================================================
-- Exception 3 : Product categories missing English translation
-- ============================================================================

SELECT
    'Missing category translations' AS exception_name,
    COUNT(*) AS affected_rows
FROM products p
LEFT JOIN product_category_translation t
       ON p.product_category_name = t.product_category_name
WHERE t.product_category_name IS NULL;

SELECT
    DISTINCT p.product_category_name
FROM products p
LEFT JOIN product_category_translation t
       ON p.product_category_name = t.product_category_name
WHERE t.product_category_name IS NULL
ORDER BY p.product_category_name;

-- ============================================================================
-- Summary
-- ============================================================================

SELECT
'No records were modified during the cleaning process.
All exceptions have been documented for transparency.'
AS cleaning_note;