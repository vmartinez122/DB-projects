/*
Víctor Martínez González Román
M02-UF3-PR01 Ejercicio #1 – Creación de la base de datos y colecciones
Código de creación de la BBDD air_control_NO_SQL_vm y sus colecciones

El código JavaScript ha sido desarrollado utilizando el programa Visual Studio Code
*/

//Crear una base de datos utilizando use. 
use("air_control_NO_SQL_vm");

//## Diseñar las siguientes colecciones: ##
//aeropuertos:  
//Almacena la información básica de los aeropuertos (nombre, ciudad y código único).
db.createCollection("aeropuertos", {
  validator: { //JSON Schema que valida las entradas a la colección, dentro de este, podemos definir directamente un $jsonSchema:
    $jsonSchema: {
      //bsonType se utiliza para declarar el tipo de dato
      bsonType: "object", //Hemos de declarar $jsonSchema como un objeto
      required: ["nombre", "ciudad", "codigo_aeropuerto"],
      properties: {
        nombre: {
          bsonType: "string",
          description: "Nombre del aeropuerto, debe ser un string y es obligatorio."
        },
        ciudad: {
          bsonType: "string",
          description: "Ciudad donde está localizado el aeropuerto, debe ser un string y es obligatorio."
        },
        codigo_aeropuerto: {
          bsonType: "string",
          //Para datos formados de una cantidad específica de carácteres, podemos delimitar el número de carácteres mínimos y máximos.
          minLength: 3,
          maxLength: 3,
          description: "Código identificativo del aeropuerto formado de 3 letras, es obligatorio y ha de ser único."
        }
      }
      //Campos obligatorios, cuando insertemos datos:   
    }
  }
});

// Crear un í­ndice único en el campo "codigo_aeropuerto" para asegurar que no se repiten los códigos
db.aeropuertos.createIndex({ codigo_aeropuerto: 1 }, { unique: true });

//vuelos:  
//Incluye datos como origen, destino, fecha de salida, fecha de llegada y tripulación (IDs). 
db.createCollection("vuelos", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["codigo_vuelo", "origen", "destino"],
      properties: {
        codigo_vuelo: {
          bsonType: "string",
          description: "Código identificador del vuelo, formato string, obligatorio"
        },
        origen: {
          bsonType: "string",
          minLength: 3,
          maxLength: 3,
          description: "Código del aeropuerto de origen, formato String, obligatorio."
        },
        destino: {
          bsonType: "string",
          description: "Código del aeropuerto de destino, formato String, obligatorio."
        },
        fecha_salida: {
          bsonType: "date",
          description: "Fecha de salida del vuelo, formato Date."
        },
        fecha_llegada: {
          bsonType: "date",
          description: "Fecha de llegada del vuelo, formato Date."
        },
        tripulacion: {
          //Como en un vuelo hay varios tripulantes, he decidido crear un tipo array de int,
          //  para poder almacenar los ID de todos los tripulantes del vuelo
          bsonType: "array",
          items: {
            //Las IDs en este caso, son DNI en formato string
            bsonType: "string",
            minLength: 9,
            maxLength: 9
          },
          description: "Lista de DNI de tripulantes del vuelo, formato string de 9 carácteres."
        },
        matricula_avion: {
          bsonType: "string",
          description: "Matrícula del avión, formato String."
        }
      }
    }
  }
});

//aviones:  
//Contiene detalles de cada avión como matrícula, modelo, capacidad y estado. 
db.createCollection("aviones", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["matricula"],
      properties: {
        matricula: {
          bsonType: "string",
          description: "Matrícula del avión, formato String, obligatorio."
        },
        modelo: {
          bsonType: "string",
          description: "Modelo del avión, formato String."
        },
        capacidad: {
          bsonType: "int",
          description: "Capacidad de personas que transporta el avión, formato entero."
        },
        estado: {
          bsonType: "string",
          //Para mejor organización de los vuelos, podemos definir un enumerator, con los valores que puede tener este campo
          //Solamente serán válidos los valores dentro del enumerator y por ente, el campo se vuelve obligatorio.
          enum: ["Inactivo", "Programado", "En vuelo", "Aterrizado", , "Cancelado"],
          description: "Estado actual del vuelo, posibles valores: [Inactivo, Programado, En vuelo, Aterrizado, Cancelado]."
        }
      }
    }
  }
});
//Creamos un índice para que las matículas de los aviones sean únicas
db.aviones.createIndex({ matricula: 1 }, { unique: true });

//tripulantes:  
//Registra información del personal a bordo (DNI, nombre, apellidos, categoría y teléfono). 
db.createCollection("tripulantes", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["DNI"],
      properties: {
        DNI: {
          bsonType: "string",
          //La longitud del DNI tiene una longitud obligada de carácteres
          minLength: 9,
          maxLength: 9,
          description: "DNI del tripulante, formato String de 9 carácteres, obligatorio."
        },
        nombre: {
          bsonType: "string",
          description: "Nombre del tripulante, formato String."
        },
        apellidos: {
          bsonType: "string",
          description: "Apellidos del tripulante, formato String."
        },
        categoria: {
          bsonType: "string",
          description: "Categoría o rol del tripulante, formato String."
        },
        telefono: {
          bsonType: "int",
          minLength: 9,
          maxLength: 9,
          description: "Número de teléfono del tripulante, formato entero de 9 dígitos."
        }

      }
    }
  }
});

//pasajeros:  
//Almacena datos de los pasajeros (DNI, nombre, apellidos, teléfono, email y vuelo asociado).
db.createCollection("pasajeros", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["DNI"],
      properties: {
        DNI: {
          bsonType: "string",
          //La longitud del DNI tiene una longitud obligada de carácteres
          minLength: 9,
          maxLength: 9,
          description: "DNI del pasajero, formato String de 9 carácteres, obligatorio."
        },
        nombre: {
          bsonType: "string",
          description: "Nombre del pasajero, formato String."
        },
        apellidos: {
          bsonType: "string",
          description: "Apellidos del pasajero, formato String."
        },
        telefono: {
          bsonType: "int",
          minLength: 9,
          maxLength: 9,
          description: "Número de teléfono del pasajero, formato entero de 9 dígitos."
        },
        email: {
          bsonType: "string",
          description: "Mail del pasajero, formato String."
        },
        codigo_vuelo: {
          //Para poder asociar un pasajero con un vuelo, podemos utilizar el objectID que genera mongoDB automáticamente
          // cada vez que creamos un vuelo
          bsonType: "string",
          description: "Relación al vuelo del pasajero mediante el cófigo del vuelo, formato string."
        }
      }
    }
  }
});