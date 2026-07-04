extends CanvasLayer 

@onready var final_score_label = $MarginContainer/VBoxContainer/FinalScoreLabel

func _ready():	
	# AL ENTRAR: Leemos los puntos globales y los pintamos en el texto
	if final_score_label:
		final_score_label.text = "Puntaje Final: " + str(Globals.points)

func _on_restart_button_pressed():
	# 1. ESTO ES LO QUE TE FALTA: Despausar el motor antes de reiniciar
	get_tree().paused = false
	
	# 2. Reseteamos las variables globales
	Globals.points = 0
	Globals.lives = 5
	Events.lives_changed.emit(5)
	
	# 3. Cambiamos la escena
	get_tree().change_scene_to_file("res://scenes/minigames/minigame_03/game/game.tscn")
	
	# 4. Borramos el nodo actual
	queue_free() # Usar queue_free() es más seguro que get_parent().queue_free()

func _on_exit_button_pressed():
	get_tree().quit()
