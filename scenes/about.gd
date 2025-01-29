extends HBoxContainer

var _is_focused = false
var _selected_game = 0

func get_game_id_circular(from_id: int, direction: int) -> int:
	return int(fposmod(from_id + direction, GameList.GAME_LIST.size()))

func _on_game_selection(id: int):
	_selected_game = id
	$"ColorRect/Padding/Main/Title".text  = GameList.GAME_LIST[id].name
	$"ColorRect/Padding/Main/GameInfo/Desc/DescBox/Desc".text = GameList.GAME_LIST[id].description

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BusEvent.connect("GAME_SELECTED", _on_game_selection)

	$"ColorRect/Padding".hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _is_focused:
		if Input.is_action_just_pressed("ui_right"):
			$ColorRect/Padding/Main/GameInfo/CoverBox/SubViewportContainer.rotate_right()
			BusEvent.emit_signal("GAME_SELECTED", get_game_id_circular(_selected_game, 1))
		elif Input.is_action_just_pressed("ui_left"):
			$ColorRect/Padding/Main/GameInfo/CoverBox/SubViewportContainer.rotate_left()
			BusEvent.emit_signal("GAME_SELECTED", get_game_id_circular(_selected_game, -1))

func _on_focus_entered() -> void:
	$"ColorRect/Padding".show()
	BusEvent.emit_signal("ABOUT_OPENED")
	_is_focused = true


func _on_focus_exited() -> void:
	$"ColorRect/Padding".hide()
	_is_focused = false
