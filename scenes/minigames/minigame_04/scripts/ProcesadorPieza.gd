extends CharacterBody2D

@export var velocidad_horizontal = 200
@export var velocidad_caida_constante = 150

var esta_en_posicion = false

func _physics_process(delta):
	if esta_en_posicion: return

	# Movimiento y Caída
	velocity.y = velocidad_caida_constante
	var direccion_x = 0
	if Input.is_action_pressed("right"): direccion_x += 1
	if Input.is_action_pressed("left"):  direccion_x -= 1
	velocity.x = direccion_x * velocidad_horizontal
	
	move_and_slide()
	
	# Verificaciones
	verificar_encaje()
	verificar_limite_pantalla()

func verificar_encaje():
	var areas = $AreaDetector.get_overlapping_areas()
	# Nombres de las áreas según el orden del array
	var nombres_areas = ["AreaProcesador", "AreaGrafica", "AreaRam", "AreaSsd", "AreaCooling", "AreaFuente"]
	var indice_actual = get_parent().indice
	
	for area in areas:
		if area.name == nombres_areas[indice_actual]:
			global_position = area.global_position
			esta_en_posicion = true
			set_physics_process(false)
			$CollisionShape2D.disabled = true
			# Avisar al nodo padre (Minigame04)
			get_parent()._on_pieza_encajada()
			return

func verificar_limite_pantalla():
	# Si llega al fondo (ej: 600px) y no está en posición, es derrota
	if global_position.y > 600 and not esta_en_posicion:
		get_parent().trigger_game_over()
