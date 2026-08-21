-- crear tabla de tipos de identificación (lower_snake_case)
CREATE TABLE dbo.identification_types
(
    identification_type_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    code NVARCHAR(50) NOT NULL CONSTRAINT uq_identification_types_code UNIQUE, -- e.g. 'CI', 'PAS'
    description NVARCHAR(200) NULL,
    created_at DATETIME2(3) NOT NULL CONSTRAINT df_identification_types_created_at DEFAULT (SYSUTCDATETIME())
);
GO

-- crear tabla clients (lower_snake_case) y referencia a identification_types
CREATE TABLE dbo.clients
(
    client_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY, -- surrogate PK
    customer_number NVARCHAR(20) NOT NULL CONSTRAINT uq_clients_customer_number UNIQUE, -- business identifier
    identification_type_id INT NOT NULL CONSTRAINT df_clients_identification_type_id DEFAULT (1),
    identification_number NVARCHAR(100) NULL,         -- número/valor del identificador
    first_name NVARCHAR(100) NOT NULL,
    last_name NVARCHAR(100) NOT NULL,
    email NVARCHAR(255) NULL,
    phone NVARCHAR(50) NULL,
    address_line1 NVARCHAR(200) NULL,
    address_line2 NVARCHAR(200) NULL,
    city NVARCHAR(100) NULL,
    state_province NVARCHAR(100) NULL,
    postal_code NVARCHAR(20) NULL,
    country NVARCHAR(100) NULL,
    date_of_birth DATE NULL,
    is_active BIT NOT NULL CONSTRAINT df_clients_is_active DEFAULT (1),
    created_at DATETIME2(3) NOT NULL CONSTRAINT df_clients_created_at DEFAULT (SYSUTCDATETIME()),
    modified_at DATETIME2(3) NULL,
    row_ver ROWVERSION NOT NULL,
    CONSTRAINT fk_clients_identification_type FOREIGN KEY (identification_type_id)
        REFERENCES dbo.identification_types (identification_type_id)
);
GO

-- vista que une clients con identification_types (lower_snake_case)
CREATE OR ALTER VIEW dbo.vw_clients_with_identification
AS
SELECT
    c.client_id,
    c.customer_number,
    c.identification_type_id,
    it.code AS identification_type_code,
    it.description AS identification_type_description,
    c.identification_number,
    c.first_name,
    c.last_name,
    c.email,
    c.phone,
    c.address_line1,
    c.address_line2,
    c.city,
    c.state_province,
    c.postal_code,
    c.country,
    c.date_of_birth,
    c.is_active,
    c.created_at,
    c.modified_at
FROM dbo.clients AS c
LEFT JOIN dbo.identification_types AS it
    ON c.identification_type_id = it.identification_type_id;
GO

-- procedimiento almacenado para insertar cliente y devolver el registro insertado (lower_snake_case)
CREATE OR ALTER PROCEDURE dbo.usp_insert_client
    @customer_number       NVARCHAR(20),
    @identification_type_id INT,
    @identification_number NVARCHAR(100) = NULL,
    @first_name            NVARCHAR(100),
    @last_name             NVARCHAR(100),
    @email                 NVARCHAR(255) = NULL,
    @phone                 NVARCHAR(50) = NULL,
    @address_line1         NVARCHAR(200) = NULL,
    @address_line2         NVARCHAR(200) = NULL,
    @city                  NVARCHAR(100) = NULL,
    @state_province        NVARCHAR(100) = NULL,
    @postal_code           NVARCHAR(20) = NULL,
    @country               NVARCHAR(100) = NULL,
    @date_of_birth         DATE = NULL,
    @is_active             BIT = 1,
    @new_client_id         INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;

        -- validar FK
        IF NOT EXISTS (SELECT 1 FROM dbo.identification_types WHERE identification_type_id = @identification_type_id)
        BEGIN
            THROW 51001, 'identification_type_id does not exist.', 1;
        END

        -- validar unicidad business key
        IF EXISTS (SELECT 1 FROM dbo.clients WHERE customer_number = @customer_number)
        BEGIN
            THROW 51002, 'customer_number already exists.', 1;
        END

        INSERT INTO dbo.clients
        (
            customer_number,
            identification_type_id,
            identification_number,
            first_name,
            last_name,
            email,
            phone,
            address_line1,
            address_line2,
            city,
            state_province,
            postal_code,
            country,
            date_of_birth,
            is_active
        )
        VALUES
        (
            @customer_number,
            @identification_type_id,
            @identification_number,
            @first_name,
            @last_name,
            @email,
            @phone,
            @address_line1,
            @address_line2,
            @city,
            @state_province,
            @postal_code,
            @country,
            @date_of_birth,
            @is_active
        );

        SET @new_client_id = CONVERT(INT, SCOPE_IDENTITY());

        COMMIT TRAN;

        -- devolver el registro insertado
        SELECT *
        FROM dbo.clients
        WHERE client_id = @new_client_id;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRAN;
        THROW;
    END CATCH;
END;
GO