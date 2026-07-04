extends CharacterBody2D

const BULLET_SCENE = preload("res://scenes/minigames/minigame_03/elements/enemy_bullet/enemy_bullet.tscn")

@onready var raycast_left := $RayCastLeft
@onready var raycast_right := $RayCastRight
@onready var explosion_particles := $ExplosionParticles

func _physics_process(delta):
	# 1. DETECCIÓN DE IMPACTO CON EL JUGADOR
	# Revisamos los últimos colisionadores físicos del frame
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		# Si el enemigo choca contra la nave espacial...
		if collider and (collider.name == "SpaceShip" or collider.is_in_group("player")):
			# Forzamos que las vidas bajen a 0 inmediatamente a través del bus de eventos
			if Events.has_signal("lives_changed"):
				Events.lives_changed.emit(0)
			return

	# 2. FILTRO CLÁSICO PARA REBOTES EN MUROS
	if raycast_left.is_colliding():
		var collider = raycast_left.get_collider()
		if collider and ("Wall" in collider.name):
			get_tree().call_group("enemy_group", "change_direction")
			
	if raycast_right.is_colliding():
		var collider = raycast_right.get_collider()
		if collider and ("Wall" in collider.name):
			get_tree().call_group("enemy_group", "change_direction")

func destroy():
	Globals.change_points(1)
	Events.enemy_died.emit()
	
	explosion_particles.global_position = global_position
	
	if has_node("ExplosionSound") and $ExplosionSound:
		$ExplosionSound.play()
	
	set_physics_process(false)
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2D.visible = false
	
	explosion_particles.emitting = true
	
	await get_tree().create_timer(explosion_particles.lifetime).timeout
	queue_free()

func shot():
	var bullet = BULLET_SCENE.instantiate()
	bullet.global_position = global_position + Vector2(0, 10.0)
	get_tree().current_scene.add_child(bullet)
