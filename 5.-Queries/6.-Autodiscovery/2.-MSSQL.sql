-----------
-- Drop --
----------
DROP TABLE client_identity_test

------------
-- Create --
------------
CREATE TABLE client_identity_test
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    client_name NVARCHAR(200) NOT NULL,
    ci NVARCHAR(20) NOT NULL
);


------------
-- Insert --
------------
INSERT INTO client_identity_test
(
    client_name,
    ci
)
VALUES
(
    'Luis Perez',
    '1712345678'
);

----------
-- CURL --
----------
curl http://localhost:5000/api/client_identity_test

