--Obtiene todos datos de la tabla "users" que contienen un email con el texto "gmail.com" en su parte final 
SELECT FROM users WHERE email LIKE '%gmail.com;
--Obtiene todos datos de la tabla "users" que contienen un email con el texto "sara" en su parte inicial
SELECT * FROM user WHERE email LIKE "sara%";
--Obtiene todos datos de la tabla "users" que contienen un email una arroba 
SELECT * FROM user WHERE email LIKE "%@%";