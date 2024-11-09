extends ColorRect

func _on_game_selected(index: int) -> void:
	$BottomHbox/GameTitle.text = GameList.GAME_LIST[index].name

func _on_drawer_focused():
	$BottomHbox/GameTitle.hide()

func _on_banner_focused():
	$BottomHbox/GameTitle.show()

func _on_game_launched(id: int):
	$BottomHbox/Help1.hide()
	$BottomHbox/GameTitle.hide()
	$BottomHbox/Help2.hide()

func _ready() -> void:
	BusEvent.connect("GAME_SELECTED", _on_game_selected)
	BusEvent.connect("DRAWER_FOCUSED", _on_drawer_focused)
	BusEvent.connect("BANNER_MENU_FOCUSED", _on_banner_focused)
	BusEvent.connect("GAME_LAUNCHED", _on_game_launched)
