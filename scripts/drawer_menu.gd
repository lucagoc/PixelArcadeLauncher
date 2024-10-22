extends HBoxContainer

func _on_category_list_focus_entered() -> void:
	$AnimationPlayer.play("open_category")
	BusEvent.emit_signal("DRAWER_FOCUSED")
	BusEvent.emit_signal("DRAWER_CATEGORY_OPENED")

func _on_category_list_focus_exited() -> void:
	$AnimationPlayer.play("close_category")
	emit_signal("DRAWER_CATEGORY_CLOSED")

func _on_game_list_loaded() -> void:
	$ItemList.clear()
	for game in GameList.GAME_LIST:
		$ItemList.add_item(game.name, game.icon)
	$CategoryBar/CategoryList.select(0) # Select the first category

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	BusEvent.connect("GAME_LIST_LOADED", _on_game_list_loaded)

func _on_item_list_focus_entered() -> void:
	BusEvent.emit_signal("DRAWER_FOCUSED")

func _on_item_list_item_selected(index: int) -> void:
	BusEvent.emit_signal("GAME_SELECTED", index)
