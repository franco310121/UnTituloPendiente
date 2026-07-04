extends Node2D

const ROW_STEP = 6.0 

var direction := Vector2.RIGHT
var speed := 30.0 

@onready var block_timer = $BlockTimer
@onready var shot_timer = $ShotTimer

# NUEVO: Protección para que la fila no herede rebotes raros en el frame 1
var spawn_protection := true

func _ready():
	if shot_timer and shot_timer.is_stopped():
		shot_timer.start()
		
	# Apagamos la protección después de medio segundo de haber nacido en (0,0)
	await get_tree().create_timer(0.5).timeout
	spawn_protection = false

func _process(delta: float):
	global_position.x += direction.x * speed * delta

func change_direction():
	# Si la fila acaba de nacer o el block_timer está activo, ignoramos el rebote
	if spawn_protection or (block_timer and block_timer.time_left > 0):
		return
		
	if direction == Vector2.RIGHT:
		direction = Vector2.LEFT
	else:
		direction = Vector2.RIGHT
		
	global_position.y += ROW_STEP
	
	if block_timer:
		block_timer.start()

func _on_shot_timer_timeout():
	var valid_enemies = []
	for child in get_children():
		if child is CharacterBody2D and child.has_method("shot") and not child.is_queued_for_deletion():
			valid_enemies.append(child)
			
	if valid_enemies.size() > 0:
		var random_enemy = valid_enemies[randi() % valid_enemies.size()]
		random_enemy.shot()
