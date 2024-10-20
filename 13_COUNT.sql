--Cuenta cuantas filas contiene la tabla "users" 
Select COUNT(*) FROM users;
-- Cuenta cuantas filas contienen un dato no nulo en el campo edad 
Select COUNT(age) FROM users;