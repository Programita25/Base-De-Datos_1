SELECT Nombre, Nombre de contacto, Ciudad,Codigo postal, Pais, Direccion
FROM primer_programa; Extrae los elemtos que se encuentran dentro de las columnas seleccionadas

SELECT column1, column2, ...
FROM table_name; Selecciona los elementos dentro de la las columnas seleccionadas en column1 y column2

Si no tenemos seleccionado por defecto el esquema en el que estamos trabajando tendremos que poner el comando:
SELECT Nombre, Ciudad 
FROM sys.primer_programa;
EL sys representa el nombre del esquema en el que estamos trabajando.

//Statement SELECT DISTINCT
SELECT DISTINCT Pais 
FROM primer_programa;
// Este selecciona cada tipo de paises que hay dentro de la base de datos
sin importar cuantas veces esta el mismo dato dentro de la base de datos,
si los datos son todos diferentes los mostrara sin importar cuantos sean.