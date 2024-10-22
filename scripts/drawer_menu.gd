extends HBoxContainer

func _on_category_list_focus_entered() -> void:
	$AnimationPlayer.play("open_category")

func select_game(id: int):
	pass

func _on_category_list_focus_exited() -> void:
	$AnimationPlayer.play("close_category")

func _on_main_game_list_loaded() -> void:
	$ItemList.clear()
	for game in GameList.GAME_LIST:
		$ItemList.add_item(game.name, game.icon)
	$CategoryBar/CategoryList.select(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	GameList.connect("GAME_LIST_LOADED", _on_main_game_list_loaded)
