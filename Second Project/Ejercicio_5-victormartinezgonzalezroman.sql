/*
M02-UF3-PR01 Ejercicio #5 – Gestión de Usuarios
Código de creación de la BBDD ArbolGenealogico

El código SQL ha sido desarrollado utilizando el programa DBeaver
*/
USE arbolgenealogico;

#a. Crear tres roles de usuario:

-- Creación roles
#Después de realizar pruebas, no me ha resultado posible hacer que los usuarios funcionen con los permisos asignados a los roles.
#Dejo el código de creacion de los roles a continuación, pero no los voy a asignar a los usuarios.

##i. Administrador: Puede realizar cualquier acción en la base de datos.
CREATE ROLE administrador;
#El administrador tiene todos los permisos, incluyendo los de administrador (GRANT OPTION).
GRANT ALL PRIVILEGES ON arbolgenealogico.* TO administrador WITH GRANT OPTION;

##ii.Gestor: Puede agregar y modificar datos, pero no puede eliminar personas o relaciones. 
CREATE ROLE gestor;
#Este rol, solamente tiene acceso para visualizar insertar y actualizar campos en persona y relacion.
GRANT SELECT, INSERT, UPDATE ON arbolgenealogico.persona TO gestor;
GRANT SELECT, INSERT, UPDATE ON arbolgenealogico.relacion TO gestor;

##iii. Consultor: Solo puede leer los datos, pero no realizar modificaciones.
CREATE ROLE consultor;
#El consultor, puede visualizar las tablas de 
GRANT SELECT ON arbolgenealogico.* TO consultor;

#Mostramos permisos de los roles:
SHOW GRANTS FOR administrador;
SHOW GRANTS FOR gestor;
SHOW GRANTS FOR consultor;

#b. Implementar la gestión de usuarios con los roles asignados.
-- Creación usuarios (con contraseña)
CREATE USER 'admin_usr'@'%' IDENTIFIED BY 'admin';
CREATE USER 'gestor_usr'@'%' IDENTIFIED BY 'gest';
CREATE USER 'consultor_usr'@'localhost' IDENTIFIED BY 'consult';

#Asignación de roles a los usuarios (no funciona)
GRANT administrador TO 'admin_usr'@'%';
GRANT gestor TO 'gestor_usr'@'%';
GRANT consultor TO 'consultor_usr'@'%';

#Mostramos permisos de los usuarios, aquí vemos los roles actuando como una agrupación de permisos:
SHOW GRANTS FOR 'admin_usr'@'%';
SHOW GRANTS FOR 'gestor_usr'@'%';
SHOW GRANTS FOR 'consultor_usr'@'%';
#El Grant de USAGE, sirve para que el usuario pueda acceder al gestor de BBDD


-- Conjunto de Pruebas (a realizar desde los distintos usuarios):
SELECT * FROM arbolgenealogico.persona; #administrador, gestor, consultor
INSERT INTO arbolgenealogico.evento (tipo) VALUES ('test'); #administrador (gestor no puede gestionar la tabla evento)
UPDATE arbolgenealogico.persona SET fecha_defuncion = '2000-01-02' WHERE ID = 2; #administrador, gestor
DELETE FROM arbolgenealogico.evento WHERE ID_evento = 99; #administrador
