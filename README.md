# README Back-End TaTeTi Jokin Abarzua

## **Players**  
| Ruta | Endpoint | Descripcion | Success | Error |
| ---- | -------- | ----------- | ------- | ----- |
| GET /players  | index | Muestra todos los jugadores guardados en la base de datos | status 200 y arreglo de juadores | - |
| GET /player/login | login | Muestra el juador con el nombre y contraseña pasados como parametros, devolviendo su token entre los datos | status 200 y datos del jugador con su respectivo token | status 400 y mensaje "no se escontro el juador" |
| GET /player/:id | showById | Muestra el juador con el id pasado en la request | status 200 y datos del jugador con su respectivo token | status 400 y mensaje "no se escontro el juador" |
| POST /players | create | Registra un jugador nuevo con el nombre, alias y contraseña pasados como parametros | status 200 y datos del juador creado | status:400 y mensaje: @player.errors.details |
|DESTROY /player/:id|destroy|Elimina un juador del db checkeando su token que se pasa en el header | status 200 y mensaje: "Borrado con exito" | status 400 y mensaje: @board.errors.details o status 401 y mensaje "No coincide el token" | 
## **Boards**
| Ruta | Endpoint | Descripcion | Success | Fail |
| ---- | -------- | ----------- | ------- | ---- |
|GET /boards | index | Muestra todos los boards guardados en la base de datos | status 200 y arreglo de boards| - |
|GET /boards/:id | show | Muestra el board de id pasado en la request | status 200, datos del board y nombre de los players que estan jugando | status 404 y mensaje "Juego no encontrado" |
|POST /players/:player_id/boards | create | Crea un Board que pertenece al player pasado en la request y lo asigna al board como player 1 checkeando su token que se pasa en el header | status 200 y datos del board creado | status:400 y mensaje @board.errors.details o status 404 y mensaje "Jugador no encontrado" o status 401 y mensaje "No coincide el token"|
|POST /players/:player_id/boards/:name/join | join | El jugador de id pasada en la reques se une como jugador2 al board de nombre pasado el la request | status 200, y datos del board al que se ingresó o status 210 y mensaje "El juego ya esta iniciado" | status 400 y mensaje @board.errors.details o status 404 y mensaje "Jugador no encontrado" o status 401 y mensaje "No coincide el token" |
|POST /players/:player_id/boards/:id/move | move | Se registra el movimiento pasado como parametro en el board de id pasado en la request y hecho por el jugador de id pasada en la request, checkeando su token que se pasa en el header|status 200 y datos del board en el que se hizo la jugada o status 210 y mensaje "La casilla ya esta marcada" o status 211 y mensaje "no es su turno" o status 212 y mensaje "El juego no a comenzado aun, esperando al jugador 2" | status 400 y mensaje @board.errors.details o status 404 y mensaje "Jugador no encontrado" o status 401 y mensaje "No coincide el token"|
|DESTROY /players/:player_id/boards/:id | destroy | Elimina un board checkeando su token que se pasa en el header |status 200 y mensaje "Borrado con exito" | status 400 y mensaje @board.errors.details o status 404 y mensaje "Jugador no encontrado" o status 401 y mensaje "No tiene permiso para eliminar la partida" o status 401 y mensaje "No coincide el token"|
 