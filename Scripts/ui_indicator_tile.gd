extends Node2D
@onready var label: Label = $Label
@export var watched_tiles: Array[Vector2i]= []
@export var display_value := 0
@export var green = Color(0.0,1.0,0.0,1.0)
@export var red = Color(1.0,0.0,0.0,1.0)
signal new_21

func update_display():
	label.text = str(display_value)
	if display_value == 21:
		label.set("theme_override_colors/font_color",green)
		new_21.emit()
	else:
		label.set("theme_override_colors/font_color",red)
