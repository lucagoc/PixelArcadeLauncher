extends HBoxContainer

signal game_selected(id: String)
signal banner_menu_loaded
signal other_banner_focused(index: int)

var nb_displayed_banners = 5

func get_banner_by_id(id: String) -> VBoxContainer:
	for child in get_children():
		if child.name == id:
			return child
	return null

func _on_banner_focused(id: String) -> void:
	emit_signal("game_selected", id)
	var banner = get_banner_by_id(id)
	emit_signal("other_banner_focused", banner.index)

func _on_main_game_list_loaded() -> void:
	# Clear the children
	for child in get_children():
		child.queue_free()

	# Add games as children
	var games = GameList.game_list
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

		i += 1

		# Set the size to develop
		banner.size_flags_horizontal = 3

		# Connect the signal
		banner.connect("banner_focused", _on_banner_focused)
		self.connect("other_banner_focused", banner._on_banner_focused)
	
	emit_signal("banner_menu_loaded")


func _ready() -> void:
	GameList.connect("game_list_loaded", _on_main_game_list_loaded)
