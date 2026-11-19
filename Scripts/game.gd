extends Node2D
@onready var game_summary: Control = $Menus/GameSummary
@onready var main_menu: Control = $Menus/MainMenu
@onready var game_manager: Node2D = $GameManager
@onready var select_level: Control = $Menus/SelectLevel
var next_level := 0

func _on_game_manager_game_won() -> void:
	main_menu.visible = true
	next_level += 1
	main_menu.set_level_label(next_level)

func _on_main_menu_play_pressed() -> void:
	main_menu.visible = false
	game_manager.load_level(next_level)

func _on_main_menu_select_level_pressed() -> void:
	main_menu.visible = false
	select_level.visible = true
	select_level.set_buttons()
	
func _on_select_level_level_selected(num) -> void:
	select_level.visible = false
	game_manager.load_level(num)
