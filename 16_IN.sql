--Si quieres seleccionar productos que pertenecen a las categorías "Móvil" y "Computación", puedes usar IN de la siguiente manera
SELECT *
FROM productos
WHERE categoria IN ('Móvil', 'Computación');