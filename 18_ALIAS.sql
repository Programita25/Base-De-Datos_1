--Establece el alias Fecha de inicio en programación a la columna init date 
SELECT name, init date AS 'Fecha de inicio en programación' FROM users WHERE name = 'Brais'
--Consulta igual que la anterior. Representa la posibilidad de usar comillas dobles 
SELECT name, init date AS "Fecha de inicio en programación" FROM users WHERE name = "Brais"