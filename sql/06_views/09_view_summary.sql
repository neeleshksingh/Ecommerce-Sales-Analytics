/*
===============================================================================
File        : 09_view_summary.sql
Description : Lists all views available in the Ecommerce Sales Analytics
              database.
===============================================================================
*/

SELECT
    table_schema,
    table_name AS view_name
FROM information_schema.views
WHERE table_schema = 'public'
ORDER BY table_name;

SELECT
    'All analytical views created successfully.' AS status;