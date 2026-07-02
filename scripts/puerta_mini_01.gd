extends Area2D

# Referencia al sprite del botón que vamos a mostrar/ocultar
@onready var sprite_2d: Sprite2D = $Sprite2D

# Variable para saber si el jugador está dentro de la zona
var jugador_cerca = false

# Esto creará un casillero en el Inspector para que arrastres ahí 
# la escena a la que quieres viajar (ej. "second_floor.tscn")
@export var escena_destino: PackedScene 

func _ready():
	# Asegurarnos de que el botón esté oculto al iniciar
	sprite_2d.visible = false

# Esta función se activa automáticamente cuando un cuerpo entra al área
func _on_body_entered(body):
	# Comprobamos que el que entró fue el jugador
	if body.name == "Player": 
		jugador_cerca = true
		sprite_2d.visible = true # Mostramos el botón

# Esta función se activa cuando un cuerpo sale del área
func _on_body_exited(body):
	if body.name == "Player":
		jugador_cerca = false
		sprite_2d.visible = false # Ocultamos el botón

# Esta función escucha los botones que presiona el usuario
func _input(event):
	# Si el jugador está cerca Y presiona la acción "interactuar" que creamos
	if jugador_cerca and event.is_action_pressed("interact"):
		# Verificamos que hayas asignado una escena en el inspector
		if escena_destino != null:
			# Cambiamos de escena
			get_tree().change_scene_to_packed(escena_destino)
		else:
			print("Error: No has asignado ninguna escena_destino en el Inspector.")
