extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D

var jugador_cerca = false

# Cambiamos el tipo a String y añadimos el atributo file para que Godot nos abra un selector
@export_file("*.tscn") var ruta_escena_destino: String 

func _ready():
	sprite_2d.visible = false

func _on_body_entered(body):
	if body.name == "Player": 
		jugador_cerca = true
		sprite_2d.visible = true

func _on_body_exited(body):
	if body.name == "Player":
		jugador_cerca = false
		sprite_2d.visible = false

func _input(event):
	if jugador_cerca and event.is_action_pressed("interact"):
		# Verificamos que la ruta no esté vacía
		if ruta_escena_destino != "":
			# Usamos change_scene_to_file para cargar mediante la ruta
			get_tree().change_scene_to_file(ruta_escena_destino)
		else:
			print("Error: No has asignado ninguna ruta de escena en el Inspector.")
