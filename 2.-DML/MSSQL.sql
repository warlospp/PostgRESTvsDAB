-- Reinciar secuencia
delete from dbo.clients:

DBCC CHECKIDENT ('clients', RESEED, 0);

-- semilla de ejemplo (lower_snake_case)
INSERT INTO dbo.identification_types (code, description)
VALUES
    (N'CI', N'Cédula de identidad'),
    (N'PAS', N'Pasaporte'),
    (N'RUC', N'Registro único / NIT');

-- Inserts de ejemplo para dbo.clients (15 filas, lower_snake_case)
INSERT INTO dbo.clients
    (customer_number, identification_type_id, identification_number, first_name, last_name, email, phone, address_line1, city, state_province, postal_code, country, date_of_birth, is_active)
VALUES
    (N'CUST0001', 1, N'12345678', N'Ana', N'Gonzalez', N'ana.gonzalez@example.com', N'+593987654321', N'Av. Siempre Viva 100', N'Quito', N'Pichincha', N'170103', N'Ecuador', '1985-04-12', 1),
    (N'CUST0002', 2, N'P1234567', N'Carlos', N'Martinez', N'c.martinez@example.com', N'+593998877665', N'1st St. 200', N'Guayaquil', N'Guayas', N'090101', N'Ecuador', '1990-11-05', 1),
    (N'CUST0003', 1, N'87654321', N'Maria', N'Lopez', N'maria.lopez@example.com', N'+593912345678', N'Los Olivos 45', N'Cuenca', N'Azuay', N'010203', N'Ecuador', '1978-07-20', 1),
    (N'CUST0004', 3, N'20123456789', N'Empresa', N'XYZ S.A.', N'contacto@xyzsa.example', N'+593222334455', N'Industrial Park 10', N'Quito', N'Pichincha', N'170000', N'Ecuador', NULL, 1),
    (N'CUST0005', 1, N'11223344', N'Luis', N'Fernandez', N'luis.fernandez@example.com', N'+593999111222', N'Boulevard 77', N'Loja', N'Loja', N'110101', N'Ecuador', '1982-02-28', 1),
    (N'CUST0006', 2, N'P7654321', N'Isabel', N'Vega', N'isabel.vega@example.com', N'+593986543210', N'Camino Real 9', N'Machala', N'El Oro', N'070101', N'Ecuador', '1995-09-15', 1),
    (N'CUST0007', 1, N'55667788', N'Jorge', N'Ruiz', N'jorge.ruiz@example.com', N'+593995544332', N'Ruta 5 Km 3', N'Ambato', N'Tungurahua', N'180101', N'Ecuador', '1970-01-30', 0),
    (N'CUST0008', 1, N'66778899', N'Paola', N'Quintero', N'paola.quintero@example.com', N'+593984422110', N'Plaza Central 12', N'Riobamba', N'Chimborazo', N'060101', N'Ecuador', '1998-06-02', 1),
    (N'CUST0009', 3, N'20987654321', N'Constructora', N'ABC Ltda', N'admin@abcltda.example', N'+593243210987', N'Avenida Obra 50', N'Guayaquil', N'Guayas', N'090202', N'Ecuador', NULL, 1),
    (N'CUST0010', 2, N'P9998887', N'Ricardo', N'Paredes', N'ricardo.paredes@example.com', N'+593971234567', N'Col. Las Flores 5', N'Esmeraldas', N'Esmeraldas', N'080101', N'Ecuador', '1988-12-10', 1),
    (N'CUST0011', 1, N'33445566', N'Lucia', N'Mora', N'lucia.mora@example.com', N'+593973210456', N'Venta Central 3', N'Santo Domingo', N'Santo Domingo', N'140101', N'Ecuador', '1992-03-22', 1),
    (N'CUST0012', 1, N'44556677', N'Fernando', N'Castillo', N'fernando.castillo@example.com', N'+593972211334', N'Barrio Alto 18', N'Latacunga', N'Cotopaxi', N'150101', N'Ecuador', '1975-05-18', 1),
    (N'CUST0013', 2, N'P5554443', N'Natalia', N'Soto', N'natalia.soto@example.com', N'+593975331122', N'Pasaje 2 #4-6', N'Babahoyo', N'Los Rios', N'120101', N'Ecuador', '2000-08-09', 1),
    (N'CUST0014', 1, N'99887766', N'Victor', N'Benitez', N'victor.benitez@example.com', N'+593976543210', N'Avenida Norte 88', N'Milagro', N'Guayas', N'091001', N'Ecuador', '1969-10-30', 0),
    (N'CUST0015', 3, N'20333444556', N'Proveedor', N'SERV S.A.', N'info@servsa.example', N'+593211223344', N'Zona Comercial 40', N'Quito', N'Pichincha', N'170201', N'Ecuador', NULL, 1);

-- ejemplo de uso del procedimiento (lower_snake_case)
DECLARE @id INT;
EXEC dbo.usp_insert_client
     @customer_number = N'CUST100',
     @identification_type_id = 1,
     @identification_number = N'12345678',
     @first_name = N'John',
     @last_name = N'Doe',
     @email = N'john.doe@example.com',
     @new_client_id = @id OUTPUT;