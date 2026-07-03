extends Area2D

# Configura esto en el Inspector para cada puerta
@export var escena_destino: PackedScene 
@export var posicion_destino: Vector2 = Vector2.ZERO 

func _on_body_entered(body):
	# Verificamos que el nodo tenga el nombre "Player"
	# Nota: Asegúrate que tu nodo Player en todas las escenas se llame exactamente "Player"
	if body.name == "Player": 
		if escena_destino:
			# Usamos el método de tu GameManager para manejar el cambio y el spawn
			GameManager.cambiar_escena_con_spawn(escena_destino, posicion_destino)
		else:
			push_error("La puerta ", name, " no tiene una escena_destino asignada.")
