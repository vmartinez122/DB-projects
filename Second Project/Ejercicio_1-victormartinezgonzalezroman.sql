/*
M02-UF3-PR01 Ejercicio #1 – Creación de la Base de Datos
Código de creación de la BBDD ArbolGenealogico y sus tablas

El código SQL ha sido desarrollado utilizando el programa DBeaver
*/

#a. Crear una base de datos llamada ArbolGenealogico
CREATE DATABASE IF NOT EXISTS ArbolGenealogico DEFAULT CHARACTER SET 'utf8' DEFAULT COLLATE 'utf8_spanish_ci';
USE arbolgenealogico;

#b. Definir las siguientes tablas:
##i. Personas: Información sobre cada persona (ID, nombre, fecha de nacimiento,fecha de defunción, género).
CREATE TABLE IF NOT EXISTS persona(
	ID INT NOT NULL AUTO_INCREMENT,
	nombre VARCHAR(50),
	fecha_nacimiento DATE,
	fecha_defuncion DATE,
	genero VARCHAR(1),
	PRIMARY KEY(ID)
);

##ii. Relaciones: Información sobre las relaciones familiares entre personas 
## (ID de persona 1, ID de persona 2, tipo de relación - padre, madre, hijo, cónyuge).
CREATE TABLE IF NOT EXISTS relacion(
	ID_persona1 INT NOT NULL,
	ID_persona2 INT NOT NULL,
	tipo_relacion VARCHAR(10), #padre, madre, hijo, cónyuge
	PRIMARY KEY(ID_persona1, ID_persona2),
	FOREIGN KEY(ID_persona1) REFERENCES arbolgenealogico.persona(ID) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(ID_persona2) REFERENCES arbolgenealogico.persona(ID) ON UPDATE CASCADE ON DELETE CASCADE
);

 ##iii. Eventos: Información sobre eventos importantes 
 ## (ID, tipo de evento - nacimiento, matrimonio, fallecimiento, fecha del evento, ID de persona asociada).
CREATE TABLE IF NOT EXISTS evento(
	ID_evento INT NOT NULL AUTO_INCREMENT,
	tipo VARCHAR(20), # nacimiento, matrimonio, fallecimiento
	fecha_evento DATE,
	ID_persona INT,
	PRIMARY KEY(ID_evento),
	FOREIGN KEY(ID_persona) REFERENCES arbolgenealogico.persona(ID) ON UPDATE CASCADE ON DELETE CASCADE
);