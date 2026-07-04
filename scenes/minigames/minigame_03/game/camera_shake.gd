extends Camera2D

var shake_duration := 0.0
var shake_intensity := 0.0
var original_offset := offset

func _process(delta: float):
	if shake_duration > 0:
		shake_duration -= delta
		# Elegimos posiciones aleatorias alrededor del centro original de la cámara
		offset.x = original_offset.x + randf_range(-shake_intensity, shake_intensity)
		offset.y = original_offset.y + randf_range(-shake_intensity, shake_intensity)
		
		# Si se acaba el tiempo, devolvemos la cámara a su lugar original
		if shake_duration <= 0:
			offset = original_offset
	else:
		offset = original_offset

# Esta es la función que manda a llamar la nave espacial al recibir daño
func shake(duration: float, intensity: float):
	shake_duration = duration
	shake_intensity = intensity
