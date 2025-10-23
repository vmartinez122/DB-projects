/*
M02-UF3-PR01 Ejercicio #3 – Procedimientos Almacenados
Creación de procedimientos para insertar y mostrar datos de la BBDD ArbolGenealogico

El código SQL ha sido desarrollado utilizando el programa DBeaver
*/

USE arbolgenealogico;

#Como hay varias funciones que necesitan comprobar si el formato de fecha es correcto, he creado un procedimiento
# que valida un string y lo devuelve en formato DATE. Este procedimiento es creado al principio para ser llamado por los
# procedimientos a continuación 
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ComprobarFecha $$
CREATE PROCEDURE sp_ComprobarFecha(
	IN p_fecha VARCHAR(10), #Fecha a validar
	OUT p_isvalid BOOLEAN,  #Si la fecha es válida o no 
	OUT p_fecha_to_date DATE) #Fecha en formato DATE
BEGIN
	IF 
		#La función STR_TO_DATE, comprueba si el string insertado (p_fecha) tiene un formato específico, en este caso YYYY-MM-DD
		#Si el string insertado tiene este formato, la función lo devuelve como DATE.
		#Si el string insertado tiene un valor no convertible a DATE, devuelve NULL.
		STR_TO_DATE(p_fecha, "%Y-%m-%d") IS NOT NULL
		#Excluimos los strings NULL para que el usuario pueda introducir campos en blanco
    	OR p_fecha IS NULL
    THEN
    	SET p_fecha_to_date = STR_TO_DATE(p_fecha,'%Y-%m-%d'); #Las fechas que han pasado por el condicional,
    	# se asignan a la variable OUT p_fecha_to_date, que devolverá una DATE o NULL (en caso de que el usuario lo especifique)
  	    SET p_isvalid = TRUE;  
    ELSE #Utilizaremos la boolean p_is_valid para marcar la fecha como válida o no
        SET p_isvalid = FALSE;
    END IF;
END $$
DELIMITER ;

#a.	Crear un procedimiento almacenado que permita agregar una nueva persona al árbol genealógico.
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_AgregarPersona $$
CREATE PROCEDURE sp_AgregarPersona(
	IN p_nombre VARCHAR(50),
	IN p_fecha_nacimiento VARCHAR(10),#Las fechas no se introducen directamente, así que tendrán un formato string
	IN p_fecha_defuncion VARCHAR(10),
	IN p_genero VARCHAR(1))
BEGIN
	#Llamamos veces al procedimiento de validar fechas con las 2 fechas a insertar:
	CALL sp_ComprobarFecha(p_fecha_nacimiento, @p_N_isvalid, @p_nacimiento_date);
	CALL sp_ComprobarFecha(p_fecha_defuncion, @p_D_isvalid, @p_defuncion_date);
	IF
		#Si las fechas están dentro del rango de date (o son NULL), p_isvalid será true y realizaremos el insert
		@p_N_isvalid IS NOT FALSE
		AND @p_D_isvalid IS NOT FALSE
		#Comprueba que el género esté dentro de un rango de valores con los valores 'M' o 'F'
		AND p_genero IN ('M', 'F')
	THEN
		#Comprueba que el género esté dentro de un rango de valores con los valores 'M' o 'F'
		INSERT INTO 
			arbolgenealogico.persona(nombre, fecha_nacimiento, fecha_defuncion, genero) 
		VALUES 
			(p_nombre, @p_nacimiento_date, @p_defuncion_date, p_genero);
		COMMIT;
	ELSE
		SELECT 'Formato inválido' AS Error; #Mensaje de error en un SELECT 
	END IF;
END $$
DELIMITER ;

	-- Conjunto de pruebas
CALL sp_AgregarPersona('Maria Lopez', '1985-08-20', '2023-12-01', 'F'); #Insert con 2 fechas válidas
CALL sp_AgregarPersona('Juan Perez', '1990-05-15', NULL, 'M'); #Insert con un dato NULL
CALL sp_AgregarPersona('Enrique García', '1985-13-20', '2024-01-01', 'M'); #Insert inválido, el més 13 no existe, así que
# saltará un error de formato
CALL sp_AgregarPersona('Felipe Vázquez', '2002-05-10', NULL, 'X'); #Insert inválido, valor de género inválido

#b.	Crear un procedimiento que registre un evento importante (nacimiento, matrimonio, fallecimiento) y lo asocie con una persona. 
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_RegistrarEvento $$
CREATE PROCEDURE sp_RegistrarEvento(
	IN p_tipo VARCHAR(20),
	IN p_fecha_evento VARCHAR(10), #Fecha en formato string (falta verificarla)
	IN p_ID_persona INT)
BEGIN
	CALL sp_ComprobarFecha(p_fecha_evento, @p_isvalid, @p_fecha_to_date);
	IF
		#Comprueba que el tipo de evento sea uno de estos tres
		p_tipo IN ('nacimiento', 'matrimonio', 'fallecimiento')
		#Comprueba que la fecha haya sido marcada como válida
		AND @p_isvalid IS NOT FALSE
		#Comprueba que la ID de la persona, exista en la tabla de personas
		AND	EXISTS (SELECT ID FROM arbolgenealogico.persona AS p WHERE p_ID_persona = p.ID
	)THEN
		#Si se cumplen las condiciones, podemos introducir los nuevos valores
		INSERT INTO arbolgenealogico.evento(tipo, fecha_evento, ID_persona) 
		VALUES (p_tipo, @p_fecha_to_date, p_ID_persona);
		COMMIT;
	ELSE
		SELECT 'Formato inválido' AS Error;
	END IF;
END $$
DELIMITER ;
	-- Conjunto de pruebas
CALL sp_RegistrarEvento('nacimiento', '2002-12-02', 1); #Datos correctos
CALL sp_RegistrarEvento('fallecimiento', NULL, 2); #Datos correctos con fecha vacía
CALL sp_RegistrarEvento('error', '2024-12-02', 2); #Insert inválido, Tipo de evento incorrecto
CALL sp_RegistrarEvento('matrimonio', '2024-10-02', 99); #Insert inválido, ID de persona inexistente
CALL sp_RegistrarEvento('fallecimiento', '2024-05-32', 2); #Insert inválido, formato de fecha fuera de rango

#Eliminamos los eventos previamente creados para evitar confusiones:
DELETE FROM arbolgenealogico.evento WHERE 
	ID_persona = 1 AND fecha_evento = '2002-12-02'
OR
	ID_persona = 2 AND fecha_evento IS NULL;

#c.	Crear un procedimiento que devuelva el árbol genealógico de una persona dada, mostrando al menos tres generaciones (abuelos, padres, hijos). 
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerArbolGenealogico $$
CREATE PROCEDURE sp_ObtenerArbolGenealogico(IN p_nombre VARCHAR(50))
BEGIN
	IF EXISTS(SELECT ID FROM arbolgenealogico.persona AS p WHERE p.nombre=p_nombre) THEN #Comprobamos que la persona exista
		#Esta UNION, permite juntar una selección buscando el nombre de los abuelos y el nombre de los padres e hijos
		#Adicionalmente he añadido que se muestre la ID de estas personas
		(SELECT
		#Vamos a buscar las r1.ID_persona1 las cuales tengan relación a r1.ID_persona2 como padre o madre
		#Las r1.ID_persona2 las encontramos con una subselección que devuelve las r2.ID_persona1 que tienen la
		# relación de padre o madre con la r2.ID_persona2 que corresponde al nombre que hemos entrado (p_nombre)
		#Esta subselección es similar a la que se utiliza en el otro lado de la UNION para encontrar los padres,
		# pero en este caso utilizado como subselección ya que queremos encontrar los padres de los padres.
			r1.ID_persona1 AS ID,
			p1.nombre,
			'abuelo' AS relacion #La columna relación, tendrá el valor abuelo para estos campos
		FROM
			(arbolgenealogico.relacion AS r1
		JOIN
			arbolgenealogico.persona AS p1
		ON
			r1.ID_persona1 = p1.ID)
		WHERE
			r1.ID_persona2 IN(
				SELECT
					r2.ID_persona1
				FROM
					(arbolgenealogico.persona AS p
				JOIN 
					arbolgenealogico.relacion AS r2
				ON
					r2.ID_persona1 = p.ID)
				WHERE
					r2.ID_persona2 = (
					SELECT p2.ID FROM arbolgenealogico.persona AS p2 
					WHERE nombre = p_nombre)
					AND r2.tipo_relacion IN ('padre', 'madre'))
			AND r1.tipo_relacion IN ('padre', 'madre'))
		UNION #Une las dos selecciones para que aparezca en orden los abuelos, padres y finalmente hijos
		(SELECT
			r.ID_persona1 AS ID,
			p.nombre,
			r.tipo_relacion AS relacion
		FROM
			(arbolgenealogico.persona AS p
		JOIN 
			arbolgenealogico.relacion AS r
		ON
			r.ID_persona1 = p.ID) #Buscamos las ID_persona1 (que relacionaremos con la tabla persona para optener su nombre)
			# que cumpla con los siguientes parámetros:
		WHERE #Selecciona la ID_persona2 de las personas con el nombre que hemos entrado (p_nombre)
			r.ID_persona2 = (
			SELECT p2.ID FROM arbolgenealogico.persona AS p2 
			WHERE nombre = p_nombre
			)
			#La personas que buscamos tienen la relación padre, madre o hijo con la ID_persona2
			AND r.tipo_relacion IN ('padre', 'madre', 'hijo'));
	ELSE
		#Si la persona no existe, se muestra este mensaje de error en una selección
		SELECT 'Persona inexistente' AS Error;
	END IF;
END $$
DELIMITER ;

	-- Conjunto de pruebas
CALL sp_ObtenerArbolGenealogico('Felipe VI'); #Persona existente, devuelve sus relaciones
CALL sp_ObtenerArbolGenealogico('Rodrigo'); #Persona inexistente, devuelve mensaje de error
