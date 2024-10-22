##############################################################
#                     	Banner Menu	                         #
#          This file contains the banner menu script         #
##############################################################

extends HBoxContainer

# When a game is selected
func _on_game_selection(id: int) -> void:
	var banner = get_child(id)

	# Always center the banner focused
	if $"../".get_child(1).is_playing():
		$"../".get_child(1).stop(true)
	var destination = $"../".get_h_scroll_bar().max_value/GameList.GAME_LIST.size() * banner.id - $"../".size.x/2 + (($"../".get_h_scroll_bar().max_value/GameList.GAME_LIST.size())/2)
	var animation = $"../".get_child(1).get_animation("scroll")
	animation.bezier_track_set_key_value(0, 0, $"../".get_h_scroll_bar().value)
	animation.bezier_track_set_key_value(0, 1, destination)
	$"../".get_child(1).play("scroll")

# Add a banner to the container
func add_banner(game: GameList.Game) -> void:
	var banner_scene = load("res://scenes/game_banner.tscn")
	var banner = banner_scene.instantiate()
	
	# Set the banner node properties
	banner.set_banner_texture(game.banner)
	banner.size_flags_horizontal = 3 # Set the size to develop
	banner.set_banner_bottom_label(game.name)
	banner.set_id(game.id)
	banner.name = str(game.id)

	# Add the banner to the container
	add_child(banner)	

	# Connect the signal
	banner.connect("GAME_SELECTED", _on_game_selection)

func reload_banners() -> void:

	# Remove all children
	for child in get_children():
		child.queue_free()
	
	# Add all banners
	for game in GameList.GAME_LIST:
		add_banner(game)

	BusEvent.emit_signal("BANNER_MENU_RELOADED")

# When the game list is loaded
func _on_main_game_list_loaded() -> void:
	reload_banners()

func _ready() -> void:
	BusEvent.connect("GAME_LIST_LOADED", _on_main_game_list_loaded)
	BusEvent.connect("GAME_SELECTED", _on_game_selection)
