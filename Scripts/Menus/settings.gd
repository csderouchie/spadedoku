extends Control
@onready var hide_timer_button: Button = $"ColorRect/VBoxContainer/Hide timer"
signal settings_changed
var show_timer := true

func _on_back_pressed() -> void:
	self.visible = false

func _on_hide_timer_pressed() -> void:
	if show_timer:
		show_timer = false
		hide_timer_button.text = "Show timer"
	else:
		show_timer = true
		hide_timer_button.text = "Hide timer"
	settings_changed.emit()

func get_settings():
	var settings = {
		"show_timer": show_timer
	}
	return settings
