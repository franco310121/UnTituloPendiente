extends Area2D

@export var speed = 400 # Velocidad del jugador (píxeles/segundo)
var screen_size # Tamaño de la ventana del juego

func _ready():
	screen_size = get_viewport_rect().size
	# Opcional: Colocar al jugador en el centro inferior al iniciar
	# position.x = screen_size.x / 2
	# position.y = screen_size.y - 50 # 50 píxeles por encima del borde inferior

func _process(delta):
	var velocity = Vector2.ZERO # Vector de movimiento
	
	# Solo comprobamos izquierda y derecha
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	
	# Normalizar velocidad y animar
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	
	# Restringimos el movimiento:
	# position.y se mantiene constante, clamp() evita que salga por los lados
	position.x = clamp(position.x, 0, screen_size.x)
	
	# Lógica de animación
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_h = velocity.x < 0
