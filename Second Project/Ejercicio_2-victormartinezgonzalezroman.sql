/*
M02-UF3-PR01 Ejercicio #2 – Carga Inicial de Datos
Código de carga de datos para la BBDD ArbolGenealogico

El código SQL ha sido desarrollado utilizando el programa DBeaver
*/
USE arbolgenealogico;
#a. Se debe proporcionar un script que permita la carga inicial de los datos en las tablas

#La carga de datos ha sido realizada ampliando el árbol genealógico de la familia real Española proporcinada
#Las relaciones han sido obtenidas de esta imágen:
#https://content.clara.es/medio/2024/06/20/arbol-genealogico-familia-real-espanola-borbones-grecia_7783c785_240620152339_1280x720.webp

-- Generación anterior a Juan Carlos I
INSERT INTO arbolgenealogico.persona(nombre, fecha_nacimiento, fecha_defuncion, genero) VALUES 
('Juan de Borbón', '1913-06-20', '1993-04-01', 'M'),
('María de las Mercedes de Borbón y Orleans', '1910-12-23', '2000-01-02', 'F'),
('Pablo I de Grecia', '1901-12-14', '1964-03-06', 'M'),
('Federica de Hannover', '1917-03-18', '1981-02-06', 'F');

-- Generación Juan Carlos I
INSERT INTO arbolgenealogico.persona(nombre, fecha_nacimiento, fecha_defuncion, genero) VALUES 
('Juan Carlos I', '1938-01-05', NULL, 'M'),
('Sofía de Grecia', '1938-11-02', NULL, 'F'),
-- Hermanos Juan Carlos I
('Pilar de Borbón y Borbón', '1936-07-30', '2020-01-08', 'F'),
('Margarita de Borbón y Borbón', '1939-03-06', NULL, 'F'),
('Alfonso de Borbón', '1941-10-03', '1956-03-29', 'M'),
-- Hermanos Sofía de Grecia
('Constantino II de Grecia', '1940-06-02', '2023-01-10', 'M'),
('Irene de Grecia', '1942-05-11', NULL, 'F');

-- Generación Felipe IV
INSERT INTO arbolgenealogico.persona(nombre, fecha_nacimiento, fecha_defuncion, genero) VALUES 
('Felipe VI', '1968-01-30', NULL, 'M'),
('Letizia Ortiz', '1972-09-15', NULL, 'F'),
('Elena de Borbón', '1963-12-20', NULL, 'F'),
('Jaime de Marichalar', '1963-04-07', NULL, 'M'),
('Cristina de Borbón', '1965-06-13', NULL, 'F'),
('Iñaki Urdangarin', '1968-01-15', NULL, 'M');

-- Generación Hijos Felipe IV
INSERT INTO arbolgenealogico.persona(nombre, fecha_nacimiento, fecha_defuncion, genero) VALUES
-- Hijos Felipe IV
('Leonor de Borbón', '2005-10-31', NULL, 'F'),
('Sofía de Borbón', '2007-04-29', NULL, 'F'),
-- Hijos Infanta Cristina
('Juan Valentín', '1999-09-29', NULL, 'M'),
('Pablo Nicolás', '2000-12-06', NULL, 'M'),
('Miguel Urdangarin', '2002-04-30', NULL, 'M'),
('Irene Urdangarin', '2005-06-05', NULL, 'F'),
-- Hijos Infanta Elena
('Felipe Juan Froilán', '1998-07-17', NULL, 'M'),
('Victoria Federica', '2000-09-09', NULL, 'F');

-- Relaciones Familiares
-- Cónyuges
INSERT INTO arbolgenealogico.relacion(ID_persona1, ID_persona2, tipo_relacion) VALUES 
(1, 2, 'conyuge'), -- Juan de Borbón y María de las Mercedes de Borbón y Orleans
(2, 1, 'conyuge'),
(3, 4, 'conyuge'), -- Pablo I de Grecia y Federica de Hannover
(4, 3, 'conyuge'),
(5, 6, 'conyuge'), -- Juan Carlos I y Sofía de Grecia
(6, 5, 'conyuge'),
(12, 13, 'conyuge'), -- Felipe IV y Letizia Ortiz
(13, 12, 'conyuge'),
(14, 15, 'conyuge'), -- Elena de Borbón y Jaime de Marichalar
(15, 14, 'conyuge'),
(16, 17, 'conyuge'),-- Cristina de Borbón y Iñaki Urdangarin
(17, 16, 'conyuge'); 

-- Relaciones parentales
INSERT INTO arbolgenealogico.relacion(ID_persona1, ID_persona2, tipo_relacion) VALUES 
(1, 5, 'padre'), -- Padre de Juan Carlos I
(2, 5, 'madre'), -- Madre de Juan Carlos I
(1, 7, 'padre'),
(2, 7, 'madre'),
(1, 8, 'padre'),
(2, 8, 'madre'),
(1, 9, 'padre'),
(2, 9, 'madre'),
(3, 6, 'padre'),
(4, 6, 'madre'),
(3, 10, 'padre'),
(4, 10, 'madre'),
(3, 11, 'padre'),
(4, 11, 'madre'),
(5, 12, 'padre'),
(6, 12, 'madre'),
(5, 14, 'padre'),
(6, 14, 'madre'),
(5, 16, 'padre'),
(6, 16, 'madre'),
(12, 18, 'padre'),
(13, 18, 'madre'),
(12, 19, 'padre'),
(13, 19, 'madre'),
(15, 24, 'padre'),
(14, 24, 'madre'),
(15, 25, 'padre'),
(14, 25, 'madre'),
(17, 20, 'padre'),
(16, 20, 'madre'),
(17, 21, 'padre'),
(16, 21, 'madre'),
(17, 22, 'padre'),
(16, 22, 'madre'),
(17, 23, 'padre'),
(16, 23, 'madre');

-- Relaciones hijos (relaciones parentales invertidas)
INSERT INTO arbolgenealogico.relacion(ID_persona1, ID_persona2, tipo_relacion) VALUES  
(5, 1, 'hijo'),
(5, 2, 'hijo'),
(7, 1, 'hijo'),
(7, 2, 'hijo'),
(8, 1, 'hijo'),
(8, 2, 'hijo'),
(9, 1, 'hijo'),
(9, 2, 'hijo'),
(6, 3, 'hijo'),
(6, 4, 'hijo'),
(10, 3, 'hijo'),
(10, 4, 'hijo'),
(11, 3, 'hijo'),
(11, 4, 'hijo'),
(12, 5, 'hijo'),
(12, 6, 'hijo'),
(14, 5, 'hijo'),
(14, 6, 'hijo'),
(16, 5, 'hijo'),
(16, 6, 'hijo'),
(18, 12, 'hijo'),
(18, 13, 'hijo'),
(19, 12, 'hijo'),
(19, 13, 'hijo'),
(24, 15, 'hijo'),
(24, 14, 'hijo'),
(25, 15, 'hijo'),
(25, 14, 'hijo'),
(20, 17, 'hijo'),
(20, 16, 'hijo'),
(21, 17, 'hijo'),
(21, 16, 'hijo'),
(22, 17, 'hijo'),
(22, 16, 'hijo'),
(23, 17, 'hijo'),
(23, 16, 'hijo');

-- Eventos de la Familia Real de España
-- Matrimonios de la Familia Real de España
INSERT INTO arbolgenealogico.evento (tipo, fecha_evento, ID_persona) VALUES
('matrimonio', '1935-10-12', 1), -- Matrimonio de Juan de Borbón
('matrimonio', '1935-10-12', 2), -- Matrimonio de María de las Mercedes de Borbón y Orleans
('matrimonio', '1938-01-09', 3), -- Matrimonio de Pablo I de Grecia
('matrimonio', '1938-01-09', 4), -- Matrimonio de Federica de Hannover
('matrimonio', '1962-05-14', 5),  -- Matrimonio de Juan Carlos I
('matrimonio', '1962-05-14', 6),  -- Matrimonio de Sofía de Grecia
('matrimonio', '2004-05-22', 12), -- Matrimonio de Felipe VI
('matrimonio', '2004-05-22', 13), -- Matrimonio de Letizia Ortiz
('matrimonio', '1995-03-18', 14), -- Matrimonio de Elena de Borbón
('matrimonio', '1995-03-18', 15), -- Matrimonio de Jaime de Marichalar
('matrimonio', '1997-10-04', 16), -- Matrimonio de Cristina de Borbón
('matrimonio', '1997-10-04', 17); -- Matrimonio de Iñaki Urdangarin

-- Nacimientos de la Familia Real de España
INSERT INTO arbolgenealogico.evento (tipo, fecha_evento, ID_persona) VALUES
-- Generación anterior a Juan Carlos I
('nacimiento', '1913-06-20', 1), -- Nacimiento de Juan de Borbón
('fallecimiento', '1993-04-01', 1), -- Fallecimiento de Juan de Borbón
('nacimiento', '1910-12-23', 2), -- Nacimiento de María de las Mercedes
('fallecimiento', '2000-01-02', 2), -- Fallecimiento de María de las Mercedes
('nacimiento', '1901-12-14', 3), -- Nacimiento de Pablo I de Grecia
('fallecimiento', '1964-03-06', 3), -- Fallecimiento de Pablo I de Grecia
('nacimiento', '1917-03-18', 4), -- Nacimiento de Federica de Hannover
('fallecimiento', '1981-02-06', 4), -- Fallecimiento de Federica de Hannover
-- Juan Carlos I y Sofía de Grecia
('nacimiento', '1938-01-05', 5), -- Nacimiento de Juan Carlos I
('nacimiento', '1938-11-02', 6), -- Nacimiento de Sofía de Grecia
-- Hermanos de Juan Carlos I
('nacimiento', '1936-07-30', 7), -- Nacimiento de Pilar de Borbón y Borbón
('fallecimiento', '2020-01-08', 7), -- Fallecimiento de Pilar de Borbón y Borbón
('nacimiento', '1939-03-06', 8), -- Nacimiento de Margarita de Borbón y Borbón
('nacimiento', '1941-10-03', 9), -- Nacimiento de Alfonso de Borbón
('fallecimiento', '1956-03-29', 9), -- Fallecimiento de Alfonso de Borbón
-- Hermanos de Sofía de Grecia
('nacimiento', '1940-06-02', 10), -- Nacimiento de Constantino II de Grecia
('fallecimiento', '2023-01-10', 10), -- Fallecimiento de Constantino II de Grecia
('nacimiento', '1942-05-11', 11), -- Nacimiento de Irene de Grecia
-- Generación Felipe VI
('nacimiento', '1968-01-30', 12), -- Nacimiento de Felipe VI
('nacimiento', '1972-09-15', 13), -- Nacimiento de Letizia Ortiz
('nacimiento', '1963-12-20', 14), -- Nacimiento de Elena de Borbón
('nacimiento', '1963-04-07', 15), -- Nacimiento de Jaime de Marichalar
('nacimiento', '1965-06-13', 16), -- Nacimiento de Cristina de Borbón
('nacimiento', '1968-01-15', 17), -- Nacimiento de Iñaki Urdangarin
-- Hijos de Felipe VI
('nacimiento', '2005-10-31', 18), -- Nacimiento de Leonor de Borbón
('nacimiento', '2007-04-29', 19), -- Nacimiento de Sofía de Borbón
-- Hijos de la Infanta Cristina
('nacimiento', '1999-09-29', 20), -- Nacimiento de Juan Valentín
('nacimiento', '2000-12-06', 21), -- Nacimiento de Pablo Nicolás
('nacimiento', '2002-04-30', 22), -- Nacimiento de Miguel Urdangarin
('nacimiento', '2005-06-05', 23), -- Nacimiento de Irene Urdangarin
-- Hijos de la Infanta Elena
('nacimiento', '1998-07-17', 24), -- Nacimiento de Felipe Juan Froilán
('nacimiento', '2000-09-09', 25); -- Nacimiento de Victoria Federica

