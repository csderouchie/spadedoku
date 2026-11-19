extends Control
@onready var level_text: Label = $"ColorRect/VBoxContainer/Play/Level text"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_level_label(level_num : int):
	level_text.text = "Level " + str(level_num)

signal play_pressed
func _on_play_pressed() -> void:
	play_pressed.emit()

signal select_level_pressed
func _on_select_level_pressed() -> void:
	select_level_pressed.emit()


func _on_settings_pressed() -> void:
	pass # Replace with function body.
