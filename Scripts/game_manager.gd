extends Node2D
@onready var card_layer: TileMapLayer = $CardLayer
@onready var highlight: TileMapLayer = $Highlight
@onready var background: TileMapLayer = $Background
@onready var selection: Vector2i = Vector2i(-10, -10)
var hand_coords = _get_hand_coords()
var base_board_coords : Array
var board_coords : Array

func _ready():
	base_board_coords = _get_board_coords()
	board_coords = base_board_coords
	load_level(0)

func _input(event: InputEvent) -> void:
	var tile_pos = card_layer.local_to_map(get_global_mouse_position())
	if event.is_action_pressed("Select"):
		process_select(tile_pos)
		
func process_select(tile_pos : Vector2i): # Card selection and movement logic
	highlight.clear()
	if tile_pos in hand_coords or tile_pos in board_coords:
		if selection != Vector2i(-10,-10) and card_layer.get_cell_source_id(tile_pos) == -1:
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

func load_level(level_num : int):
	var level = get_level_data(level_num)
	board_coords = []
	for i in len(base_board_coords): # Load board
		if level["board_tiles"][i] == 1:
			background.set_cell(base_board_coords[i], 1, Vector2i.ZERO, 1)
			board_coords.append(base_board_coords[i])
		else:
			background.set_cell(base_board_coords[i], 0, Vector2i.ZERO, 1)
	var alt_tile : int
	for i in range(len(level["hand"])): # Load hand
		if level["hand"][i] == 2: # alt tile bug
			alt_tile = 2
		else:
			alt_tile = 1
		card_layer.set_cell(hand_coords[i], level["hand"][i], Vector2i.ZERO, alt_tile)
	for i in range(len(level["board_cards"])): # Load board cards
		var board_card = level["board_cards"][i]
		var coords := Vector2i(board_card["x"], board_card["y"])
		card_layer.set_cell(coords, board_card["card"], Vector2i.ZERO, 1)
		

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
		for y in range(-4, 1):
			if background.get_cell_source_id(Vector2i(x, y)) == 2:
				coords.append(Vector2i(x, y))
	return coords
