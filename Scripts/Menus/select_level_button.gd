extends Button

var num : int
signal level_selected

func _ready() -> void:
	pressed.connect(emit_num)

func emit_num():
	level_selected.emit(num)

func set_button_text():
	self.text = str(num)
