extends Resource
class_name ItemData

## Nombre del ítem que aparecerá en la interfaz
@export var name: String = "Nuevo Ítem"

## Icono que se mostrará en el inventario o la tienda
@export var icon: Texture2D

## Descripción breve para la interfaz
@export_multiline var description: String = ""

## Precio para la lógica de compra/venta
@export var price: int = 0

## Stats que afectan al personaje
@export var energy_value: int = 0      # Cuánta energía restaura
@export var stress_reduction: int = 0  # Cuánto estrés reduce
