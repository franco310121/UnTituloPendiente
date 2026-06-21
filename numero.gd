extends Area2D

var valor = 0
var velocidad_caida = 150.0 # Ajusta esto para que caigan más rápido o más lento

func _ready():
	# Cuando el número aparece, le asignamos un valor aleatorio entre 1 y 9
	valor = randi_range(1, 9)
	# Mostramos ese valor en el Label que le pusimos como hijo
	$Label.text = str(valor)

func _process(delta):
	# En cada frame, movemos el número hacia abajo (eje Y positivo)
	position.y += velocidad_caida * delta
	
	# Si el número se sale de la pantalla por la parte de abajo, lo borramos
	# Asumiendo una pantalla de 720p (altura 720). Ajusta este valor si tu pantalla es diferente.
	if position.y > 800:
		queue_free() # Esta función elimina el nodo de la memoria de forma segura
