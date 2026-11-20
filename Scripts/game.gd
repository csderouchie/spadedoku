extends Node2D
@onready var game_summary: Control = $Menus/GameSummary
@onready var main_menu: Control = $Menus/MainMenu
@onready var game_manager: Node2D = $GameManager
@onready var select_level: Control = $Menus/SelectLevel
@onready var hud: Control = $Menus/Hud
@onready var settings: Control = $Menus/Settings
var next_level := 0
var current_level = null

func _on_game_manager_game_won() -> void:
	game_summary.visible = true
	next_level += 1
	main_menu.set_level_label(next_level)
	game_summary.set_labels(current_level, hud.get_time())
	current_level = null
	hud.stop_timer()

func _on_main_menu_play_pressed() -> void:
	main_menu.visible = false
	if current_level == null:
		load_level(next_level)
	else:
		hud.start_timer()

func _on_main_menu_select_level_pressed() -> void:
	main_menu.visible = false
	select_level.visible = true
	select_level.set_buttons()
	
func _on_select_level_level_selected(num) -> void:
	select_level.visible = false
	load_level(num)

func load_level(num : int):
	current_level = num
	hud.reset_timers()
	game_manager.load_level(num)
	hud.start_timer()
	hud.set_level_label(num)

func _on_hud_restart() -> void:
	game_manager.load_level(current_level)
	
func _on_hud_menu() -> void:
	main_menu.visible = true
	hud.stop_timer()

func _on_main_menu_settings_pressed() -> void:
	settings.visible = true;

func _on_settings_settings_changed() -> void:
	process_settings(settings.get_settings())
	
func process_settings(settings_dict : Dictionary):
	if settings_dict["show_timer"] == false:
		hud.hide_timer()
	else:
		hud.show_timer()

func _on_select_level_menu() -> void:
	select_level.visible = false
	main_menu.visible = true

func _on_game_summary_menu() -> void:
	game_summary.visible = false
	main_menu.visible = true

func _on_game_summary_next_level() -> void:
	load_level(next_level)
	game_summary.visible = false

func _on_game_summary_select_level() -> void:
	game_summary.visible = false
	select_level.visible = true
