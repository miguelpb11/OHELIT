CREATE TABLE cliente
(
    id INT NOT NULL, 
	nombre VARCHAR(50), 
	direccion VARCHAR(50),
	correo_electronico VARCHAR(50),
	CONSTRAINT cliente_pkey PRIMARY KEY (id)
);

CREATE TABLE inventario
(
    id character(10) NOT NULL,
    id_libro integer,
    titulo_libro character(50),
    cantidad integer,
    CONSTRAINT id PRIMARY KEY (id)
);

drop table inventario;

CREATE TABLE libro
(
    codigo integer NOT NULL,
    titulo character(50),
    autor character(50),
    genero character(50),
    descripcion character(50),
    precio integer,
    fecha_publicacion date,
    CONSTRAINT libro_pkey PRIMARY KEY (codigo)
);

CREATE TABLE pedidos
(
    id integer NOT NULL,
    Id_cliente integer NOT NULL,
    cnombre character(50),
    fecha date,
    direccion character varying(50),
    CONSTRAINT pedidos_pkey PRIMARY KEY (id)
);


CREATE TABLE pedido_libro
(
    id integer NOT NULL,
    id_pedido integer NOT NULL,
    id_libro integer NOT NULL,
    ltitulo character,
    cantidad integer,
    CONSTRAINT pedido_libros_pkey PRIMARY KEY (id)
);


INSERT INTO cliente 
(id,nombre,direccion,correo_electronico)
VALUES (0001,'Pedro Gonzales','calle 40 #56','pgonzales@gmail.com'),
(0002,'Alvaro Lopez','calle 48 #55','alopez@gmail.com'),
(0003,'Daniel Martinez','calle 44 #56','dmartinez@gmail.com'),
(0004,'Angela Sosa','calle 4 #53','aosoa@gmail.com'),
(0005,'Martin Cepeda','Cr 66 #59','mcepeda@gmail.com');



INSERT INTO libro
(codigo,titulo,autor,genero,descripcion,precio,fecha_publicacion)
VALUES (60056,'Cien años de soledad','Gabriel M','Drama','...............',40000,'23/05/1996'),
(60023,'Harry Potter','JK','Fantasia','...............',60000,'22/07/2004'),
(60022,'La chica dle tren','Paula H.','Drama','...............',40000,'24/05/2009'),
(60089,'El principito','Antoine','Fantasia','...............',30000,'02/09/2005'),
(60033,'Romeo y julieta','William S.','Romance','...............',60000,'02/09/1911')


INSERT INTO pedidos
(id, id_cliente, cnombre, fecha, direccion)
VALUES (900609,0002,'Alvaro Lopez','2023-03-05','calle 48 #55'),
(900656,0001,'Pedro Gonzales','2023-03-12','calle 40 #56'),
(900662,0004,'Angela Sosa','2023-03-23','calle 4 #53'),
(900679,0002,'Alvaro Lopez','2023-04-01','calle 48 #55')

drop table pedidos


INSERT INTO inventario
(id,id_libro,titulo_libro,cantidad)
VALUES (1,60056,'Cien años de soledad',140),
(2,60023,'Harry Potter',90),
(3,60022,'la chica del tren',18),
(4,60089,'la chica del tren',18),
(5,60033,'Romeo y Julieta',50)



INSERT INTO pedido_libro
(id,id_pedido,id_libro,ltitulo,cantidad)
VALUES (001,900609,60056,'Cien años de soledad',1),
(002,900609,60033,'Romeo y Julieta',2),
(003,900656,60033,'Romeo y Julieta',1),
(004,900662,60023,'Harry Potter',1),
(005,900679,60023,'Harry Potter',1);


-- libro más vendido en el mes de abril

SELECT ltitulo, SUM(cantidad) as cant_venta_libro
FROM pedido_libro t1
JOIN pedidos t2 ON t1.id_pedido = t2.id
WHERE t2.fecha >= '2023-04-01' AND t2.fecha < '2023-05-01'
GROUP BY ltitulo
ORDER BY cant_venta_libro DESC
LIMIT 1

--promedio de precio de los liros de la tienda

SELECT AVG(precio) FROM libro


--Ejercicio challenge(Fue lo mas que se pudo, se genero el ERROR:  el valor es demasiado largo para el tipo character(1)
CREATE OR REPLACE FUNCTION vtotal_iva(
	idd integer,
	precio numeric,
	cantidad integer
)
RETURNS void
AS $$
DECLARE
vtotal integer;
iva numeric;
titulo character;
BEGIN
SELECT ltitulo INTO titulo FROM pedido_libro WHERE idd = id;
IF NOT FOUND THEN
        RAISE EXCEPTION 'No se encontró ningún libro con el id %', idd;
    END IF;
 vtotal := cantidad * precio;
    iva := vtotal * 0.19;
INSERT INTO pedido_libro(idd,vtotal,iva)
    VALUES (idd, vtotal, iva);
END;
$$ LANGUAGE plpgsql;

