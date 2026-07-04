extends Control

func _ready():
	# Forzamos el filtro pixel-art (Nearest) usando la clase correcta CanvasItem
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	
	$VBoxContainer/ExitButton.pressed.connect(_on_exit_button_pressed)

func _on_play_button_pressed():
	# Reiniciamos las variables globales antes de que empiece la nueva partida
	Globals.points = 0
	Globals.lives = 5 # Iniciamos con tus 5 vidas configuradas
	
	# Cambia a tu escena principal de juego
	get_tree().change_scene_to_file("res://scenes/minigames/minigame_03/game/game.tscn")

func _on_exit_button_pressed():
	# Cierra la aplicación de forma segura
	get_tree().quit()
