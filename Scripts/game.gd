extends Node2D
@onready var game_summary: Control = $Menus/GameSummary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_game_manager_game_won() -> void:
	game_summary.visible = true
