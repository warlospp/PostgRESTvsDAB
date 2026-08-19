-- 1) Create SQL login for read-only user (if not exists)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_roles
        WHERE rolname = 'demo_readonly_user'
    ) THEN
        CREATE ROLE demo_readonly_user
            LOGIN
            PASSWORD 'Admin.123';
    END IF;
END
$$;

GRANT CONNECT ON DATABASE bdd_demo
TO demo_readonly_user;

-- 2) Create database user in bdd_demo and add to db_datareader
GRANT USAGE ON SCHEMA public
TO demo_readonly_user;

GRANT SELECT ON ALL TABLES IN SCHEMA public
TO demo_readonly_user;

GRANT SELECT ON ALL SEQUENCES IN SCHEMA public
TO demo_readonly_user;

-- 3) Create SQL login for db_owner user (if not exists)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_roles
        WHERE rolname = 'demo_owner_user'
    ) THEN
        CREATE ROLE demo_owner_user
            LOGIN
            PASSWORD 'Admin.123';
    END IF;
END
$$;

GRANT ALL PRIVILEGES
ON DATABASE bdd_demo
TO demo_owner_user;

-- 4) Create database user in demo and add to db_owner
GRANT ALL PRIVILEGES
ON ALL TABLES IN SCHEMA public
TO demo_owner_user;

GRANT ALL PRIVILEGES
ON ALL SEQUENCES IN SCHEMA public
TO demo_owner_user;

GRANT ALL PRIVILEGES
ON ALL FUNCTIONS IN SCHEMA public
TO demo_owner_user;

GRANT USAGE, CREATE
ON SCHEMA public
TO demo_owner_user;



