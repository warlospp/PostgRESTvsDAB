-- Semilla de ejemplo (ajuste o elimine según su modelo)
INSERT INTO identification_types (code, description)
VALUES
    ('CI', 'Cédula de identidad'),
    ('PAS', 'Pasaporte'),
    ('RUC', 'Registro único / NIT');

-- Sample INSERTs for dbo.Clients (15 rows)
INSERT INTO clients
    (customer_number, identification_type_id, identification_number,
     first_name, last_name, email, phone, address_line1, city,
     state_province, postal_code, country, date_of_birth, is_active)
VALUES
    ('CUST0001', 1, '12345678', 'Ana', 'Gonzalez',
     'ana.gonzalez@example.com', '+593987654321', 'Av. Siempre Viva 100',
     'Quito', 'Pichincha', '170103', 'Ecuador', '1985-04-12', TRUE),

    ('CUST0002', 2, 'P1234567', 'Carlos', 'Martinez',
     'c.martinez@example.com', '+593998877665', '1st St. 200',
     'Guayaquil', 'Guayas', '090101', 'Ecuador', '1990-11-05', TRUE),

    ('CUST0003', 1, '87654321', 'Maria', 'Lopez',
     'maria.lopez@example.com', '+593912345678', 'Los Olivos 45',
     'Cuenca', 'Azuay', '010203', 'Ecuador', '1978-07-20', TRUE),

    ('CUST0004', 3, '20123456789', 'Empresa', 'XYZ S.A.',
     'contacto@xyzsa.example', '+593222334455', 'Industrial Park 10',
     'Quito', 'Pichincha', '170000', 'Ecuador', NULL, TRUE),

    ('CUST0005', 1, '11223344', 'Luis', 'Fernandez',
     'luis.fernandez@example.com', '+593999111222', 'Boulevard 77',
     'Loja', 'Loja', '110101', 'Ecuador', '1982-02-28', TRUE),

    ('CUST0006', 2, 'P7654321', 'Isabel', 'Vega',
     'isabel.vega@example.com', '+593986543210', 'Camino Real 9',
     'Machala', 'El Oro', '070101', 'Ecuador', '1995-09-15', TRUE),

    ('CUST0007', 1, '55667788', 'Jorge', 'Ruiz',
     'jorge.ruiz@example.com', '+593995544332', 'Ruta 5 Km 3',
     'Ambato', 'Tungurahua', '180101', 'Ecuador', '1970-01-30', FALSE),

    ('CUST0008', 1, '66778899', 'Paola', 'Quintero',
     'paola.quintero@example.com', '+593984422110', 'Plaza Central 12',
     'Riobamba', 'Chimborazo', '060101', 'Ecuador', '1998-06-02', TRUE),

    ('CUST0009', 3, '20987654321', 'Constructora', 'ABC Ltda',
     'admin@abcltda.example', '+593243210987', 'Avenida Obra 50',
     'Guayaquil', 'Guayas', '090202', 'Ecuador', NULL, TRUE),

    ('CUST0010', 2, 'P9998887', 'Ricardo', 'Paredes',
     'ricardo.paredes@example.com', '+593971234567', 'Col. Las Flores 5',
     'Esmeraldas', 'Esmeraldas', '080101', 'Ecuador', '1988-12-10', TRUE),

    ('CUST0011', 1, '33445566', 'Lucia', 'Mora',
     'lucia.mora@example.com', '+593973210456', 'Venta Central 3',
     'Santo Domingo', 'Santo Domingo', '140101', 'Ecuador', '1992-03-22', TRUE),

    ('CUST0012', 1, '44556677', 'Fernando', 'Castillo',
     'fernando.castillo@example.com', '+593972211334', 'Barrio Alto 18',
     'Latacunga', 'Cotopaxi', '150101', 'Ecuador', '1975-05-18', TRUE),

    ('CUST0013', 2, 'P5554443', 'Natalia', 'Soto',
     'natalia.soto@example.com', '+593975331122', 'Pasaje 2 #4-6',
     'Babahoyo', 'Los Rios', '120101', 'Ecuador', '2000-08-09', TRUE),

    ('CUST0014', 1, '99887766', 'Victor', 'Benitez',
     'victor.benitez@example.com', '+593976543210', 'Avenida Norte 88',
     'Milagro', 'Guayas', '091001', 'Ecuador', '1969-10-30', FALSE),

    ('CUST0015', 3, '20333444556', 'Proveedor', 'SERV S.A.',
     'info@servsa.example', '+593211223344', 'Zona Comercial 40',
     'Quito', 'Pichincha', '170201', 'Ecuador', NULL, TRUE);

-- -- The procedure returns the inserted row as a result set and @Id contains the new ClientID.
SELECT *
FROM usp_insert_client(
    p_customer_number         => 'CUST100',
    p_identification_type_id  => 1,
    p_first_name              => 'John',
    p_last_name               => 'Doe',
    p_identification_number   => '12345678',
    p_email                   => 'john.doe@example.com'
);
