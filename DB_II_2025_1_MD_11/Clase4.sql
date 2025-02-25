
/* Funciones PL/pgSQL */
do $$
declare
	v_numero INTEGER:= 10;
begin
 	raise notice 'El valor es:%', v_numero;
end $$;

create function obtener_descuento(precio NUMERIC) returns numeric AS 
$$
begin
	return precio * 0.1;
end;
$$ 
language plpgsql;



select * from obtener_descuento(100);



/* Procedimientos PL/pgSQL */

/*Creamos una tabla de pruebas */
create table productos(
	id int primary key,
    nombre varchar(50),
    precio int
);

--Insertamos un registro
insert into producto values(1,'Mouse',10);

--Creamos el Procedimiento
create procedure actualizar_precio(id_registro INTEGER, precio_nuevo INTEGER)
language plpgsql
as $$
begin 
	update public.producto SET precio = precio_nuevo WHERE id= id_registro;
end;
$$;
end

--llamamos el procedimiento
call actualizar_precio(1,20);


/* Ejemplo Trigger PL/pgSQL */

--Creamos la tabla auditoria
create table auditoria(
    id serial primary key,
    id_auditoria_registro int,
    precio_antiguo int,
    precio_nuevo int,
    fecha date default now()
);

--Luego creamos la funcion asociada al Trigger
CREATE OR REPLACE FUNCTION auditoria_precios() returns trigger as $$
BEGIN
    INSERT INTO auditoria(id_auditoria_registro,precio_antiguo,precio_nuevo)
    VALUES (OLD.id,OLD.precio, NEW.precio);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Creamos el trigger para que se dispare después del update.
CREATE TRIGGER trg_auditoria_precios
AFTER UPDATE ON producto
FOR EACH ROW
EXECUTE FUNCTION auditoria_precios();

--Probamos actualizando el valor de un producto usando el procedimiento
call actualizar_precio(1,40);

--Esta consulta muestra todas las tablas del esquema public en la base de datos
select * from information_schema.tables where table_schema = 'public';

--Creamos la vista asociada a la consulta
create view vista_tablas_publico as 
select * from information_schema.tables where table_schema = 'public';

--Usamos la vista para acceder a los datos como si fuera una tabla.
select * from vista_tablas_publico;

--Crear vista materializada 
CREATE MATERIALIZED VIEW vista_mate_tablas_publico as 
select * from information_schema.tables where table_schema = 'public';

--Consultar vista Materializada
select * from vista_mate_tablas_publico;

--Crear tabla de pruebas
CREATE TABLE prueba(id serial primary key, nombre varchar(50));

--Actualizar Vista Materializada
REFRESH MATERIALIZED view vista_mate_tablas_publico;


/* TRANSACCIONES EN POSTGRESQL*/

--Tabla con cuentas
CREATE TABLE cuentas (
    id SERIAL PRIMARY KEY,
    userName varchar(50),
    saldo DECIMAL(10,2)
);

--Creamos dos cuentas
INSERT INTO cuentas (userName, saldo)
VALUES
('Pepito1',50000),
('Juanito1',150000);


--Inicio de la transacción 
BEGIN;

--Descontar el saldo de la cuenta origen
UPDATE cuentas SET saldo = saldo - 50000 WHERE id = 1;

--Consultar el nuevo saldo en cuenta origen para validar
select saldo from cuentas where id= 1;

-- Añadir saldo a la cuenta destino
UPDATE cuentas SET saldo = saldo + 50000 WHERE id = 2;

--Confirmar transacción si todo fue bien.
COMMIT;

--Si hay error
ROLLBACK;

/*Función como transacción */
CREATE OR REPLACE FUNCTION realizar_transferencia(
    p_cuenta_origen INT,  -- ID de la cuenta origen
    p_cuenta_destino INT, -- ID de la cuenta destino
    p_monto DECIMAL(10, 2) -- Monto a transferir
) RETURNS VOID AS $$
DECLARE
    saldo_origen DECIMAL(10, 2);
	text_var1 text;
BEGIN
    -- Consultar el saldo de la cuenta origen
    SELECT saldo INTO saldo_origen
    FROM cuentas
    WHERE id = p_cuenta_origen;

    -- Validar que exista la cuenta y que tenga saldo suficiente
    IF saldo_origen IS NULL THEN
        RAISE EXCEPTION 'La cuenta origen no existe.';
    ELSIF saldo_origen < p_monto THEN
        RAISE EXCEPTION 'Saldo insuficiente para realizar la transferencia.';
    END IF;

    -- Si todo está bien, se procede con la transacción
    UPDATE cuentas SET saldo = saldo - p_monto WHERE id = p_cuenta_origen;
    UPDATE cuentas SET saldo = saldo + p_monto WHERE id = p_cuenta_destino;

    -- Notificación de éxito
    RAISE NOTICE 'Transferencia realizada con éxito.';
    
EXCEPTION
    WHEN OTHERS THEN
		GET stacked DIAGNOSTICS text_var1 = MESSAGE_TEXT;
        RAISE NOTICE 'La transacción ha fallado y se ha revertido,%', text_var1;
        -- PostgreSQL se encargará de deshacer los cambios si ocurre un error
END;
$$ LANGUAGE plpgsql;

--Llamar a la función
select realizar_transferencia(1,2,50000);




/* SEGURIDAD Y CONTROL DE CONCURRENCIA */


/* Configurar Nivel de Aislamiento Transacción */

/*Lecturas No confirmadas*/
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
--CÓDIGO DE LA TRANSACCIÓN
COMMIT;

/*Lecturas Confirmadas (Default)*/
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
--CÓDIGO DE LA TRANSACCIÓN
COMMIT;


/*Lecturas Repetibles*/
BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
--CÓDIGO DE LA TRANSACCIÓN
COMMIT;


/*Lecturas Serializable*/
BEGIN;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
--CÓDIGO DE LA TRANSACCIÓN
COMMIT;

/* EJEMPLO DE BLOQUEO DE TABLAS */

/* Transacción 1 */

BEGIN; 
LOCK TABLE prueba IN ACCESS EXCLUSIVE MODE;
DROP TABLE prueba;
COMMIT;

/*  FIN TRANSACCIÓN 1 */

/* Transacción 2 */
BEGIN; 
--esto debería quedarse a la espera y finalmente fallar cuando se termine la transacción 1
SELECT *  FROM prueba; 
COMMIT;
/* FIN TRANSACCIÓN 2 */




--Tabla de Pruebas
CREATE TABLE prueba_permisos(
    id serial primary key,
    valor int,
    fecha date default now()
);

insert into prueba_permisos(valor) values (1,2,3);

--CREAR USUARIO 
CREATE USER usuario_demo WITH PASSWORD 'ContraseñaSegura123';

--CREACIÓN DE ROLES
CREATE ROLE rol_demo;

-- ASIGNACIÓN DE ROLES Y PERMISOS

--Asignar permisos a un usuario
GRANT SELECT ON prueba_permisos TO usuario_demo;

--Asignar Permisos a un Rol
GRANT INSERT, UPDATE ON prueba_permisos TO rol_demo;

--Asignar Rol a un Usuario
GRANT rol_demo TO usuario_demo;


/*ELIMINAR ROLES, PERMISOS, USUARIOS */

-- Primero, revocar el rol de los usuarios que lo tienen asignado
REVOKE rol_demo FROM usuario_demo;

--Eliminar permisos de rol
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM rol_demo;

-- Luego, eliminar el rol
DROP ROLE rol_demo;

-- Primero, asegurarse de que el usuario no tenga roles asignados ni conexiones activas
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM usuario_demo;
REVOKE ALL ON SCHEMA public FROM usuario_demo;

-- Luego, eliminar el usuario
DROP USER usuario_demo;