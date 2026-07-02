extends Area2D

var valor = 0
var velocidad_caida = 150.0

func _ready():
	valor = randi_range(1, 9)
	$Label.text = str(valor)

func _process(delta):
	position.y += velocidad_caida * delta

	if position.y > 800:
		queue_free()
