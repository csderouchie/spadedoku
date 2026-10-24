@abstract
class_name Card extends Node
@onready var label = $Label
@export var value : int

func set_display(value_str : String):
	label.text = value_str
