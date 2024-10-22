extends Control


# func _on_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
# 	# Open the game
# 	# var game = game_list[index]
# 	# launch_game(game)
# 	return

func _on_item_list_item_selected(id: int) -> void:
	# Load hero on background
	var game = GameList.GAME_LIST[id]
	$Background/BackgroundHero2.texture = game.hero
	$Background/BackgroundAnimation.play("fade_out")


func _on_background_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		$Background/BackgroundHero.texture = $Background/BackgroundHero2.texture
		$Background/BackgroundHero.modulate = Color(1, 1, 1, 1)

func _on_banner_menu_game_selected(id: int) -> void:
	var game = GameList.GAME_LIST[id]
	
	if $Background/BackgroundAnimation.is_playing():
		$Background/BackgroundAnimation.play("fade_out_2")
		
	$Background/BackgroundHero2.texture = game.hero
	$Background/BackgroundAnimation.play("fade_out")
	$MainVbox/DrawerMenu.select_game(id)

func _on_background_animation_2_animation_finished(anim_name: StringName) -> void:
	if(anim_name == "fade_out_2"):
		$Background/BackgroundHero2.modulate = Color(1, 1, 1, 1)
