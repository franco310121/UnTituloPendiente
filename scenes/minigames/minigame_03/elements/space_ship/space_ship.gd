extends CharacterBody2D

const ROCKET_SCENE = preload("res://scenes/minigames/minigame_03/elements/rocket/rocket.tscn")

const MAX_SPEED = 300.0
const ACCELERATION = 0.5

@onready var shoot_sound = $ShootSound
@onready var damage_sound = $DamageSound

func _physics_process(delta: float):
	if Input.is_action_just_pressed("ui_accept"):
		shot()
		
	var direction = Input.get_axis("left", "right")
	
	# Si hay dirección, acelera progresivamente; si no, desacelera suavemente
	if direction != 0:
		velocity.x = lerp(velocity.x, direction * MAX_SPEED, ACCELERATION)
	else:
		velocity.x = lerp(velocity.x, 0.0, ACCELERATION)
		
	move_and_slide()

func shot():
	var rocket = ROCKET_SCENE.instantiate()
	rocket.global_position = global_position + Vector2(0, -30)
	get_tree().current_scene.add_child(rocket)
	
	# Reproducir sonido de disparo
	if shoot_sound:
		shoot_sound.play()

func take_damage():
	Globals.change_lives(-1)
	
	# 1. EFECTO AUDITIVO: Reproducir sonido de daño
	if damage_sound:
		damage_sound.play()
		
	# 2. EFECTO VISUAL: Tinte rojo temporal usando un Tween
	var tween = create_tween()
	# Cambia la modulación de color a Rojo puro de forma instantánea
	$Sprite2D.modulate = Color(1, 0, 0, 1)
	# Hace que regrese a su color blanco/normal (Color(1,1,1,1)) en 0.2 segundos
	tween.tween_property($Sprite2D, "modulate", Color(1, 1, 1, 1), 0.2)
	
	# 3. EFECTO MECÁNICO: Llamamos al temblor de pantalla (Screen Shake)
	# Buscamos la cámara en la escena principal y activamos el temblor
	var camera = get_tree().current_scene.get_node_or_null("Camera2D")
	if camera and camera.has_method("shake"):
		camera.shake(0.2, 5) # Duración: 0.3s, Intensidad: 10 píxeles1)
