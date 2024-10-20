--Concatena en una sola coluna los campos nombre y apellido
SELECT CONCAT('Nombre:', name, ', Apellidos:', surname) FROM user
--Concatena en una sola coluna los campos nombre y apellido y le establece el alias Nombre
SELECT CONCAT('Nombre:', name, ', Apellidos:', surname) AS 'Nombre completo:' FROM user