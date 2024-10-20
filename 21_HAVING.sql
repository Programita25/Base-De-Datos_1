--Cuenta cuantas filas contienen un dato no nulo en el campo edad de la tabla "users" mayor que 3
SELECT age,COUNT(*) FROM user group by age having COUNT(*) > 0