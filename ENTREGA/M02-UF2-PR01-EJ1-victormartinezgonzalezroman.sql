/*
M02-UF2-PR01 Ejercicio #1 – Creación de la BBDD y las tablas
Código de creación estructura BBDD AIR_CONTROL_VMGR
BBDD para gestionar vuelos entre aeropuertos

El código SQL ha sido desarrollado utilizando el programa DBeaver
*/

#Creamos la base de datos si no existe:
#Utilizaremos el juego de carácteres case insensitive: utf8_spanish_ci
CREATE DATABASE IF NOT EXISTS AIR_CONTROL_VMGR DEFAULT CHARACTER SET 'utf8' DEFAULT COLLATE 'utf8_spanish_ci';
USE air_control_vmgr; #Nos aseguramos de estar utilizando la base de datos correcta (una vez la creamos)


#Creación de tablas de la BBDD:
#Solamente generamos las tablas si estas no existen, para evitar errores si se ejecuta el script múltiples veces
CREATE TABLE IF NOT EXISTS air_control_vmgr.persona(
	doc_id VARCHAR(9), 
	nombre VARCHAR(20) NOT NULL, #He decidido hacer este campo NOT NULL, para no permitir personas sin nombre
	apellido1 VARCHAR(20),
	apellido2 VARCHAR(20),
	telefono INT,
	email VARCHAR(100),
	PRIMARY KEY(doc_id) #No utilizo CONSTRAINT para definir el nombre de las PK, ya que este es ignorado en la ejecución
);

#Como en este caso, crearemos las FK junto con las tablas, el orden de creación de estas 
#es importante, ya que van a ser relacionadas con tablas anteriores
CREATE TABLE IF NOT EXISTS air_control_vmgr.tripulante(
	doc_id_tripulante VARCHAR(9),
	id_tripulante INT,
	categoria VARCHAR(50),
	#Podemos saber si un tripulante es capitán comparando su id con la id de capitán, así que crear una booleana es_capitan sería redundante
	doc_id_capitan VARCHAR(9),
	PRIMARY KEY(doc_id_tripulante),
	CONSTRAINT fk_tripulante FOREIGN KEY(doc_id_tripulante) REFERENCES air_control_vmgr.persona(doc_id) ON UPDATE CASCADE ON DELETE CASCADE,
	#Las restricciones ON UPDATE CASCADE ON DELETE CASCADE, permiten que llas foreign KEYS,
	#se actualizen o borren al realizar un cambio en el registro que referencian
	CONSTRAINT fk_capitan FOREIGN KEY(doc_id_capitan) REFERENCES air_control_vmgr.tripulante(doc_id_tripulante) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS air_control_vmgr.pasajero(
	doc_id_pasajero VARCHAR(9),
	nacionalidad VARCHAR(20),
	direccion VARCHAR(100),
	PRIMARY KEY(doc_id_pasajero),
	CONSTRAINT fk_pasajero FOREIGN KEY(doc_id_pasajero) REFERENCES air_control_vmgr.persona(doc_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS air_control_vmgr.aeropuerto(
	id_aeropuerto INT AUTO_INCREMENT, #En esta BBDD, las id de distintas entidades, serán autoincrementales
	nombre VARCHAR(50),
	ciudad VARCHAR(50),
	latitud FLOAT,
	longitud FLOAT,
	PRIMARY KEY(id_aeropuerto)
);

CREATE TABLE IF NOT EXISTS air_control_vmgr.avion(
	id_avion INT AUTO_INCREMENT,
	modelo VARCHAR(50),
	num_asientos INT,
	PRIMARY KEY(id_avion)
);

#Vuelo, contiene 2 atributos FK de id_aeropuerto, para poder relacionar el vuelo tanto con el aeropuerto de salida que con el de llegada
CREATE TABLE IF NOT EXISTS air_control_vmgr.vuelo(
	id_vuelo INT AUTO_INCREMENT,
	id_salida INT,
	fecha_salida DATETIME,
	id_llegada INT,
	fecha_llegada DATETIME,
	id_avion INT,
	PRIMARY KEY(id_vuelo),
	CONSTRAINT fk_vuelo_salida FOREIGN KEY(id_salida) REFERENCES air_control_vmgr.aeropuerto(id_aeropuerto) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_vuelo_llegada FOREIGN KEY(id_llegada) REFERENCES air_control_vmgr.aeropuerto(id_aeropuerto) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_vuelo_avion FOREIGN KEY(id_avion) REFERENCES air_control_vmgr.avion(id_avion) ON UPDATE CASCADE ON DELETE CASCADE
);

#Tabla que relaciona vuelo con pasajero, con los datos del billete
CREATE TABLE IF NOT EXISTS air_control_vmgr.billete(
	id_vuelo INT, #Las id que actúan como FK no serán definidas como autoincrementales, ya que van relacionadas a otro atributo 
	doc_id_pasajero VARCHAR(9),
	num_asiento INT,
	equipaje_cabina BOOL,
	factura_equipaje BOOL,
	PRIMARY KEY(id_vuelo, doc_id_pasajero),
	CONSTRAINT fk_billete_vuelo FOREIGN KEY(id_vuelo) REFERENCES air_control_vmgr.vuelo(id_vuelo) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_billete_pasajero FOREIGN KEY(doc_id_pasajero) REFERENCES air_control_vmgr.pasajero(doc_id_pasajero) ON UPDATE CASCADE ON DELETE CASCADE
);

#Tabla que relaciona vuelo con tripulante
CREATE TABLE IF NOT EXISTS air_control_vmgr.tripulante_vuelo(
	id_vuelo INT,
	doc_id_tripulante VARCHAR(9),
	cargo VARCHAR(50),
	PRIMARY KEY(id_vuelo, doc_id_tripulante),
	CONSTRAINT fk_tripulante_id_vuelo FOREIGN KEY(id_vuelo) REFERENCES air_control_vmgr.vuelo(id_vuelo) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_id_tripulante_vuelo FOREIGN KEY(doc_id_tripulante) REFERENCES air_control_vmgr.tripulante(doc_id_tripulante) ON UPDATE CASCADE ON DELETE CASCADE
);
