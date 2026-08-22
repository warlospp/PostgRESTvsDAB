----------
-- CURL --
----------
http://localhost:5000/api/clients?$select=client_id,first_name,last_name

---------------
-- Modificar --
---------------
-- MSSQL
--Levantar Profiler
UPDATE dbo.clients
SET first_name = 'SSSSSSSSSSSSSS'

--PostgreSQL
SELECT pg_stat_statements_reset();

UPDATE clients
SET first_name = 'SSSSSSSSSSSSSS'

SELECT
    calls,
    total_exec_time,
    rows,
    query
FROM pg_stat_statements
WHERE query ILIKE '%clients%'
ORDER BY calls DESC;