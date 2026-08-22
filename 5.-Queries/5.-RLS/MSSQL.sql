-- 1) Tabla de mapeo para RLS
CREATE TABLE dbo.user_client_access
(
    user_name SYSNAME NOT NULL,
    client_id INT NOT NULL,
    CONSTRAINT pk_user_client_access PRIMARY KEY (user_name, client_id)
);
GO

-- 2) Función predicate para RLS (schema-bound) 
-- Nota: la función usa SESSION_CONTEXT('app_user') o USER_NAME() para identificar usuario.
CREATE OR ALTER FUNCTION dbo.fn_rls_client_access(@client_id INT)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN
(
    SELECT 1 AS allow_access
    WHERE
        -- excepción: miembro db_owner o usuario de base de datos demo_owner_user
        IS_MEMBER('db_owner') = 1
        OR USER_NAME() = N'demo_owner_user'
        OR SUSER_SNAME() = N'demo_owner_login'
        -- acceso explícito por mapeo (usa SESSION_CONTEXT('app_user') si la app lo establece)
        OR EXISTS (
            SELECT 1
            FROM dbo.user_client_access u
            WHERE u.client_id = @client_id
              AND u.user_name = ISNULL(CONVERT(sysname, SESSION_CONTEXT(N'app_user')), USER_NAME())
        )
);
GO

-- 3) Security policy (aplica sobre dbo.clients)
CREATE SECURITY POLICY dbo.security_policy_clients
    ADD FILTER PREDICATE dbo.fn_rls_client_access(client_id) ON dbo.clients
WITH (STATE = ON);
GO

-- 4) Ejemplos de uso y administración
-- Dar acceso a demo_readonly_user al client_id = 1 (mapeo RLS)
INSERT INTO dbo.user_client_access (user_name, client_id)
SELECT N'demo_readonly_user', 1
WHERE NOT EXISTS (SELECT 1 FROM dbo.user_client_access WHERE user_name = N'demo_readonly_user' AND client_id = 1);
GO

-- DROPS
DROP SECURITY POLICY dbo.security_policy_clients;
GO
DROP FUNCTION dbo.fn_rls_client_access;
GO
DROP TABLE dbo.user_client_access;