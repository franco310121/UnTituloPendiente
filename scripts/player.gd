extends CharacterBody2D


const SPEED = 300.0
var last_direction: Vector2 = Vector2.RIGHT
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready():
	# Usamos call_deferred para esperar a que la escena se estabilice
	call_deferred("teletransportar_a_spawn")

func teletransportar_a_spawn():
	if GameManager.posicion_spawn != Vector2.ZERO:
		global_position = GameManager.posicion_spawn
		# IMPORTANTE: Resetea el spawn después de usarlo para que 
		# no se quede pegado si reinicias la escena
		GameManager.posicion_spawn = Vector2.ZERO
		
func _physics_process(_delta: float) -> void:
	process_movement()
	process_animation()
	move_and_slide()

func process_movement() -> void:
		# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("left", "right", "up", "down")
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		last_direction = direction
	else:
		velocity = Vector2.ZERO

func process_animation() -> void:
	if velocity != Vector2.ZERO:
		play_animation("move", last_direction)
	else: 
		play_animation("idle", last_direction)

func play_animation(prefix: String, dir: Vector2) -> void:
	if dir.x > 0:
		animated_sprite_2d.play(prefix + "_right")
	elif dir.x < 0:
		animated_sprite_2d.play(prefix + "_left")
	elif dir.y < 0:
		animated_sprite_2d.play(prefix + "_up")
	elif dir.y > 0:
		animated_sprite_2d.play(prefix + "_down")
