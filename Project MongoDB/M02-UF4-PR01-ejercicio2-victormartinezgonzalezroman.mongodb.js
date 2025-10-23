/*
Víctor Martínez González Román
M02-UF3-PR01 Ejercicio #2 - Inserción de datos
Código de inserción de datos en la BBDD air_control_NO_SQL_vm y sus colecciones

El código JavaScript ha sido desarrollado utilizando el programa Visual Studio Code
*/


//## Método 1: ##
//Inserción directa mediante insertMany.

//Base de datos que vamos a utilizar (la añadiré encima de cada operación para que puedan ser ejecuadas una a una sobre esta bbdd)
use("air_control_NO_SQL_vm");

//Carga de datos en las colecciones (los campos con una "!" són obligatorios):
//He reutilizado los datos de prácticas anteriores para realizar las inserciones

/** aeropuertos
 ! nombre
 ! ciudad
 ! codigo_aeropuerto
**/
use("air_control_NO_SQL_vm");
db.aeropuertos.insertMany([
    {
        nombre: "Barcelona-El Prat",
        ciudad: "Barcelona",
        codigo_aeropuerto: "BCN"
    },
    {
        nombre: "Adolfo Suárez Madrid-Barajas",
        ciudad: "Madrid",
        codigo_aeropuerto: "MAD"
    },
    {
        nombre: "Aeropuerto de Pamplona",
        ciudad: "Pamplona",
        codigo_aeropuerto: "PNA"
    }
]);

/** vuelos
 ! codigo_vuelo
 ! origen
 ! destino
 * fecha_salida
 * fecha_llegada
 * tripulacion[]
 * matricula_avion
**/
use("air_control_NO_SQL_vm");
db.vuelos.insertMany([
    // Vuelos viernes
    {
        codigo_vuelo: "VM001", origen: "BCN", destino: "MAD", fecha_salida: new Date("2025-01-10T08:00:00Z"), fecha_llegada: new Date("2025-01-10T09:00:00Z"),
        tripulacion: ["28991694E", "97992883V", "20080406D", "22764825Y", "92749284X"], matricula_avion: "EC-AAB"
    },
    {
        codigo_vuelo: "VM002", origen: "MAD", destino: "PNA", fecha_salida: new Date("2025-01-10T08:15:00Z"), fecha_llegada: new Date("2025-01-10T09:15:00Z"),
        tripulacion: ["28991694E", "97992883V", "20080406D", "22764825Y", "92749284X"], matricula_avion: "EC-AAB"
    },
    {
        codigo_vuelo: "VM003", origen: "PNA", destino: "BCN", fecha_salida: new Date("2025-01-10T08:30:00Z"), fecha_llegada: new Date("2025-01-10T09:30:00Z"),
        tripulacion: ["28991694E", "97992883V", "20080406D", "22764825Y", "92749284X"], matricula_avion: "EC-AAB"
    },
    {
        codigo_vuelo: "VM004", origen: "BCN", destino: "MAD", fecha_salida: new Date("2025-01-10T16:00:00Z"), fecha_llegada: new Date("2025-01-10T17:00:00Z"),
        tripulacion: ["14397596P", "83499705L", "31179700Z", "54683549M", "89890617P"], matricula_avion: "EC-BBC"
    },
    {
        codigo_vuelo: "VM005", origen: "MAD", destino: "PNA", fecha_salida: new Date("2025-01-10T16:15:00Z"), fecha_llegada: new Date("2025-01-10T17:15:00Z"),
        tripulacion: ["14397596P", "83499705L", "31179700Z", "54683549M", "89890617P"], matricula_avion: "EC-BBC", matricula_avion: "EC-BBC"
    },
    {
        codigo_vuelo: "VM006", origen: "PNA", destino: "BCN", fecha_salida: new Date("2025-01-10T16:30:00Z"), fecha_llegada: new Date("2025-01-10T17:30:00Z"),
        tripulacion: ["14397596P", "83499705L", "31179700Z", "54683549M", "89890617P"], matricula_avion: "EC-BBC"
    },
    {
        codigo_vuelo: "VM007", origen: "BCN", destino: "MAD", fecha_salida: new Date("2025-01-10T22:00:00Z"), fecha_llegada: new Date("2025-01-10T23:00:00Z"),
        tripulacion: ["85180074J", "69816483N", "83126191P", "59037358C", "38581300A"], matricula_avion: "EC-CCD"
    },
    {
        codigo_vuelo: "VM008", origen: "MAD", destino: "PNA", fecha_salida: new Date("2025-01-10T22:15:00Z"), fecha_llegada: new Date("2025-01-10T23:15:00Z"),
        tripulacion: ["85180074J", "69816483N", "83126191P", "59037358C", "38581300A"], matricula_avion: "EC-CCD"
    },
    {
        codigo_vuelo: "VM009", origen: "PNA", destino: "BCN", fecha_salida: new Date("2025-01-10T22:30:00Z"), fecha_llegada: new Date("2025-01-10T23:30:00Z"),
        tripulacion: ["85180074J", "69816483N", "83126191P", "59037358C", "38581300A"], matricula_avion: "EC-CCD"
    },
    // Vuelos sábado
    {
        codigo_vuelo: "VM010", origen: "BCN", destino: "MAD", fecha_salida: new Date("2025-01-11T08:00:00Z"), fecha_llegada: new Date("2025-01-11T09:00:00Z"),
        tripulacion: ["16429576X", "89755002B", "83584668Y", "10544341V", "42108973M"], matricula_avion: "EC-DDE"
    },
    {
        codigo_vuelo: "VM011", origen: "MAD", destino: "PNA", fecha_salida: new Date("2025-01-11T08:15:00Z"), fecha_llegada: new Date("2025-01-11T09:15:00Z"),
        tripulacion: ["16429576X", "89755002B", "83584668Y", "10544341V", "42108973M"], matricula_avion: "EC-DDE"
    },
    {
        codigo_vuelo: "VM012", origen: "PNA", destino: "BCN", fecha_salida: new Date("2025-01-11T08:30:00Z"), fecha_llegada: new Date("2025-01-11T09:30:00Z"),
        tripulacion: ["16429576X", "89755002B", "83584668Y", "10544341V", "42108973M"], matricula_avion: "EC-DDE"
    },
    {
        codigo_vuelo: "VM013", origen: "BCN", destino: "MAD", fecha_salida: new Date("2025-01-11T16:00:00Z"), fecha_llegada: new Date("2025-01-11T17:00:00Z"),
        tripulacion: ["85370084A", "12988037E", "28236351J", "21171163Y", "87842118J"], matricula_avion: "EC-EEF"
    },
    {
        codigo_vuelo: "VM014", origen: "MAD", destino: "PNA", fecha_salida: new Date("2025-01-11T16:15:00Z"), fecha_llegada: new Date("2025-01-11T17:15:00Z"),
        tripulacion: ["85370084A", "12988037E", "28236351J", "21171163Y", "87842118J"], matricula_avion: "EC-EEF"
    },
    {
        codigo_vuelo: "VM015", origen: "PNA", destino: "BCN", fecha_salida: new Date("2025-01-11T16:30:00Z"), fecha_llegada: new Date("2025-01-11T17:30:00Z"),
        tripulacion: ["85370084A", "12988037E", "28236351J", "21171163Y", "87842118J"], matricula_avion: "EC-EEF"
    },
    {
        codigo_vuelo: "VM016", origen: "BCN", destino: "MAD", fecha_salida: new Date("2025-01-11T22:00:00Z"), fecha_llegada: new Date("2025-01-11T23:00:00Z"),
        tripulacion: ["25759131S", "90886118Z", "83386363E", "25126732Y", "54861801D"], matricula_avion: "EC-FFG"
    },
    {
        codigo_vuelo: "VM017", origen: "MAD", destino: "PNA", fecha_salida: new Date("2025-01-11T22:15:00Z"), fecha_llegada: new Date("2025-01-11T23:15:00Z"),
        tripulacion: ["25759131S", "90886118Z", "83386363E", "25126732Y", "54861801D"], matricula_avion: "EC-FFG"
    },
    {
        codigo_vuelo: "VM018", origen: "PNA", destino: "BCN", fecha_salida: new Date("2025-01-11T22:30:00Z"), fecha_llegada: new Date("2025-01-11T23:30:00Z"),
        tripulacion: ["25759131S", "90886118Z", "83386363E", "25126732Y", "54861801D"], matricula_avion: "EC-FFG"
    },
    // Vuelos domingo
    {
        codigo_vuelo: "VM019", origen: "BCN", destino: "MAD", fecha_salida: new Date("2025-01-12T08:00:00Z"), fecha_llegada: new Date("2025-01-12T09:00:00Z"),
        tripulacion: ["74898218B", "54691170A", "63728026M", "28513319E", "70833161P"], matricula_avion: "EC-GGH"
    },
    {
        codigo_vuelo: "VM020", origen: "MAD", destino: "PNA", fecha_salida: new Date("2025-01-12T08:15:00Z"), fecha_llegada: new Date("2025-01-12T09:15:00Z"),
        tripulacion: ["74898218B", "54691170A", "63728026M", "28513319E", "70833161P"], matricula_avion: "EC-GGH"
    },
    {
        codigo_vuelo: "VM021", origen: "PNA", destino: "BCN", fecha_salida: new Date("2025-01-12T08:30:00Z"), fecha_llegada: new Date("2025-01-12T09:30:00Z"),
        tripulacion: ["74898218B", "54691170A", "63728026M", "28513319E", "70833161P"], matricula_avion: "EC-GGH"
    },
    {
        codigo_vuelo: "VM022", origen: "BCN", destino: "MAD", fecha_salida: new Date("2025-01-12T16:00:00Z"), fecha_llegada: new Date("2025-01-12T17:00:00Z"),
        tripulacion: ["82691622P", "42093045R", "88410584J", "64509173H", "76904752P"], matricula_avion: "EC-HHI"
    },
    {
        codigo_vuelo: "VM023", origen: "MAD", destino: "PNA", fecha_salida: new Date("2025-01-12T16:15:00Z"), fecha_llegada: new Date("2025-01-12T17:15:00Z"),
        tripulacion: ["82691622P", "42093045R", "88410584J", "64509173H", "76904752P"], matricula_avion: "EC-HHI"
    },
    {
        codigo_vuelo: "VM024", origen: "PNA", destino: "BCN", fecha_salida: new Date("2025-01-12T16:30:00Z"), fecha_llegada: new Date("2025-01-12T17:30:00Z"),
        tripulacion: ["82691622P", "42093045R", "88410584J", "64509173H", "76904752P"], matricula_avion: "EC-HHI"
    },
    {
        codigo_vuelo: "VM025", origen: "BCN", destino: "MAD", fecha_salida: new Date("2025-01-12T22:00:00Z"), fecha_llegada: new Date("2025-01-12T23:00:00Z"),
        tripulacion: ["67988173B", "26058666Q", "26825589H", "23702334P", "71559727A"], matricula_avion: "EC-AAB"
    },
    {
        codigo_vuelo: "VM026", origen: "MAD", destino: "PNA", fecha_salida: new Date("2025-01-12T22:15:00Z"), fecha_llegada: new Date("2025-01-12T23:15:00Z"),
        tripulacion: ["67988173B", "26058666Q", "26825589H", "23702334P", "71559727A"], matricula_avion: "EC-AAB"
    },
    {
        codigo_vuelo: "VM027", origen: "PNA", destino: "BCN", fecha_salida: new Date("2025-01-12T22:30:00Z"), fecha_llegada: new Date("2025-01-12T23:30:00Z"),
        tripulacion: ["67988173B", "26058666Q", "26825589H", "23702334P", "71559727A"], matricula_avion: "EC-AAB"
    }
]);



/** aviones
 ! matricula
 * modelo
 * capacidad
 * estado (enum) [Inactivo, Programado, En vuelo, Aterrizado, Cancelado]
**/
use("air_control_NO_SQL_vm");
db.aviones.insertMany([
    { matricula: "EC-AAB", modelo: "Airbus A320", capacidad: 146, estado: "Programado" },
    { matricula: "EC-BBC", modelo: "Airbus A320", capacidad: 146, estado: "Programado" },
    { matricula: "EC-CCD", modelo: "Airbus A320", capacidad: 146, estado: "Programado" },
    { matricula: "EC-DDE", modelo: "Airbus A320", capacidad: 146, estado: "Programado" },
    { matricula: "EC-EEF", modelo: "Airbus A320", capacidad: 146, estado: "Programado" },
    { matricula: "EC-FFG", modelo: "Boeing 737", capacidad: 142, estado: "Programado" },
    { matricula: "EC-GGH", modelo: "Boeing 737", capacidad: 142, estado: "Programado" },
    { matricula: "EC-HHI", modelo: "Boeing 737", capacidad: 142, estado: "Programado" },
    { matricula: "EC-IIJ", modelo: "Boeing 737", capacidad: 142, estado: "Inactivo" },
    { matricula: "EC-JJK", modelo: "Boeing 737", capacidad: 142, estado: "Inactivo" },
    { matricula: "EC-KKL", modelo: "Airbus A320neo", capacidad: 146, estado: "Inactivo" },
    { matricula: "EC-LLM", modelo: "Airbus A320neo", capacidad: 146, estado: "Inactivo" },
    { matricula: "EC-MMN", modelo: "Airbus A320neo", capacidad: 146, estado: "Inactivo" },
    { matricula: "EC-NNO", modelo: "Airbus A320neo", capacidad: 146, estado: "Inactivo" },
    { matricula: "EC-OOP", modelo: "Airbus A320neo", capacidad: 146, estado: "Inactivo" }
]);

//## Método 2: ##
//Carga masiva desde un archivo externo:
//Para realizar las cargas en las colecciones con el mayor número de datos, he decidido utilizar archivos externos,
// de esta manera el código queda más organizado.
//He utlizado un archivo JSON para la colección de tripulantes y un archivo CSV para la tabla de pasajeros,
// dejo también la línea de código para cargar cada uno de ellos.

//Archivo JSON
//mongoimport -v --uri "<connection string>/air_control_NO_SQL_vm" --collection tripulantes --file "<ruta archivo>\tripulantes-victormartinezgonzalezroman.json" --jsonArray
/** tripulantes
 ! DNI
 * nombre
 * apellidos
 * categoria
 * telefono
**/

//Archivo CSV
//mongoimport -v --uri "<connection string>/air_control_NO_SQL_vm" --collection pasajeros --file "<ruta archivo>\pasajeros-victormartinezgonzalezroman.csv" --type csv --headerline
/** pasajeros
 ! DNI
 * nombre
 * apellidos
 * telefono
 * email
 * codigo_vuelo
**/