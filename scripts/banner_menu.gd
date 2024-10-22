extends HBoxContainer

signal game_selected(id: int)
signal banner_menu_loaded

func get_banner_by_id(id: int) -> VBoxContainer:
	for child in get_children():
		if child.name.to_int() == id:
			return child
	return null

func _on_banner_focused(id: int) -> void:
	emit_signal("game_selected", id)
	var banner = get_banner_by_id(id)

	# Always center the banner focused
	if $"../".get_child(1).is_playing():
		$"../".get_child(1).stop(true)
	var destination = $"../".get_h_scroll_bar().max_value/GameList.GAME_LIST.size() * banner.id - $"../".size.x/2 + (($"../".get_h_scroll_bar().max_value/GameList.GAME_LIST.size())/2)
	var animation = $"../".get_child(1).get_animation("scroll")
	animation.bezier_track_set_key_value(0, 0, $"../".get_h_scroll_bar().value)
	animation.bezier_track_set_key_value(0, 1, destination)
	$"../".get_child(1).play("scroll")

func _on_main_game_list_loaded() -> void:
	# Clear the children
	for child in get_children():
		child.queue_free()

	# Add games as children
	var games = GameList.GAME_LIST
	var first_banner
	for game in games:
		var banner_scene = load("res://scenes/game_banner.tscn")
		var banner = banner_scene.instantiate()
		banner.set_banner_texture(game.banner)
		banner.set_banner_bottom_label(game.name)
		banner.set_id(game.id)
		banner.name = str(game.id)
		add_child(banner)
		print("Added game banner: ", game.name)

		# Set the size to develop
		banner.size_flags_horizontal = 3

		# Connect the signal
		banner.connect("banner_focused", _on_banner_focused)
		$"../../".connect("hide_banner_tags", banner.hide_tags)
		$"../../".connect("show_banner_tags", banner.show_tags)
	
	emit_signal("banner_menu_loaded")


func _ready() -> void:
	GameList.connect("GAME_LIST_LOADED", _on_main_game_list_loaded)
