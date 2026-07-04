extends Node

# Datos del personaje (Persistentes)
var nivel_estres: float = 0.0
var nivel_cansancio: float = 0.0
var dinero: int = 100
var inventario: Array[ItemData] = [] # Usando el recurso que definimos antes

# Datos de navegación
var posicion_spawn: Vector2 = Vector2.ZERO

# Función para cambiar de escena conservando la posición
func cambiar_escena_con_spawn(ruta_escena: PackedScene, nueva_posicion: Vector2):
	posicion_spawn = nueva_posicion
	get_tree().call_deferred("change_scene_to_packed", ruta_escena)

# Función para actualizar datos desde cualquier script
func actualizar_estado(estres: float, cansancio: float, nuevo_dinero: int):
	nivel_estres = estres
	nivel_cansancio = cansancio
	dinero = nuevo_dinero
