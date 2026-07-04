extends Area2D

# Marcador donde el jugador aparecerá (arrastra un Marker2D aquí desde el Inspector)
@export var punto_destino: Marker2D 

func _on_body_entered(body):
	# Verificamos que el nodo sea el Player
	if body.name == "Player": 
		if punto_destino != null:
			# Transportamos al jugador instantáneamente a las coordenadas del marcador
			body.global_position = punto_destino.global_position
		else:
			push_warning("¡Error! No has asignado un punto_destino en el Inspector para: ", name)
