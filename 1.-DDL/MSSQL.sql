-- Crear tabla de tipos de identificación si no existe
CREATE TABLE dbo.IdentificationTypes
(
    IdentificationTypeID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Code NVARCHAR(50) NOT NULL UNIQUE,           -- e.g. 'CI', 'PAS'
    Description NVARCHAR(200) NULL,
    CreatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_IdentificationTypes_CreatedAt DEFAULT (SYSUTCDATETIME())
);

-- Crear tabla Clients (solo si no existe) y referenciar IdentificationTypes
CREATE TABLE dbo.Clients
(
    ClientID INT IDENTITY(1,1) NOT NULL PRIMARY KEY, -- surrogate PK
    CustomerNumber NVARCHAR(20) NOT NULL UNIQUE,     -- business identifier
    IdentificationTypeID INT NOT NULL CONSTRAINT DF_Clients_IdentificationTypeID DEFAULT (1),
    IdentificationNumber NVARCHAR(100) NULL,         -- número/valor del identificador
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(255) NULL,
    Phone NVARCHAR(50) NULL,
    AddressLine1 NVARCHAR(200) NULL,
    AddressLine2 NVARCHAR(200) NULL,
    City NVARCHAR(100) NULL,
    StateProvince NVARCHAR(100) NULL,
    PostalCode NVARCHAR(20) NULL,
    Country NVARCHAR(100) NULL,
    DateOfBirth DATE NULL,
    IsActive BIT NOT NULL CONSTRAINT DF_Clients_IsActive DEFAULT (1),
    CreatedAt DATETIME2(3) NOT NULL CONSTRAINT DF_Clients_CreatedAt DEFAULT (SYSUTCDATETIME()),
    ModifiedAt DATETIME2(3) NULL,
    RowVer ROWVERSION NOT NULL,
    CONSTRAINT FK_Clients_IdentificationType FOREIGN KEY (IdentificationTypeID)
        REFERENCES dbo.IdentificationTypes (IdentificationTypeID)
);

-- Creates or alters a view that exposes clients with their identification type info
CREATE OR ALTER VIEW dbo.vwClientsWithIdentification
AS
SELECT
    c.ClientID,
    c.CustomerNumber,
    c.IdentificationTypeID,
    it.Code AS IdentificationTypeCode,
    it.Description AS IdentificationTypeDescription,
    c.IdentificationNumber,
    c.FirstName,
    c.LastName,
    c.Email,
    c.Phone,
    c.AddressLine1,
    c.AddressLine2,
    c.City,
    c.StateProvince,
    c.PostalCode,
    c.Country,
    c.DateOfBirth,
    c.IsActive,
    c.CreatedAt,
    c.ModifiedAt
FROM dbo.Clients AS c
LEFT JOIN dbo.IdentificationTypes AS it
    ON c.IdentificationTypeID = it.IdentificationTypeID;
GO

-- Create or alter a stored procedure that inserts a client and returns the inserted row
CREATE OR ALTER PROCEDURE dbo.usp_InsertClient
    @CustomerNumber       NVARCHAR(20),
    @IdentificationTypeID INT,
    @IdentificationNumber NVARCHAR(100) = NULL,
    @FirstName            NVARCHAR(100),
    @LastName             NVARCHAR(100),
    @Email                NVARCHAR(255) = NULL,
    @Phone                NVARCHAR(50) = NULL,
    @AddressLine1         NVARCHAR(200) = NULL,
    @AddressLine2         NVARCHAR(200) = NULL,
    @City                 NVARCHAR(100) = NULL,
    @StateProvince        NVARCHAR(100) = NULL,
    @PostalCode           NVARCHAR(20) = NULL,
    @Country              NVARCHAR(100) = NULL,
    @DateOfBirth          DATE = NULL,
    @IsActive             BIT = 1,
    @NewClientID          INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;

        -- Validate foreign key
        IF NOT EXISTS (SELECT 1 FROM dbo.IdentificationTypes WHERE IdentificationTypeID = @IdentificationTypeID)
        BEGIN
            THROW 51001, 'IdentificationTypeID does not exist.', 1;
        END

        -- Validate unique business key
        IF EXISTS (SELECT 1 FROM dbo.Clients WHERE CustomerNumber = @CustomerNumber)
        BEGIN
            THROW 51002, 'CustomerNumber already exists.', 1;
        END

        INSERT INTO dbo.Clients
        (
            CustomerNumber,
            IdentificationTypeID,
            IdentificationNumber,
            FirstName,
            LastName,
            Email,
            Phone,
            AddressLine1,
            AddressLine2,
            City,
            StateProvince,
            PostalCode,
            Country,
            DateOfBirth,
            IsActive
        )
        VALUES
        (
            @CustomerNumber,
            @IdentificationTypeID,
            @IdentificationNumber,
            @FirstName,
            @LastName,
            @Email,
            @Phone,
            @AddressLine1,
            @AddressLine2,
            @City,
            @StateProvince,
            @PostalCode,
            @Country,
            @DateOfBirth,
            @IsActive
        );

        SET @NewClientID = CONVERT(INT, SCOPE_IDENTITY());

        COMMIT TRAN;

        -- Return the inserted record
        SELECT *
        FROM dbo.Clients
        WHERE ClientID = @NewClientID;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRAN;

        THROW;
    END CATCH;
END;
GO
