extends HBoxContainer

signal game_selected(id: String)

func _on_banner_focused(id: String) -> void:
	emit_signal("game_selected", id)

func _on_main_game_list_loaded() -> void:
	# Clear the children
	for child in get_children():
		child.queue_free()

	# Add games as children
	var games = GameList.game_list
	print("Games: ", games)
	for game in games:
		var banner_scene = load("res://scenes/game_banner.tscn")
		var banner = banner_scene.instantiate()
		banner.set_banner_texture(game.banner)
		banner.set_banner_bottom_label(game.name)
		banner.set_id(game.id)
		add_child(banner)
		print("Added game banner: ", game.name)
		
		# Set min x size (dirty)
		banner.custom_minimum_size.x = 100

		# Set the size to develop
		banner.size_flags_horizontal = 3
		#banner.size_flags_vertical = 3

		# Connect the signal
		banner.connect("banner_focused", _on_banner_focused)



func _ready() -> void:
	GameList.connect("game_list_loaded", _on_main_game_list_loaded)
