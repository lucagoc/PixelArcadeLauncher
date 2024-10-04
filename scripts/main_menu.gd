extends Control


func _on_option_button_pressed() -> void:
	# Open debug_menu
	get_tree().change_scene_to_file("res://scenes/debug_menu.tscn")


# func _on_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
# 	# Open the game
# 	# var game = game_list[index]
# 	# launch_game(game)
# 	return


func _on_main_game_list_loaded() -> void:
	$MainVbox/DrawerMenu/ItemList.clear()
	for game in $"../".game_list:
		$MainVbox/DrawerMenu/ItemList.add_item(game.name, game.icon)
	$MainVbox/DrawerMenu/ItemList.grab_focus()
	$MainVbox/DrawerMenu/ItemList.select(0)
	$MainVbox/DrawerMenu/CategoryBar/CategoryList.select(0)

func _on_item_list_item_selected(index: int) -> void:
	# Load hero on background
	var game = $"../".game_list[index]
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
