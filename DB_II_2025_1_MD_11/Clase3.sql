/* Estructuras de Tablas para ejemplo de Clase*/
offset 50 //salta el numero que quiere y muestra los sigientes o omitir ejemplo:para que no se muestren esos primeros 20
drop table cliente;
drop table pedido;

CREATE TABLE cliente (
    id_cliente SERIAL PRIMARY KEY,
    nombres VARCHAR(30) NOT NULL,
    apellidos VARCHAR(30) NOT NULL,
    correo VARCHAR(256) UNIQUE
);

CREATE TABLE pedido(
    id_pedido SERIAL PRIMARY KEY,
    id_cliente INT,
    fecha DATE,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE
);

create table producto(
	id_producto serial primary key,
	nombre varchar(100),
	valor_unitario float
);

create table detalle_pedido(
	id_pedido int,
	id_producto int,
	cantidad int,
	valor_unitario_registrado float,
	PRIMARY KEY (id_pedido,id_producto),
	FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido) ON DELETE CASCADE,
	FOREIGN KEY (id_producto) REFERENCES producto(id_producto) ON DELETE CASCADE
);

/*Poblar las tablas para el ejercicio de clase */
INSERT INTO public.cliente
(nombres, apellidos, correo)
VALUES
('Pepito', 'Perez', 'pepito@gmail.com'),
('Juan', 'Gonzales', 'juan@outlook.es'),
('Katerine', 'Jimenez', 'kate@gmail.com'),
('Angélica', 'Santamaría', 'angelica@hotmail.com'),
('Roberto', 'Gomez', 'chavo@gmail.com'),
('Prueba','sistema','prueba@gmail.com');

INSERT INTO public.producto
(nombre, valor_unitario)
VALUES('Monitor Lg 27 Pulgadas', 500000),
('Portatil Asus 8Gb Core I5', 2000000),
('Teclado Logitech K950', 350000),
('Monitor Samsung 24 Pulgadas', 400000),
('SSD Kingston 1TB', 250000),
('Pad Mouse Esenses', 40000);


INSERT INTO public.pedido
(id_cliente, fecha)
VALUES(1, '2024-11-22'),
(2, '2024-12-05'),
(3, '2024-12-20'),
(4, '2025-01-05');


INSERT INTO public.detalle_pedido
(id_pedido, id_producto, cantidad, valor_unitario_registrado)
VALUES(1, 2, 1, 2000000),
(2, 3, 1, 350000),
(2, 4, 1, 400000),
(3, 1, 1, 500000),
(3, 5, 1, 250000),
(4, 1, 1, 500000),
(4, 4, 2, 400000);


--CONSULTAS
select * from cliente;

select id_cliente,nombres, apellidos from cliente;

select * from cliente where nombres = 'Katerine';

-- UPDATE
update cliente
set correo = 'juango@outlook.es'
where nombres = 'Juan';

-- DELETE
delete from cliente
where nombres = 'Prueba';

--FUNCIONES AGREGADAS

--consultar el valor promedio de los productos en base de datos
select count(*) as numero_productos, avg(valor_unitario) as valor_promedio 
from producto;

--consultar el costo del producto más caro
select max(valor_unitario)
from producto;

--Consultar la suma de las ventas en todos los pedidos
select sum(valor_unitario_registrado)
from detalle_pedido;


--GROUP BY
-- Consultar el total de ventas por producto
select
	dp.id_producto,
	p.nombre,
	sum(dp.valor_unitario_registrado) as total_ventas,
	count(*) as unidades_vendidas
from detalle_pedido dp , producto p
where dp.id_producto = p.id_producto 
group by dp.id_producto, p.nombre;



-- JOINS

--Unir los datos de la tabla cliente con sus pedidos.
select * 
from cliente c
inner join pedido p
on c.id_cliente  = p.id_cliente;

--Unir los datos de la tabla cliente, pedido, detalle pedido y producto
select * 
from cliente c
inner join pedido p
on c.id_cliente  = p.id_cliente
inner join detalle_pedido dp 
on p.id_pedido = dp.id_pedido 
inner join producto p2 
on p2.id_producto = dp.id_producto;

-- LEFT JOIN
select * 
from cliente c
left join pedido p
on c.id_cliente  = p.id_cliente;

-- RIGHT JOIN
select * 
from detalle_pedido dp
right join producto p
on p.id_producto  = dp.id_producto;

-- FULL JOIN
select * 
from cliente c
full join pedido p
on c.id_cliente  = p.id_cliente
full join detalle_pedido dp 
on p.id_pedido = dp.id_pedido 
full join producto p2 
on p2.id_producto = dp.id_producto;

--CONSULTAS ANIDADAS
--producto con más unidades vendidas
select p.nombre, p.valor_unitario
from producto p,(
	select id_producto , count(*) as unidades_vendidas 
	from detalle_pedido 
	group by id_producto
	order by unidades_vendidas desc
	limit 1
) as mas_vendido 
where P.id_producto = mas_vendido.id_producto;


--Indices
create index idx_nombre ON cliente(nombres);