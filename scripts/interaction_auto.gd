extends Area2D

# Configura esto en el Inspector para cada puerta
@export var escena_destino: PackedScene 
@export var posicion_destino: Vector2 = Vector2.ZERO 

func _on_body_entered(body):
	# Verificamos que el nodo sea el Player
	if body.name == "Player": 
		if escena_destino != null:
			# Enviamos al jugador a la escena destino en la posición indicada
			GameManager.cambiar_escena_con_spawn(escena_destino, posicion_destino)
		else:
			print("Error: No has asignado ninguna escena_destino en el Inspector.")
