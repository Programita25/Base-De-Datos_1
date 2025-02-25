-- Crear la tabla para almacenar los datos del formulario
CREATE TABLE formulario (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    mensaje TEXT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
--Claves foraneas en cualquier tabla
CREATE TABLE pedidos (
    id SERIAL PRIMARY KEY,
    fecha DATE NOT NULL,
    id_cliente INT NOT NULL REFERENCES clientes(id_cliente) ON DELETE CASCADE --LLave foranea Referenciado con tabla de llave primaria 
);


-- Insertar registros en la tabla
INSERT INTO formulario (nombre, email, mensaje) 
VALUES 
('Juan Perez', 'juan.perez@example.com', 'Este es un mensaje de prueba.'),
('Maria Lopez', 'maria.lopez@example.com', 'Hola, me gustaría saber más sobre sus servicios.'),
('Carlos Martinez', 'carlos.martinez@example.com', 'Gracias por la información proporcionada.'),
('Ana Gonzalez', 'ana.gonzalez@example.com', 'Estoy interesada en sus productos.'),
('Luis Rodriguez', 'luis.rodriguez@example.com', '¿Pueden enviarme más detalles?');

-- Consultar todos los registros de la tabla
SELECT * FROM formulario;

-- Consultar un registro específico por ID
SELECT * FROM formulario WHERE id = 1;

-- Consultar registros que cumplen con una condición (email que contiene 'example.com')
SELECT * FROM formulario WHERE email LIKE '%example.com';

-- Ordenar los registros por fecha descendente
SELECT * FROM formulario ORDER BY fecha DESC;

-- Actualizar un registro específico (id = 1)
UPDATE formulario
SET nombre = 'Juan Pérez', mensaje = 'Este es un mensaje actualizado.'
WHERE id = 1;

-- Eliminar un registro específico (id = 3)
DELETE FROM formulario WHERE id = 3;

-- Contar el número de registros en la tabla
SELECT COUNT(*) FROM formulario;

-- Obtener los registros más recientes (limitando a los 2 más recientes)
SELECT * FROM formulario ORDER BY fecha DESC LIMIT 2;

-- Obtener registros agrupados por dominio de correo electrónico
SELECT substring(email from '@(.*)$') AS dominio, COUNT(*) as cantidad
FROM formulario
GROUP BY dominio;

-- Obtener el nombre y mensaje de los registros, excluyendo los mensajes vacíos
SELECT nombre, mensaje FROM formulario WHERE mensaje IS NOT NULL AND mensaje != '';

-- Obtener los registros que contienen una palabra específica en el mensaje (ejemplo: 'gracias')
SELECT * FROM formulario WHERE mensaje ILIKE '%gracias%';

-- Consultar registros con paginación (ejemplo: página 1, 2 registros por página)
SELECT * FROM formulario ORDER BY fecha DESC LIMIT 2 OFFSET 0; -- Página 1
SELECT * FROM formulario ORDER BY fecha DESC LIMIT 2 OFFSET 2; -- Página 2

-- Consultar registros por rango de fechas
SELECT * FROM formulario WHERE fecha BETWEEN '2025-02-01' AND '2025-02-20';

-- Obtener registros únicos por campo de email
SELECT DISTINCT email FROM formulario;

-- Obtener la longitud del mensaje de cada registro
SELECT id, nombre, LENGTH(mensaje) AS longitud_mensaje FROM formulario;

-- Obtener registros con nombres que empiezan con una letra específica (ejemplo: 'M')
SELECT * FROM formulario WHERE nombre LIKE 'M%';

-- Obtener el registro más antiguo en la tabla
SELECT * FROM formulario ORDER BY fecha ASC LIMIT 1;

-- Obtener el registro más reciente en la tabla
SELECT * FROM formulario ORDER BY fecha DESC LIMIT 1;

-- Contar el número de registros por nombre
SELECT nombre, COUNT(*) as cantidad FROM formulario GROUP BY nombre;

-- Consultar registros que no cumplen con una condición (email que no contiene 'example.com')
SELECT * FROM formulario WHERE email NOT LIKE '%example.com';

-- Obtener registros con un campo específico en minúsculas (nombre en minúsculas)
SELECT id, LOWER(nombre) as nombre_minusculas FROM formulario;

--Obtener los clientes que han realizado al menos una compra, sin repetir nombres.
SELECT DISTINCT c.nombre 
FROM clientes c 
JOIN ventas v ON c.id_cliente = v.id_cliente;