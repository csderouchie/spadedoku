extends Control
@onready var level_label: Label = $ColorRect/VBoxContainer/HBoxContainer2/Level
@onready var time_label: Label = $ColorRect/VBoxContainer/HBoxContainer3/Time

func set_labels(level : int, time : String):
	level_label.text = "Completed level " + str(level)
	time_label.text = "Time " + time

signal menu
func _on_menu_pressed() -> void:
	menu.emit()

signal select_level
func _on_select_level_pressed() -> void:
	select_level.emit()

signal next_level
func _on_next_level_pressed() -> void:
	next_level.emit()
