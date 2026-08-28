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
    ci VARCHAR(20) NOT NULL
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
curl http://localhost:3000/client_identity_test

-------------------
-- Refrech Cache --
-------------------
NOTIFY pgrst, 'reload schema';
