extends Node2D

@export var numero_escena: PackedScene = preload("res://numero.tscn")

@onready var label_operacion: Label = $UI/PanelSuperior/LabelOperacion
@onready var label_meta_valor: Label = $UI/PanelSuperior/LabelMetaValor
@onready var label_suma_valor: Label = $UI/PanelSuperior/LabelSumaValor
@onready var label_estado_suma: Label = $UI/PanelSuperior/LabelEstadoSuma
@onready var label_tiempo: Label = $UI/PanelSuperior/LabelTiempo
@onready var barra_tiempo: ProgressBar = $UI/PanelSuperior/BarraTiempo
@onready var label_vidas: Label = $UI/PanelSuperior/LabelVidas
@onready var boton_pausa: Button = $UI/PanelSuperior/BotonPausa
@onready var label_instruccion: Label = $UI/LabelInstruccion
@onready var label_mensaje: Label = $UI/LabelMensaje
@onready var panel_pausa: Control = $UI/PanelPausa

var objetivo = 0
var suma_actual = 0
var numero_a = 0
var numero_b = 0

var vidas = 3
var tiempo_maximo = 15.0
var tiempo_actual = 0.0
var juego_pausado = false

func _ready():
	boton_pausa.process_mode = Node.PROCESS_MODE_ALWAYS
	panel_pausa.process_mode = Node.PROCESS_MODE_ALWAYS
	panel_pausa.visible = false
	boton_pausa.pressed.connect(_on_boton_pausa_pressed)

	if has_node("Player_m1"):
		$Player_m1.area_entered.connect(_on_player_toca_algo)
	else:
		push_error("No se encontro el nodo 'Player_m1' en la escena Mundo.")

	label_mensaje.text = "Preparate"
	await get_tree().create_timer(2.0).timeout
	if label_mensaje.text == "Preparate":
		label_mensaje.text = ""

	iniciar_nuevo_nivel()

func iniciar_nuevo_nivel():
	numero_a = randi_range(5, 20)
	numero_b = randi_range(5, 20)
	objetivo = numero_a + numero_b
	suma_actual = 0
	tiempo_actual = tiempo_maximo
	barra_tiempo.max_value = tiempo_maximo
	barra_tiempo.value = tiempo_actual
	label_tiempo.text = "Tiempo: " + str(ceili(tiempo_actual)) + "s"
	actualizar_textos()

func actualizar_textos():
	var faltante = objetivo - suma_actual

	label_operacion.text = str(numero_a) + " + " + str(numero_b)
	label_meta_valor.text = str(objetivo)
	label_suma_valor.text = str(suma_actual)

	if suma_actual == 0:
		label_estado_suma.text = "Todavia no recoges numeros"
	elif faltante > 0:
		label_estado_suma.text = "Te faltan " + str(faltante) + " puntos"
	elif faltante == 0:
		label_estado_suma.text = "Exacto. Ya llegaste al resultado"
	else:
		label_estado_suma.text = "Te pasaste por " + str(abs(faltante))

	label_instruccion.text = "Cae sobre numeros hasta llegar exactamente al resultado."
	label_vidas.text = "Vidas: " + str(vidas)

func _process(delta):
	if juego_pausado:
		return

	if tiempo_actual > 0.0:
		tiempo_actual -= delta
		barra_tiempo.value = max(tiempo_actual, 0.0)
		label_tiempo.text = "Tiempo: " + str(ceili(max(tiempo_actual, 0.0))) + "s"

		if tiempo_actual <= 0.0:
			mostrar_mensaje("Se acabo el tiempo")
			perder_vida()

func mostrar_mensaje(texto: String):
	label_mensaje.text = texto
	await get_tree().create_timer(2.0).timeout
	if label_mensaje.text == texto:
		label_mensaje.text = ""

func perder_vida():
	vidas -= 1
	if vidas > 0:
		mostrar_mensaje("Perdiste una vida. Te quedan: " + str(vidas))
		iniciar_nuevo_nivel()
	else:
		mostrar_mensaje("Juego terminado. Reiniciando...")
		vidas = 3
		get_tree().paused = false
		juego_pausado = false
		get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_generador_timer_timeout():
	if juego_pausado:
		return

	var nuevo_numero = numero_escena.instantiate()
	var posicion_x_aleatoria = randf_range(50, 1100)
	nuevo_numero.position = Vector2(posicion_x_aleatoria, -50)
	add_child(nuevo_numero)

func _on_player_toca_algo(area_que_choco):
	if juego_pausado:
		return

	if area_que_choco.is_in_group("numeros"):
		suma_actual += area_que_choco.valor
		area_que_choco.queue_free()
		actualizar_textos()
		verificar_resultado()

func verificar_resultado():
	if suma_actual == objetivo:
		mostrar_mensaje("Exacto. Nivel superado.")
		iniciar_nuevo_nivel()
	elif suma_actual > objetivo:
		mostrar_mensaje("Te pasaste de la suma")
		perder_vida()

func _on_boton_pausa_pressed():
	juego_pausado = not juego_pausado
	get_tree().paused = juego_pausado
	panel_pausa.visible = juego_pausado
	boton_pausa.text = "Reanudar" if juego_pausado else "Pausa"

	if juego_pausado:
		label_mensaje.text = "Juego en pausa"
	else:
		label_mensaje.text = ""
