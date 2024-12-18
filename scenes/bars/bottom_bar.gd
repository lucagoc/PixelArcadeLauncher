extends ColorRect

func _on_game_selected(index: int) -> void:
	$BottomHbox/GameTitle.text = GameList.GAME_LIST[index].name

func _on_drawer_focused():
	$BottomHbox/GameTitle.hide()
	$BottomHbox/HelperLeft/HelpLabel.text = "Bannière"
	$BottomHbox/HelperLeft/Arrow/TextureRect.flip_v = false

func _on_banner_focused():
	$BottomHbox/GameTitle.show()
	$BottomHbox/HelperLeft/HelpLabel.text = "Grille"
	$BottomHbox/HelperLeft/Arrow/TextureRect.flip_v = true

func _on_game_launched(id: int):
	$BottomHbox/HelperLeft.hide()
	$BottomHbox/GameTitle.hide()
	$BottomHbox/HelperRight.hide()

func _on_game_exited(id: int):
	$BottomHbox/HelperLeft.show()
	$BottomHbox/GameTitle.show()
	$BottomHbox/HelperRight.show()

func _ready() -> void:
	BusEvent.connect("GAME_SELECTED", _on_game_selected)
	BusEvent.connect("DRAWER_FOCUSED", _on_drawer_focused)
	BusEvent.connect("BANNER_MENU_FOCUSED", _on_banner_focused)
	BusEvent.connect("GAME_LAUNCHED", _on_game_launched)
	BusEvent.connect("GAME_EXITED", _on_game_exited)
