extends CanvasLayer

# Referencias a los botones (opcional, pero buena práctica)
@onready var start_button: Button = $UIContainer/ButtonsContainer/StartButton
@onready var exit_button: Button = $UIContainer/ButtonsContainer/ExitButton

# Reemplaza esto con la ruta real de tu primera escena de juego (ej: "res://levels/first_level.tscn")
const FIRST_SCENE_PATH = "res://scenes/main.tscn"

func _ready():
	# Nos aseguramos de que el juego esté en modo ratón al iniciar el menú
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# Esta función se llama cuando se presiona el botón "Iniciar Juego"
func _on_start_button_pressed():
	# Verificamos que la ruta de la escena no esté vacía
	if FIRST_SCENE_PATH != "":
		# Cambiamos instantáneamente a la escena de juego
		get_tree().change_scene_to_file(FIRST_SCENE_PATH)
	else:
		print("Error: No se ha configurado la ruta de la primera escena.")

# Esta función se llama cuando se presiona el botón "Salir"
func _on_exit_button_pressed():
	# Cerramos el juego por completo
	get_tree().quit()
