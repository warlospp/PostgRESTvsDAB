#######
# DDM #
#######

# Activar
ALTER TABLE dbo.Clients
ALTER COLUMN IdentificationNumber
ADD MASKED WITH (FUNCTION = 'default()');

ALTER TABLE dbo.Clients
ALTER COLUMN Email
ADD MASKED WITH (FUNCTION = 'partial(2,"XXXXXXX",2)');

# Desactivar
ALTER TABLE dbo.Clients
ALTER COLUMN IdentificationNumber
DROP MASKED;
GO

ALTER TABLE dbo.Clients
ALTER COLUMN Email
DROP MASKED;
GO