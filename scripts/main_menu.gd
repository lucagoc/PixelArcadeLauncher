extends Control


# func _on_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
# 	# Open the game
# 	# var game = game_list[index]
# 	# launch_game(game)
# 	return

func _on_item_list_item_selected(index: int) -> void:
	# Load hero on background
	var game = GameList.game_list[index]
	$Background/BackgroundHero2.texture = game.hero
	$Background/BackgroundAnimation.play("fade_out")


func _on_category_list_focus_entered() -> void:
	$MainVbox/DrawerMenu/AnimationPlayer.play("open_category")


func _on_category_list_focus_exited() -> void:
	$MainVbox/DrawerMenu/AnimationPlayer.play("close_category")


func _on_background_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		$Background/BackgroundHero.texture = $Background/BackgroundHero2.texture
		$Background/BackgroundHero.modulate = Color(1, 1, 1, 1)

func _on_banner_menu_game_selected(id: String) -> void:
	print("Game selected: ", id)
	var game = GameList.find_game(id)
	$Background/BackgroundHero2.texture = game.hero
	$Background/BackgroundAnimation.play("fade_out")
