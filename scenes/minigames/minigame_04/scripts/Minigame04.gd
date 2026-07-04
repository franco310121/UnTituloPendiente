extends Node2D

var piezas_texturas = [
	"res://scenes/minigames/minigame_04/assets/procesador-removebg-preview.png",
	"res://scenes/minigames/minigame_04/assets/grafica-removebg-preview.png",
	"res://scenes/minigames/minigame_04/assets/ram-removebg-preview.png",
	"res://scenes/minigames/minigame_04/assets/ssd-removebg-preview.png",
	"res://scenes/minigames/minigame_04/assets/cooling-removebg-preview.png",
	"res://scenes/minigames/minigame_04/assets/fuente-removebg-preview.png"
]

var pc_sprites = ["procesador", "grafica", "ram", "ssd", "cooling", "fuente"]
var indice = 0

func _ready():
	$MensajeLabel.visible = false # Ocultar mensaje al inicio
	cambiar_sprite_pc("normal")
	actualizar_pieza_actual()

func actualizar_pieza_actual():
	if indice < piezas_texturas.size():
		var pieza_node = $CharacterBody2D
		pieza_node.get_node("Sprite2D").texture = load(piezas_texturas[indice])
		pieza_node.esta_en_posicion = false
		pieza_node.global_position = Vector2(0, -50) 
		pieza_node.set_physics_process(true)
		pieza_node.get_node("CollisionShape2D").disabled = false
	else:
		finalizar_juego()

func cambiar_sprite_pc(estado: String):
	var texture_rect = $TextureRect
	var ruta_base = "res://scenes/minigames/minigame_04/assets/"
	
	match estado:
		"llamas": texture_rect.texture = load(ruta_base + "pc_fail-removebg-preview.png")
		"armada": texture_rect.texture = load(ruta_base + "pc_on-removebg-preview.png")
		"normal": texture_rect.texture = preload("res://scenes/minigames/minigame_04/assets/pc-removebg-preview.png")
		_: texture_rect.texture = load(ruta_base + "pc_con_" + estado + "-removebg-preview.png")

func _on_pieza_encajada():
	cambiar_sprite_pc(pc_sprites[indice])
	indice += 1
	actualizar_pieza_actual()

func trigger_game_over():
	cambiar_sprite_pc("llamas")
	$MensajeLabel.text = "¡PC EN LLAMAS! PERDISTE"
	$MensajeLabel.visible = true
	set_physics_process(false)
	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()

func finalizar_juego():
	cambiar_sprite_pc("armada")
	$MensajeLabel.text = "¡FELICITACIONES! PC ARMADA"
	$MensajeLabel.visible = true
	
	await get_tree().create_timer(1.5).timeout
	
	var coordenadas_salida = Vector2(15084.0, -4352.0)
	var ruta_main = preload("res://scenes/levels/main.tscn")
	GameManager.cambiar_escena_con_spawn(ruta_main, coordenadas_salida)
