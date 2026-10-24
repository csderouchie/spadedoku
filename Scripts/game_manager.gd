extends Node2D
@onready var card_layer: TileMapLayer = $CardLayer
@onready var highlight: TileMapLayer = $Highlight
@onready var background: TileMapLayer = $Background
@onready var selection: Vector2i = Vector2i(0, 0)
var hand_coords = _get_hand_coords()
var board_coords : Array

func _ready():
	board_coords = _get_board_coords()
	print(get_level_data(0))

func _input(event: InputEvent) -> void:
	var tile_pos = card_layer.local_to_map(get_global_mouse_position())
	if event.is_action_pressed("Select"):
		process_select(tile_pos)
		
func process_select(tile_pos : Vector2i): # Card selection and movement logic
	highlight.clear()
	if tile_pos in hand_coords or tile_pos in board_coords:
		if selection != Vector2i(0,0) and card_layer.get_cell_source_id(tile_pos) == -1:
			var alt_tile : int
			var selected_tile = card_layer.get_cell_source_id(selection)
			if selected_tile == 2: # Work around alt tile bug
				alt_tile = 2
			else:
				alt_tile = 1
				# Move selected tile
			card_layer.erase_cell(selection)
			card_layer.set_cell(tile_pos, selected_tile, Vector2i.ZERO, alt_tile)
			selection = Vector2i(0,0)
		else:
			selection = tile_pos
			highlight.set_cell(selection, 0, Vector2i.ZERO, 1)
	else:
		selection = Vector2i(0,0)

func get_level_data(level_num : int):
	return Level.levels[str(level_num)]

# Active game tiles array builders
func _get_hand_coords() -> Array:
	var coords = []
	for y in range(2, 4):
		for x in range(-2, 3):
			coords.append(Vector2i(x, y))
	return coords

func _get_board_coords() -> Array:
	var coords = []
	for x in range(-2, 3):
		for y in range(-4, 2):
			if background.get_cell_source_id(Vector2i(x, y)) == 1:
				coords.append(Vector2i(x, y))
	return coords
