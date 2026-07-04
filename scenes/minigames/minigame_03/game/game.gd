extends Node2D

const ENEMY_GROUP_SCENE = preload("res://scenes/minigames/minigame_03/elements/enemy_group/enemy_group.tscn")

@onready var label_victoria = $Label # Referencia a tu Label

var spawn_position := Vector2(0, 0)
const DISTANCE_BETWEEN_ROWS = 45.0

var last_spawned_row: Node2D = null
var game_over_active := false
var is_spawning := false

func _ready():
	label_victoria.visible = false
	
	if Events.has_signal("lives_changed"):
		Events.lives_changed.connect(_on_lives_changed)
	
	# Conectamos la señal de puntos si existe
	if Events.has_signal("points_changed"):
		Events.points_changed.connect(_on_points_changed)
	
	spawn_new_row()

# --- NUEVA FUNCIÓN PARA ESCUCHAR PUNTOS ---
func _on_points_changed(new_points: int):
	if new_points >= 14:
		mostrar_mensaje_especial("¡NIVEL COMPLETADO!")

func mostrar_mensaje_especial(mensaje: String):
	label_victoria.text = mensaje
	label_victoria.visible = true
	
	# Opcional: hacer que desaparezca después de 2 segundos
	await get_tree().create_timer(2.0, true).timeout
	label_victoria.visible = false

# --- EL RESTO DE TU CÓDIGO ---
func _process(_delta: float):
	if game_over_active or is_spawning:
		return
		
	if is_instance_valid(last_spawned_row):
		if last_spawned_row.global_position.y >= (spawn_position.y + DISTANCE_BETWEEN_ROWS):
			spawn_new_row()

func spawn_new_row():
	is_spawning = true
	var new_row = ENEMY_GROUP_SCENE.instantiate()
	new_row.global_position = spawn_position
	add_child(new_row)
	last_spawned_row = new_row
	await get_tree().process_frame
	is_spawning = false

func _on_lives_changed(new_lives: int):
	if new_lives <= 0 and not game_over_active:
		game_over_active = true
		get_tree().paused = true
		var game_over_scene = preload("res://scenes/minigames/minigame_03/ui/game_over/game_over.tscn")
		var game_over = game_over_scene.instantiate()
		add_child(game_over)
		if has_node("SpaceShip"):
			$SpaceShip.queue_free()
