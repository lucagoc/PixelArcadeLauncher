extends Control

func _on_game_selection(id: int) -> void:
	# Load hero on background
	var game = GameList.GAME_LIST[id]
	$BackgroundHero2.texture = game.hero
	$BackgroundAnimation.play("fade_out")

func _on_background_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		$BackgroundHero.texture = $BackgroundHero2.texture
		$BackgroundHero.modulate = Color(1, 1, 1, 1)

func _on_background_animation_2_animation_finished(anim_name: StringName) -> void:
	if(anim_name == "fade_out_2"):
		$BackgroundHero2.modulate = Color(1, 1, 1, 1)

func _on_banner_menu_game_selected(id: int) -> void:
	var game = GameList.GAME_LIST[id]
	
	if $BackgroundAnimation.is_playing():
		$BackgroundAnimation.play("fade_out_2")
		
	$BackgroundHero2.texture = game.hero
	$BackgroundAnimation.play("fade_out")

func _on_game_launched(id: int):
	$ColorAnimationPlayer.play("to_black")

func _ready() -> void:
	BusEvent.connect("GAME_SELECTED", _on_game_selection)
	BusEvent.connect("GAME_LAUNCHED", _on_game_launched)
