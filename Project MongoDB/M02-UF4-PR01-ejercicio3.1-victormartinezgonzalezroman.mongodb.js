/*
Víctor Martínez González Román
M02-UF3-PR01 Ejercicio #3 P1 -  Actualización y eliminación
Código manipulando los datos de la BBDD air_control_NO_SQL_vm y sus colecciones

El código JavaScript ha sido desarrollado utilizando el programa Visual Studio Code
*/

//Base de datos que vamos a utilizar (la añadiré encima de cada operación para que puedan ser ejecuadas una a una sobre esta bbdd)
use("air_control_NO_SQL_vm");

//Actualización y eliminación: 
//Actualiza la fecha de salida y llegada de un vuelo.
use("air_control_NO_SQL_vm");
db.vuelos.updateOne(
    { codigo_vuelo: "VM003" }, //Actualizamos el campo con código_vuelo "VM003"
    {
        $set: { //Datos a cambiar:
            fecha_salida: new Date("2025-01-10T09:00:00Z"), //Actualizamos la fecha de salida a las 9:00 de la mañana, originalmente 8:30
            fecha_llegada: new Date("2025-01-10T10:00:00Z") //Actualizamos la fecha de llegada a las 10:00, originalmente 9:30
        }
    }
);

//Cambia el piloto asignado a un vuelo.
use("air_control_NO_SQL_vm");
db.vuelos.updateOne(
    { codigo_vuelo: "VM021" }, //Actualizamos el campo con código_vuelo "VM021"
    {
        $set: { //Datos a cambiar:
            //El piloto está asignado a la primera posición (0) del array tripulación, en este vuelo cambiamos su DNI por el de otro piloto
            "tripulacion.0": "79206895M" //Indicando la posición del array que queremos cambiar con un punto,
            //  nos aseguramos de que solo se actualize este campo dentro del array
            //A diferencia de actualizar tripulacion:{0:"79206895M"}, que substituiría el array completo por este
        }
    }
);

//Elimina dos aviones de la flota. Selecciona los aviones por su matrícula o ID único.
use("air_control_NO_SQL_vm");
db.aviones.deleteMany({ //Borramos los aviones con matrícula "EC-JJK" o "EC-OOP"
    $or: [ //Operador OR
        { matricula: "EC-JJK" },
        { matricula: "EC-OOP" }
    ]
});

//Elimina un pasajero de un vuelo específico. Identifica al pasajero utilizando su DNI y asocia el vuelo correspondiente.

db.pasajeros.updateOne(
    { DNI: "64551386Y", codigo_vuelo: "VM001" }, //Identificamos el pasajero por su DNI y su código de vuelo
    {
        $unset: { //Unset permite eliminar atributos del pasajero por el que estamos filtrando
            codigo_vuelo: "" //Anteriormente, en el vuelo con código "VM001"
        }
    }
);