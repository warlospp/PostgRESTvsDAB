-- 1) Create SQL login for read-only user (if not exists)
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'demo_readonly_user')
BEGIN
    CREATE LOGIN [demo_readonly_user]
    WITH PASSWORD = N'Admin.123', CHECK_POLICY = ON;
END;
GO

-- 2) Create database user in bdd_demo and add to db_datareader
USE [bdd_demo];
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'demo_readonly_user')
BEGIN
    CREATE USER [demo_readonly_user] FOR LOGIN [demo_readonly_user];
    ALTER ROLE db_datareader ADD MEMBER [demo_readonly_user];
END;
GO

-- 3) Create SQL login for db_owner user (if not exists)
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'demo_owner_user')
BEGIN
    CREATE LOGIN [demo_owner_user]
    WITH PASSWORD = N'Admin.123', CHECK_POLICY = ON;
END;
GO

-- 4) Create database user in demo and add to db_owner
USE [bdd_demo];
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'demo_owner_user')
BEGIN
    CREATE USER [demo_owner_user] FOR LOGIN [demo_owner_user];
    ALTER ROLE db_owner ADD MEMBER [demo_owner_user];
END;
GO

