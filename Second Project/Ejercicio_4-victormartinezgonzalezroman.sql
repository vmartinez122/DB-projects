/*
M02-UF3-PR01 Ejercicio #4 – Triggers
Código de creación y comprobación de triggers en la actualización de campos de la BBDD ArbolGenealogico

El código SQL ha sido desarrollado utilizando el programa DBeaver
*/

USE arbolgenealogico;

#a. Diseñar un trigger (trg_ImpedirEliminacionConHijos)
# que impida la eliminación de una persona si tiene hijos asociados en la tabla de relaciones. 
DELIMITER $$
DROP TRIGGER IF EXISTS trg_ImpedirEliminacionConHijos $$
CREATE TRIGGER trg_ImpedirEliminacionConHijos BEFORE DELETE ON arbolgenealogico.persona #Antes de borrar en la tabla persona
FOR EACH ROW
BEGIN
	IF EXISTS( #Si la ID del campo a borrar, existe en el campo ID_persona2 en una relacion hijo 
				# (significa que esta persona es padre/madre):
		SELECT r.ID_persona2 FROM 
			arbolgenealogico.relacion AS r
		WHERE
			OLD.ID = r.ID_persona2
			AND tipo_relacion = 'hijo'
	) THEN
		#Para impedir que el  DELETE se ejecute, creamos un mensaje de error personalizado: 
		SIGNAL SQLSTATE '45000'
        SET message_text = 'No se puede eliminar. La persona tiene hijos.';
	END IF;
	#Si no se cumple la condición, la persona se va a eliminar.
END $$
DELIMITER ;

	-- Conjunto de pruebas
#DELETE FROM arbolgenealogico.persona WHERE ID = 1; #Juan de Borbón, si intentamos borrar esta persona, saltará el mensaje de 
# error en el trigger. Esta operación está comentada para que el código compile sin errores.
DELETE FROM arbolgenealogico.persona WHERE ID = 21; #Pablo Nicolás, NO tiene hijos (se borrará)
#Tener en cuenta que eliminar una persona de la tabla persona, eliminará las relaciones y eventos
# con FK de la ID de la persona eliminada

#b. Crear un trigger (trg_ActualizarEventoDefuncion)
#que actualice automáticamente la tabla de eventos si se actualiza la fecha de defunción de una persona.

DELIMITER $$
DROP TRIGGER IF EXISTS trg_ActualizarEventoDefuncion $$
CREATE TRIGGER trg_ActualizarEventoDefuncion AFTER UPDATE ON arbolgenealogico.persona #Después de realizar un cambio en persona
FOR EACH ROW
BEGIN
	#Comprobamos si la fecha de defunción ha cambiado, comprobando que las 2 fechas nueva distinta a la antigua:
	IF OLD.fecha_defuncion <> NEW.fecha_defuncion THEN
		UPDATE
			arbolgenealogico.evento 
		SET
			#Cambiamos la fecha de defunción en evento a la nueva en persona
			fecha_evento = NEW.fecha_defuncion
		WHERE 
			#En el eventi de tipo fallecimiento de la persona con ID del campo que hemos editado
			ID_persona = NEW.ID
			AND tipo = 'fallecimiento';
	END IF;
END $$
DELIMITER ;

	-- Conjunto de pruebas
#Fecha fallecimiento de María de las Mercedes de Borbón y Orleans fué en 2000-01-02 
SELECT * FROM arbolgenealogico.evento WHERE ID_persona = 2 AND tipo = 'fallecimiento';
#Realizamos un update sobre la fecha de defunción María de las Mercedes de Borbón y Orleans persona a 1999:
UPDATE arbolgenealogico.persona SET fecha_defuncion = '1999-01-02' WHERE ID = 2;
#Con otro select, comprobamos que la fecha evento de 'fallecimeinto' de esta persona ha cambiado
SELECT * FROM arbolgenealogico.evento WHERE ID_persona = 2 AND tipo = 'fallecimiento';