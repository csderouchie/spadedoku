extends Node2D
@onready var game_summary: Control = $Menus/GameSummary
@onready var main_menu: Control = $Menus/MainMenu
@onready var game_manager: Node2D = $GameManager
var next_level := 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_game_manager_game_won() -> void:
	main_menu.visible = true
	next_level += 1
	main_menu.set_level_label(next_level)


func _on_main_menu_play_pressed() -> void:
	main_menu.visible = false
	game_manager.load_level(next_level)
