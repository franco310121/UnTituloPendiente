extends Node2D

@export var numero_escena: PackedScene = preload("res://numero.tscn") 

var objetivo = 0
var suma_actual = 0
var numero_a = 0
var numero_b = 0

var vidas = 3
var tiempo_maximo = 15.0 # Segundos que tiene el jugador para resolver la suma
var tiempo_actual = 0.0

func _ready():
	# Conectamos la señal del jugador UNA SOLA VEZ al iniciar.
	if has_node("Player_m1"):
		$Player_m1.area_entered.connect(_on_player_toca_algo)
	else:
		push_error("Error: No se encontró el nodo 'Player' en la escena Mundo.")
	
	# Limpiamos el mensaje inicial en pantalla
	if has_node("UI/LabelMensaje"):
		$UI/LabelMensaje.text = "¡Preparate!"
		await get_tree().create_timer(2.0).timeout
		if has_node("UI/LabelMensaje"):
			$UI/LabelMensaje.text = ""
			
	iniciar_nuevo_nivel()

func iniciar_nuevo_nivel():
	# Genera dos números aleatorios para la operación
	numero_a = randi_range(5, 20)
	numero_b = randi_range(5, 20)
	
	# El objetivo es la suma de ambos
	objetivo = numero_a + numero_b
	suma_actual = 0
	
	# Reiniciamos el tiempo cada vez que hay un nuevo nivel
	tiempo_actual = tiempo_maximo
	
	# Configuramos el valor máximo de la barra (si existe)
	if has_node("UI/BarraTiempo"):
		$UI/BarraTiempo.max_value = tiempo_maximo
		
	actualizar_textos()

func actualizar_textos():
	# Actualiza los textos de la interfaz con el nuevo formato
	if has_node("UI/LabelObjetivo") and has_node("UI/LabelSuma"):
		$UI/LabelObjetivo.text = str(numero_a) + " + " + str(numero_b) + " = "
		
		if suma_actual == 0:
			$UI/LabelSuma.text = "?"
		else:
			$UI/LabelSuma.text = str(suma_actual)
			
	# Actualizamos el texto de las vidas
	if has_node("UI/LabelVidas"):
		$UI/LabelVidas.text = "Vidas: " + str(vidas)

# --- FUNCIÓN PARA EL TIEMPO ---
func _process(delta):
	# Restamos el tiempo cada frame si aún nos queda tiempo
	if tiempo_actual > 0:
		tiempo_actual -= delta
		
		# Actualizamos la barra visualmente
		if has_node("UI/BarraTiempo"):
			$UI/BarraTiempo.value = tiempo_actual
			
		# NUEVO: Actualizamos el tiempo en formato texto (Ej: "Tiempo: 12s")
		if has_node("UI/LabelTiempo"):
			$UI/LabelTiempo.text = "Tiempo: " + str(int(tiempo_actual)) + "s"
			
		# Si el tiempo llega a cero o menos, perdemos una vida
		if tiempo_actual <= 0:
			mostrar_mensaje("¡Se acabó el tiempo!")
			perder_vida()

# --- NUEVA FUNCIÓN PARA MOSTRAR MENSAJES EN PANTALLA ---
func mostrar_mensaje(texto: String):
	print(texto) # Lo mantenemos en consola por si acaso
	if has_node("UI/LabelMensaje"):
		$UI/LabelMensaje.text = texto
		
		# Esperamos 2 segundos
		await get_tree().create_timer(2.0).timeout
		
		# Borramos el mensaje (solo si no ha sido reemplazado por otro mientras esperábamos)
		if has_node("UI/LabelMensaje") and $UI/LabelMensaje.text == texto:
			$UI/LabelMensaje.text = ""

# --- FUNCIÓN PARA GESTIONAR LAS VIDAS ---
func perder_vida():
	vidas -= 1
	if vidas > 0:
		mostrar_mensaje("¡Perdiste una vida! Te quedan: " + str(vidas))
		iniciar_nuevo_nivel()
	else:
		mostrar_mensaje("¡JUEGO TERMINADO! Reiniciando...")
		vidas = 3
		## iniciar_nuevo_nivel()
		get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_generador_timer_timeout():
	# Instancia un nuevo número
	var nuevo_numero = numero_escena.instantiate()
	var posicion_x_aleatoria = randf_range(50, 1100) 
	nuevo_numero.position = Vector2(posicion_x_aleatoria, -50) 
	add_child(nuevo_numero)

func _on_player_toca_algo(area_que_choco):
	# Verificamos si el área que tocó el jugador pertenece al grupo "numeros"
	if area_que_choco.is_in_group("numeros"):
		suma_actual += area_que_choco.valor
		area_que_choco.queue_free()
		actualizar_textos()
		verificar_resultado()

func verificar_resultado():
	if suma_actual == objetivo:
		mostrar_mensaje("¡Exacto! Nivel superado.")
		iniciar_nuevo_nivel()
		
	elif suma_actual > objetivo:
		mostrar_mensaje("¡Te pasaste de la suma!")
		perder_vida()
