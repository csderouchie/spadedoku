extends Node

var levels = {}
var levels_file_path = "res://Data/levels.json"

func _ready() -> void:
	levels = load_json_file(levels_file_path)

func load_json_file(filePath : String):
	if FileAccess.file_exists(filePath):
		var dataFile = FileAccess.open(filePath, FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		if parsedResult is Dictionary:
			return parsedResult
		else:
			print("ERROR: parsed data not dictionary")
	else:
		print("ERROR: level file not found")
