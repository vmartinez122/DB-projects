/*
M02-UF2-PR01 Ejercicio #3 – SELECT
Código para solicitar y visualizar datos de la BBDD air_control_vmgr

El código SQL ha sido desarrollado utilizando el programa DBeaver
*/
USE air_control_vmgr; #Nos aseguramos de estar utilizando la base de datos correcta

#a) Listado de las personas.
##DNI, Nombre, Apellidos, Telefono, email

#DNI, Nombre, Apellidos, Telefono y email són todos los atributos de la tabla persona, así que podemos seleccionar *

SELECT	p.* FROM air_control_vmgr.persona AS p;

#b) Listado de los Tripulantes.
##DNI, Nombre, Apellidos, Telefono, id_tripulante, categoria Ordenados por categoría, apellido 1 y apellido2

SELECT
	p.doc_id,
	p.nombre,
	p.apellido1,
	p.apellido2,
	p.telefono,
	t.id_tripulante,
	t.categoria
FROM
	(air_control_vmgr.persona AS p
JOIN #Agrupamos las dos tablas en una JOIN
	air_control_vmgr.tripulante AS t
ON #Relacionamos las dos tablas a través de la entidad p.doc_id, y su FK en tripulante
	p.doc_id = t.doc_id_tripulante)
GROUP BY
	#Ordenaremos las filas por el nombre de la categoría, de la A a la Z, si estas se repiten, los ordenaremos por
	# el primer apellido y si este también se repite, los organizaremos por el segundo apellido.
	t.categoria,
	p.apellido1,
	p.apellido2;

#c) Listado de los vuelos.
##Información de los pasajeros del vuelo (datos de las tablas PASAJERO y PERSONA),
##aeropuerto de salida (nombre) y aeropuerto de llegada(nombre), fecha de salida, fecha de llegada.

SELECT
	pe.*,# Todos los datos de persona
	pa.nacionalidad,# No queremos todos los datos de pasajero, ya que las id son las mismas que en persona
	pa.direccion,# Las direcciones serán NULL ya que dejé el campo en blanco al insertar datos
	#Datos solicitados de la tabla de vuelos:
	v.id_salida,
	v.id_llegada,
	v.fecha_salida,
	v.fecha_llegada
FROM
	#La tabla vuelo no tiene una relación directa con persona o pasajero, así que tenemos que relacionarla con
	# todas las tablas de por medio
	(air_control_vmgr.vuelo AS v
JOIN
	air_control_vmgr.billete AS b
ON 
	v.id_vuelo = b.id_vuelo
JOIN
	air_control_vmgr.pasajero AS pa
ON
	b.doc_id_pasajero = pa.doc_id_pasajero
JOIN
	air_control_vmgr.persona AS pe
ON
	pa.doc_id_pasajero = pe.doc_id);

#d) Contar los vuelos realizados por cada avión agrupados por día de la semana del día de salida.
#En esta selección, mostramos un COUNT del número de vuelos que realiza cada avión(id_avion)
SELECT
	v.id_avion,
	dayofweek(v.fecha_salida) AS dia_semana, #Campo añadir para poder visualizar cómo se estan organizando los datos
	#dayofweek() es una función que devuelve un valor del 1 al 7 dependiendo del día de la semana que indique un dato DATE
	#La función tiene un formato de fechas americano donde:
	#1=Domingo, 2=Lunes, 3=Martes, 4=Miércoles, 5=Jueves, 6=Viernes, 7=Sábado.
	count(v.id_vuelo) AS num_vuelos
FROM
	air_control_vmgr.vuelo AS v
GROUP BY
	v.id_avion,#Organizamos por id_avión primero, ya que sinó los datos se agruparían por días de la semana
	dayofweek(v.fecha_salida);

#e) Consulta para saber los datos del último vuelo del día (hallar este registro usando una subconsulta).
##Desgraciadamente ha sufrido un percance y el CEO de la compañía quiere TODOS los datos de ese vuelo.

SELECT
	v.* #Seleccionamos TODOS los datos del vuelo
FROM
	air_control_vmgr.vuelo AS v
WHERE
	v.fecha_salida >= ALL( #Realizamos una subconsulta donde buscamos el valor de la fecha más alta,
	# El valor que obtendremos del WHERE será entonces el útlimo vuelo listado en la tabla de vuelos
	SELECT
		v2.fecha_salida #En la subconsulta, solamente hemos de solicitar todas las fechas de salida
	FROM
		air_control_vmgr.vuelo AS v2
	);
	
