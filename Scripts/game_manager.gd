extends Node2D
@onready var card_layer: TileMapLayer = $CardLayer
@onready var highlight: TileMapLayer = $Highlight
@onready var background: TileMapLayer = $Background
@onready var indicator_layer: TileMapLayer = $Indicator
@onready var selection: Vector2i = Vector2i(-10, -10)
var hand_coords = _get_hand_coords()
var base_board_coords : Array
var board_coords : Array
var board_card_coords = []
signal game_won

func _ready():
	base_board_coords = _get_board_coords()

func _input(event: InputEvent) -> void:
	var tile_pos = card_layer.local_to_map(get_global_mouse_position())
	if event.is_action_pressed("Select"):
		process_select_click(tile_pos)
	elif event.is_action_released("Select"):
		process_select_release(tile_pos)
		
func process_select_click(tile_pos : Vector2i): # Card selection and movement logic
	#print(tile_pos) # debug 
	highlight.clear()
	if tile_pos in hand_coords or tile_pos in board_coords:
		if tile_pos not in board_card_coords:
			if selection != Vector2i(-10,-10) and card_layer.get_cell_source_id(tile_pos) == -1:
				place_card(tile_pos)
			elif card_layer.get_cell_source_id(tile_pos) != -1:
				selection = tile_pos
				highlight.set_cell(selection, 0, Vector2i.ZERO, 1)
		else:
			selection = Vector2i(-10,-10)
			highlight.set_cell(tile_pos, 1, Vector2i.ZERO, 1)
			await get_tree().create_timer(0.25).timeout
			highlight.erase_cell(tile_pos)
	else:
		selection = Vector2i(-10,-10)

func process_select_release(tile_pos):
	if tile_pos in hand_coords or tile_pos in board_coords and tile_pos != selection:
		if selection != Vector2i(-10,-10) and card_layer.get_cell_source_id(tile_pos) == -1:
			place_card(tile_pos)
			highlight.clear()

func get_card_at(tile_pos : Vector2i): # Returns card node at passed position
	for node in card_layer.get_children():
		if tile_pos == card_layer.local_to_map(node.position):
			return node

func place_card(tile_pos : Vector2):
		var selected_tile = card_layer.get_cell_source_id(selection)
		var alt_tile = get_alt_tile(selected_tile)
		# Move selected tile
		card_layer.erase_cell(selection)
		card_layer.set_cell(tile_pos, selected_tile, Vector2i.ZERO, alt_tile)
		selection = Vector2i(-10,-10)
				
		#Maintain game state
		update_indicator_tiles()
		check_game_won()

func get_level_data(level_num : int):
	return Level.levels[str(level_num)]

func load_level(level_num : int): # Load full level from its number
	reset_board()
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
		alt_tile = get_alt_tile(level["hand"][i])
		card_layer.set_cell(hand_coords[i], level["hand"][i], Vector2i.ZERO, alt_tile)
	for i in range(len(level["board_cards"])): # Load board cards
		var board_card = level["board_cards"][i]
		var coords := Vector2i(board_card["x"], board_card["y"])
		board_card_coords.append(coords)
		alt_tile = get_alt_tile(board_card["card"])
		card_layer.set_cell(coords, board_card["card"], Vector2i.ZERO, alt_tile)
	card_layer.update_internals()
	set_gray_tiles()
	place_indicator_tiles()
	update_indicator_tiles()

func get_alt_tile(num : int) -> int: # Work around for alt tile bug
		if num == 2:
			return 2
		else:
			return 1

func set_gray_tiles():
	for i in range(len(board_card_coords)):
		background.set_cell(board_card_coords[i], 3, Vector2i.ZERO, 1)

func place_indicator_tiles():
	var prev_coords := Vector2i(-99, -99)
	var last_coord = board_coords[len(board_coords) - 1]
	for coord in board_coords:
		if prev_coords.x == -99:
			pass
		elif coord == last_coord:
			indicator_layer.set_cell(Vector2i(coord.x, coord.y + 1), 0, Vector2i.ZERO, 1)
		elif prev_coords.x != coord.x:
			indicator_layer.set_cell(Vector2i(prev_coords.x, prev_coords.y + 1), 0, Vector2i.ZERO, 1)
		if coord.x == last_coord.x:
			indicator_layer.set_cell(Vector2i(coord.x + 1, coord.y), 0, Vector2i.ZERO, 1)
		prev_coords = coord
	set_indicator_watched_tiles()

func set_indicator_watched_tiles():
	indicator_layer.update_internals()
	for indicator in indicator_layer.get_children():
		var indicator_pos = indicator_layer.local_to_map(indicator.global_position)
		for tile in board_coords:
			if tile.x == indicator_pos.x || tile.y == indicator_pos.y:
				indicator.watched_tiles.append(tile)

func update_indicator_tiles():
	await get_tree().create_timer(0.01).timeout
	for indicator in indicator_layer.get_children():
		indicator.display_value = sum_watched_tiles(indicator.watched_tiles)
		indicator.update_display()
	
func sum_watched_tiles(watched_tiles : Array) -> int:
	card_layer.update_internals()
	var sum := 0
	for tile in watched_tiles:
		var card = get_card_at(tile)
		if card != null:
			sum += card.value
	return sum

func check_game_won():
	await get_tree().create_timer(0.01).timeout
	for indicator in indicator_layer.get_children():
		if indicator.display_value == 21:
			continue
		else:
			return
	resolve_game_won()

func resolve_game_won():
	game_won.emit()

func reset_board():
	card_layer.clear()
	indicator_layer.clear()
	board_card_coords = []

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
		for y in range(-5, 0):
			coords.append(Vector2i(x, y))
	return coords
