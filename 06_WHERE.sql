--Filtra todos los datos de la tabla users con edad igual a 15
SELECT * FROM users WHERE age=15;
--Filtra todos los nombres de la tabla "users" con edad igual
SELECT surname FROM user WHERE age = 15;
--Filtra todos los nombres distintos de la tabla "users"
SELECT DISTINCT surname FROM user WHERE age = 15;
--Filtra todas las edades distintas de la tabla "users" 
SELECT DISTINCT age FROM user WHERE age = 20;