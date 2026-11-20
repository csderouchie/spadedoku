extends Control
@onready var level: Label = $HBoxContainer/VBoxContainer2/Level
@onready var timer_label: Label = $HBoxContainer/VBoxContainer3/Timer
@onready var timer: Timer = $Timer

signal restart
func _on_restart_pressed() -> void:
	restart.emit()

signal menu
func _on_menu_pressed() -> void:
	menu.emit()

func set_level_label(level_num : int):
	level.text = "Level " + str(level_num)

var timer_minutes := 0
var timer_seconds := 0
func _on_timer_timeout() -> void:
	timer_seconds += 1
	if timer_seconds >= 60:
		timer_seconds = timer_seconds - 60
		timer_minutes += 1
	timer_label.text = format_timer(timer_minutes, timer_seconds)
		
func format_timer(minutes : int, seconds : int) -> String:
	if seconds > 9:
		return str(minutes) + ":" + str(seconds)
	else:
		return str(minutes) + ":0" + str(seconds)
	
func start_timer():
	timer.start()

func stop_timer():
	timer.stop()
	
func reset_timers():
	timer_seconds = 0
	timer_minutes = 0
	timer_label.text = format_timer(timer_minutes, timer_seconds)
	
func hide_timer():
	timer_label.visible = false
	
func show_timer():
	timer_label.visible = true
