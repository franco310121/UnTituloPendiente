extends Node

@onready var label_codigo = $CanvasLayer/Panel/LabelCodigo
@onready var label_sugerencias = $CanvasLayer/Panel/LabelSugerencias
@onready var label_lenguaje = $CanvasLayer/Panel/LabelLenguaje
@onready var campo_respuesta = $CanvasLayer/Panel/CampoRespuesta

var niveles = [
	{
		"lenguaje": "Java",
		"codigo": "public class Main {\n    public static void main(String[] args) {\n        System.out.println(\"____\");\n    }\n}",
		"opciones": ["Hello World", "Hola Mundo", "Print"],
		"respuesta_correcta": "Hello World"
	},
	{
		"lenguaje": "Python",
		"codigo": "def saludar(nombre):\n    print(\"Hola \" + ____)",
		"opciones": ["nombre", "user", "saludo"],
		"respuesta_correcta": "nombre"
	},
	{
		"lenguaje": "SQL",
		"codigo": "SELECT * FROM usuarios WHERE id = ____;",
		"opciones": ["1", "id", "*"],
		"respuesta_correcta": "1"
	},
	{
		"lenguaje": "JavaScript",
		"codigo": "const suma = (a, b) => { \n    return a ____ b; \n}",
		"opciones": ["+", "-", "*"],
		"respuesta_correcta": "+"
	}
]

var nivel_actual_index = 0
var esperando_feedback = false

func _ready():
	campo_respuesta.text_submitted.connect(_on_campo_respuesta_submitted)
	cargar_nivel()

func cargar_nivel():
	if nivel_actual_index < niveles.size():
		var nivel = niveles[nivel_actual_index]
		
		# Actualizamos solo los textos
		label_lenguaje.text = nivel["lenguaje"] 
		label_codigo.text = nivel["codigo"]
		label_sugerencias.text = "Opciones: " + ", ".join(nivel["opciones"])
		
		# Limpiamos el texto pero mantenemos la integridad del campo
		campo_respuesta.text = ""
		
		# Forzamos el foco de manera diferida para que el motor termine de actualizar la UI primero
		campo_respuesta.call_deferred("grab_focus")
	else:
		label_codigo.text = "¡Has dominado todos los lenguajes!"
		campo_respuesta.visible = false
		label_sugerencias.visible = false
		
		await get_tree().create_timer(1.5).timeout
		
		var coordenadas_salida = Vector2(15497, -4461) # Cambia esto por las coordenadas exactas
		
		# Usamos el GameManager para cambiar de escena con la posición guardada
		var ruta_main = preload("res://scenes/levels/main.tscn")
		GameManager.cambiar_escena_con_spawn(ruta_main, coordenadas_salida)

func _on_campo_respuesta_submitted(texto_ingresado):
	if esperando_feedback: 
		return 
		
	esperando_feedback = true
	campo_respuesta.editable = false
	
	if texto_ingresado == niveles[nivel_actual_index]["respuesta_correcta"]:
		label_sugerencias.text = "¡Correcto!"
		label_sugerencias.modulate = Color.GREEN
		nivel_actual_index += 1
	else:
		label_sugerencias.text = "Incorrecto"
		label_sugerencias.modulate = Color.RED
	
	# Tiempo de espera para leer el resultado
	await get_tree().create_timer(1.5).timeout
	
	# Resetear feedback visual
	label_sugerencias.modulate = Color.WHITE
	esperando_feedback = false
	campo_respuesta.editable = true
	
	# Cargar siguiente nivel
	cargar_nivel()
