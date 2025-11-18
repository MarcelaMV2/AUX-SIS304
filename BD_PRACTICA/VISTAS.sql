/* 1. Crear una vista que muestre el código, descripción y número de serie de todos los repuestos 
cuyo NUMSERIE se encuentre entre 2300000 y 6000000. Los datos deben aparecer ordenados por DESCRIPCION.*/

CREATE VIEW VISTA1 AS
SELECT
    CODIGO,
    DESCRIPCION,
    NUMSERIE
FROM REPUESTO
WHERE NUMSERIE BETWEEN 2300000 AND 6000000
ORDER BY DESCRIPCION;

SELECT * FROM VISTA1;
/* 2.Crear una vista que liste el ITEM, NOMBRE, TELEFONO y CIUDAD de todos los encargados que tengan
 una ciudad realmente registrada*/
CREATE VIEW V_ENCARGADOS_CON_CIUDAD AS
SELECT
    ITEM,
    NOMBRE,
    TELEFONO,
    CIUDAD
FROM ENCARGADO
WHERE CIUDAD IS NOT NULL
  AND CIUDAD <> ' '
ORDER BY CIUDAD, NOMBRE;
SELECT * FROM VISTA2;
 /* 3.Crear una vista que muestre, para cada compra realizada en el año 2019, el Código del repuesto, 
 descripción del repuesto, NIT del proveedor, nombre del proveedor, fecha de la compra, cantidad 
 comprada, costo unitario (COSTO), un campo calculado COSTO_TOTAL definido como 
 COSTO_TOTAL = COSTO - DESCUENTO + IMPUESTO. */
 
CREATE VIEW VISTA3 AS
SELECT
    C.CODIGO,
    R.DESCRIPCION,
    C.NIT,
    P.NOMBREP AS 'NOMBREPROVEEDOR',
    C.FECHA,
    C.CANTIDAD,
    C.COSTO,
    (C.COSTO - C.DESCUENTO + C.IMPUESTO) AS 'COSTO TOTAL'
FROM COMPRA c
JOIN REPUESTO r ON c.CODIGO = r.CODIGO
JOIN PROVEEDOR p ON c.NIT = p.NIT
WHERE YEAR(c.FECHA) = 2019
ORDER BY c.FECHA;

SELECT * FROM VISTA3;
 
/*  4. Crear una vista que muestre todas las entregas realizadas en la 
fecha actual por encargados cuya CIUDAD sea ‘SUCRE’. La vista debe mostrar, Número de entrega (NE)
Fecha y hora de entrega (FECHAE), Nombre del encargado, Ciudad, Código del repuesto, Descripción 
del repuesto, Cantidad entregada (CANTIDADE), Ordene el resultado por FECHAE (de la más antigua 
a la más reciente).*/

CREATE VIEW VISTA4 AS
SELECT
    E.NE,
    E.FECHAE,
    EN.NOMBRE AS NOMBRE_ENCARGADO,
    EN.CIUDAD,
    R.CODIGO,
    R.DESCRIPCION,
    E.CANTIDADE
FROM ENTREGA E
JOIN ENCARGADO EN ON E.ITEM = EN.ITEM
JOIN REPUESTO r ON R.CODIGO = R.CODIGO
WHERE DATE(E.FECHAE) = CURDATE()
  AND EN.CIUDAD = 'SUCRE'
ORDER BY E.FECHAE;
SELECT * FROM VISTA4;

/* 5. Cree una vista que liste todos los repuestos eléctricos cuya POTENCIA sea mayor que la potencia 
promedio de la tabla ELECTRICO. La vista debe mostrar el código del repuesto, descripción del 
repuesto, Número de serie, Potencia. Ordenar por POTENCIA de mayor a menor.*/

CREATE VIEW VISTA5 AS
SELECT
    R.CODIGO,
    R.DESCRIPCION,
    R.NUMSERIE,
    E.POTENCIA
FROM ELECTRICO E
JOIN REPUESTO R ON E.CODIGO = R.CODIGO
WHERE E.POTENCIA > (SELECT AVG(POTENCIA) FROM ELECTRICO)
ORDER BY E.POTENCIA DESC;

SELECT * FROM VISTA5;

/*6. Cree una vista que muestre los repuestos cuya cantidad total entregada se encuentre entre:
(promedio global de CANTIDADE) − 10 y (promedio global de CANTIDADE) + 10. La vista debe mostrar 
el código del repuesto, descripción del repuesto, cantidad total entregada*/
CREATE VIEW V_REPUESTOS_ENTREGAS_PROMEDIO AS
SELECT
    R.CODIGO,
    R.DESCRIPCION,
    SUM(E.CANTIDADE) AS TOTAL_ENTREGADO
FROM REPUESTO R
JOIN ENTREGA E ON R.CODIGO = E.CODIGO
GROUP BY R.CODIGO, R.DESCRIPCION
HAVING TOTAL_ENTREGADO BETWEEN
    (SELECT AVG(CANTIDADE) FROM ENTREGA) - 10
    AND
    (SELECT AVG(CANTIDADE) FROM ENTREGA) + 10
ORDER BY TOTAL_ENTREGADO;
