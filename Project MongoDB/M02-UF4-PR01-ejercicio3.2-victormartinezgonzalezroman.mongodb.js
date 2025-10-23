/*
Víctor Martínez González Román
M02-UF3-PR01 Ejercicio #3 P2 -  Consultas
Código para realizar varias selecciones en la BBDD air_control_NO_SQL_vm y sus colecciones

El código JavaScript ha sido desarrollado utilizando el programa Visual Studio Code
*/

//Base de datos que vamos a utilizar (la añadiré encima de cada operación para que puedan ser ejecuadas una a una sobre esta bbdd)
use("air_control_NO_SQL_vm");

//### Consultas: ###
//## Consulta básica: ##
//Listar todos los aeropuertos con sus datos básicos. 
use("air_control_NO_SQL_vm");
db.aeropuertos.find();

//## Consultas avanzadas: ##
//Información de los vuelos, incluyendo datos de pasajeros y aeropuertos de origen y destino. 
//Resolver utilizando: 

//# Comando find y operadores de proyección. #
//Con proyección podemos indicar los campos que mostrar con un 1, si no queremos mostrar la _id, la marcamos con un 0. 
use("air_control_NO_SQL_vm");
db.vuelos.find({}, { codigo_vuelo: 1, origen: 1, destino: 1, _id: 0 });

//También puede utilizarse desde la función aggregate():
use("air_control_NO_SQL_vm");
db.vuelos.aggregate([{
    $project: {
        codigo_vuelo: 1,
        origen: 1,
        destino: 1,
        _id: 0
    }
}]);

//*No acabo de entender si he de realizar una consulta o varias, como necesito $lookup para juntar datos de dos colecciones, lo realizaré en la siguiente operación.

//# Pipeline de agregación con $lookup. #

use("air_control_NO_SQL_vm");
db.vuelos.aggregate([
    {
        $lookup: { //$lookup funciona de una manera similar a JOIN en SQL 
            from: "pasajeros", //Colección que unir
            localField: "codigo_vuelo", //Campo local por el que realizar la unión
            foreignField: "codigo_vuelo", //Campo con el que realizar la unión
            as: "pasajeros" //Nombre del array donde se almacena el resultado
        }
    },
    //Realizamos 2 lookups más para los datos de los aeropuertos, deben estar en etapas separadas en la pipeline
    {
        $lookup: {
            from: "aeropuertos",
            localField: "origen",
            foreignField: "codigo_aeropuerto",
            as: "origen"
        }
    },
    {
        $lookup: {
            from: "aeropuertos",
            localField: "destino",
            foreignField: "codigo_aeropuerto",
            as: "destino"
        }
    },
    {
        $project: {
            codigo_vuelo: 1,
            //He substituído los códigos de los aeropuertos por sus nombres: 
            origen: {
                nombre: 1
            },
            destino: {
                nombre: 1
            },
            avion: "$matricula_avion", //Mostramos el contenido de matricula_avión en un nuevo campo con otro nombre
            pasajeros: {//Nuevo campo que incluye los pasajeros relacionados a este vuelo
                //Campos que queremos mostrar de pasajeros:
                DNI: 1,
                nombre: 1,
                apellidos: 1
            },
            _id: 0
        }
    }
]);

//# EXTRA #
//Como la anterior consulta ocupa mucho espacio, he buscado métodos para reducir el espacio que ocupan los datos
use("air_control_NO_SQL_vm");
db.vuelos.aggregate([
    { $lookup: { from: "pasajeros", localField: "codigo_vuelo", foreignField: "codigo_vuelo", as: "pasajeros" } },
    { $lookup: { from: "aeropuertos", localField: "origen", foreignField: "codigo_aeropuerto", as: "origen" } },
    { $lookup: { from: "aeropuertos", localField: "destino", foreignField: "codigo_aeropuerto", as: "destino" } },
    {
        $project: {
            codigo_vuelo: 1,
            origen: { $arrayElemAt: ["$origen.nombre", 0] }, // $origen.nombre hace referencia al campo nombre del array $origen resultado del $lookup
            destino: { $arrayElemAt: ["$destino.nombre", 0] }, // $origen.nombre, es un array con un solo dato, el nombre en la posición 0
            avion: "$matricula_avion",
            //Haciendo esto, mostramos el campo nombre directamente, en vez de mostrarlo dentro del array $origen
            //Quiero concatenar el nombre y el apellido de los pasajeros en un solo campo. Pero no puedo ya que los datos no existen dentro del $project
            // sinó dentro del array pasajeros
            pasajeros: {
                $map: { //$map permite aplicar funciones a los elementos individuales del array
                    input: "$pasajeros", //Array a transformar
                    as: "pasajero", //Nombre que le damos al elemento individual
                    in: { //Expresiones que apicamos a cada elemento individual:
                        DNI: "$$pasajero.DNI", //DNI se mantiene igual
                        //Etapa $concat de los dos datos separados por un espacio, en el campo nombre
                        nombre: { $concat: ["$$pasajero.nombre", " ", "$$pasajero.apellidos"] }
                    }
                }
            },
            _id: 0
        }
    }
]);

//# Contar vuelos realizados por cada avión agrupados por día de la semana. Sugerencia: Usa $group y $dayOfWeek para realizar el agrupamiento. #
use("air_control_NO_SQL_vm");
db.aviones.aggregate([
    {
        $lookup: { //Relacionamos 
            from: "vuelos",
            localField: "matricula",
            foreignField: "matricula_avion",
            as: "vuelo"
        }
    },
    {
        //Como no se puede trabajar sobre los datos del array vuelo directamente, utilizamos $unwind,
        // de manera similar a $map, uniwnd nos permite trabajar con los valores de los campos dentro de un array.
        $unwind: "$vuelo"

    },
    {
        $group: { //La etapa group, nos permite crear una agrupación donde varios valores coincidan
            //Agrupamos por matrícula del avión y día de la semana en la fecha del vuelo:
            _id: { matricula: "$matricula", dia_semana: { $dayOfWeek: "$vuelo.fecha_salida" } },
            num_vuelos: { $sum: 1 }  // Contamos el número de la matrícula del avión coincide con el día de la semana
            // El número resultante, es el número de vuelos que un avión ha hecho en uno de los días de la semana
        }
    },
    {
        $project: {
            //El resultado de la agrupación se ha guardado en un array en _id, por lo tanto:
            _id: 0, //Escondemos el array de la agrupación
            avion: "$_id.matricula", //Obtenemos la matrícula del avion desde la agrupación _id
            dia_semana: "$_id.dia_semana", //Hacemos lo mismo para el día de la semana
            //$dayOfWeek muestra el día de la semana de una Date, empezando por 1 si la fecha es un domingo, hasta 7 si es un sábado
            num_vuelos: 1  // Mostrar el número de que ha hecho ese avión ese día
        }
    }
]);

//  Obtener los datos del último vuelo del día utilizando una subconsulta ($sort y $limit).
use("air_control_NO_SQL_vm");
db.vuelos.aggregate([
    {
        $sort: {
            fecha_salida: -1 //Ordenar por fechas en orden descendiente (fecha más reciente primero)
        }
    },
    {
        $limit: 1 //Muestra el primer elemento
    },
    {
        $project:{
            //Datos que queremos excluir:
            _id: 0,
            tripulacion: 0
        }
    }
]);
