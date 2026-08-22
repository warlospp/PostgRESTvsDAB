-- 1) Tabla de mapeo para RLS
CREATE TABLE user_client_access
(
    user_name VARCHAR(100) NOT NULL,
    client_id INTEGER NOT NULL,

    CONSTRAINT pk_user_client_access
        PRIMARY KEY (user_name, client_id),

    CONSTRAINT fk_user_client_access_client
        FOREIGN KEY (client_id)
        REFERENCES clients (client_id)
);

-- 2) Función predicate para RLS (schema-bound) 
-- Nota: la función usa SESSION_CONTEXT('app_user') o USER_NAME() para identificar usuario.
CREATE OR REPLACE FUNCTION fn_rls_client_access(
    p_client_id INTEGER
)
RETURNS BOOLEAN
LANGUAGE plpgsql
STABLE
SECURITY INVOKER
AS $$
DECLARE
    v_app_user TEXT;
BEGIN

    -- Usuario enviado por la aplicación
    v_app_user := current_setting('app.user', true);

    -- Si no existe app.user, utilizar usuario PostgreSQL
    IF v_app_user IS NULL OR v_app_user = '' THEN
        v_app_user := current_user;
    END IF;

    -- Excepción: propietario/superusuario
    IF current_user = 'demo_owner_user'
       OR pg_has_role(current_user, 'demo_owner_user', 'member')
       OR current_user = 'postgres'
    THEN
        RETURN TRUE;
    END IF;

    -- Acceso explícito al cliente
    RETURN EXISTS
    (
        SELECT 1
        FROM user_client_access u
        WHERE u.client_id = p_client_id
          AND u.user_name = v_app_user
    );

END;
$$;

-- 3) Habilitar RLS (aplica sobre dbo.clients)
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;

-- 4) Security policy (aplica sobre dbo.clients)
CREATE POLICY security_policy_clients
ON clients
FOR SELECT
USING (
    fn_rls_client_access(client_id)
);

-- 5) Ejemplos de uso y administración
-- Dar acceso a demo_readonly_user al client_id = 1 (mapeo RLS)
INSERT INTO user_client_access
(
    user_name,
    client_id
)
SELECT
    'demo_readonly_user',
    1
WHERE NOT EXISTS
(
    SELECT 1
    FROM user_client_access
    WHERE user_name = 'demo_readonly_user'
      AND client_id = 1
);

-- 5) Aplciar permisos de lectura a demo_readonly_user
GRANT USAGE ON SCHEMA public
TO demo_readonly_user;

GRANT SELECT
ON user_client_access
TO demo_readonly_user;

GRANT SELECT
ON clients
TO demo_readonly_user;

GRANT SELECT
ON identification_types
TO demo_readonly_user;

GRANT SELECT
ON vw_clients_with_identification
TO demo_readonly_user;

--DROPS
DROP POLICY IF EXISTS security_policy_clients ON clients;
DROP FUNCTION IF EXISTS fn_rls_client_access(INTEGER);
DROP TABLE IF EXISTS user_client_access;
ALTER TABLE clients DISABLE ROW LEVEL SECURITY;
