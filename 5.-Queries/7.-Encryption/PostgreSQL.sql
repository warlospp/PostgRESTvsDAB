---------------
-- Extention --
---------------
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-----------
-- Drop --
----------
DROP TABLE public.client_identity_test

------------
-- Create --
------------
CREATE TABLE public.client_identity_test
(
    id BIGSERIAL PRIMARY KEY,
    client_name VARCHAR(200) NOT NULL,
    ci VARCHAR(20) NOT NULL,
	ci_encrypted BYTEA
);

-----------------
-- Permission  --
-----------------
GRANT SELECT ON TABLE public.client_identity_test
TO demo_readonly_user;

------------
-- Insert --
------------
INSERT INTO public.client_identity_test
(
    client_name,
    ci,
	ci_encrypted
)
VALUES
(
    'Luis Perez',
    '1712345678',
	pgp_sym_encrypt('1712345678','MiClaveDemo2026')
);

----------
-- CURL --
----------
curl http://localhost:3000/client_identity_test

-------------------
-- Refrech Cache --
-------------------
NOTIFY pgrst, 'reload schema';
