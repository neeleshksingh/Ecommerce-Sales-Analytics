/*
===============================================================================
Index Summary
===============================================================================
*/

SELECT
    schemaname,
    tablename,
    indexname
FROM pg_indexes
WHERE schemaname='public'
ORDER BY tablename, indexname;

SELECT
'Indexes created successfully.'
AS status;