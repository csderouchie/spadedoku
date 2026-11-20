extends Control
@onready var level_text: Label = $"ColorRect/VBoxContainer/Play/Level text"

func set_level_label(level_num : int):
	level_text.text = "Level " + str(level_num)

signal play_pressed
func _on_play_pressed() -> void:
	play_pressed.emit()

signal select_level_pressed
func _on_select_level_pressed() -> void:
	select_level_pressed.emit()

signal settings_pressed
func _on_settings_pressed() -> void:
	settings_pressed.emit()
