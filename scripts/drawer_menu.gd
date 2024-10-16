extends HBoxContainer

func _on_category_list_focus_entered() -> void:
	$AnimationPlayer.play("open_category")

func _on_category_list_focus_exited() -> void:
	$AnimationPlayer.play("close_category")

func _on_main_game_list_loaded() -> void:
	$ItemList.clear()
	for game in GameList.game_list:
		$ItemList.add_item(game.name, game.icon)
	$CategoryBar/CategoryList.select(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	GameList.connect("game_list_loaded", _on_main_game_list_loaded)
