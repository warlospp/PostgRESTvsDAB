----------
-- CURL --
----------
http://localhost:5000/api/clients?$select=client_id,first_name,last_name

---------------
-- Modificar --
---------------
-- MSSQL
UPDATE dbo.clients
SET first_name = 'SSSSSSSSSSSSSS'

--PostgreSQL
UPDATE clients
SET first_name = 'SSSSSSSSSSSSSS'