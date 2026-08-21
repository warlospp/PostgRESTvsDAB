#######
# DDM #
#######

# Activar
ALTER TABLE dbo.clients
ALTER COLUMN identification_number
ADD MASKED WITH (FUNCTION = 'default()');

ALTER TABLE dbo.clients
ALTER COLUMN email
ADD MASKED WITH (FUNCTION = 'partial(2,"XXXXXXX",2)');

# Desactivar
ALTER TABLE dbo.clients
ALTER COLUMN identification_number
DROP MASKED;
GO

ALTER TABLE dbo.clients
ALTER COLUMN email
DROP MASKED;
GO