extends HBoxContainer

signal game_selected(id: String)
signal banner_menu_loaded

func get_banner_by_id(id: String) -> VBoxContainer:
	for child in get_children():
		if child.name == id:
			return child
	return null

func _on_banner_focused(id: String) -> void:
	emit_signal("game_selected", id)
	var banner = get_banner_by_id(id)

	# Always center the banner focused
	if $"../".get_child(1).is_playing():
		$"../".get_child(1).stop(true)
	var destination = $"../".get_h_scroll_bar().max_value/GameList.game_list.size() * banner.index - $"../".size.x/2 + (($"../".get_h_scroll_bar().max_value/GameList.game_list.size())/2)
	var animation = $"../".get_child(1).get_animation("scroll")
	animation.bezier_track_set_key_value(0, 0, $"../".get_h_scroll_bar().value)
	animation.bezier_track_set_key_value(0, 1, destination)
	$"../".get_child(1).play("scroll")
	print("Animation: ", $"../".get_h_scroll_bar().value, " -> ", destination)

func _on_main_game_list_loaded() -> void:
	# Clear the children
	for child in get_children():
		child.queue_free()

	# Add games as children
	var games = GameList.game_list
	var first_banner
	print("Games: ", games)
	var i = 0
	for game in games:
		var banner_scene = load("res://scenes/game_banner.tscn")
		var banner = banner_scene.instantiate()
		banner.set_banner_texture(game.banner)
		banner.set_banner_bottom_label(game.name)
		banner.index = i
		banner.set_id(game.id)
		banner.name = game.id
		add_child(banner)
		print("Added game banner: ", game.name)

		if i == 0:
			first_banner = banner
		elif i == GameList.game_list.size() - 1:
			first_banner.set_focus_neighbor_left(banner)
			banner.set_focus_neighbor_right(first_banner)

		i += 1

		# Set the size to develop
		banner.size_flags_horizontal = 3

		# Connect the signal
		banner.connect("banner_focused", _on_banner_focused)
		$"../../".connect("hide_banner_tags", banner.hide_tags)
		$"../../".connect("show_banner_tags", banner.show_tags)
	
	emit_signal("banner_menu_loaded")
	first_banner.set_focus()


func _ready() -> void:
	GameList.connect("game_list_loaded", _on_main_game_list_loaded)
