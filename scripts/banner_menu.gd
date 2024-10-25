##############################################################
#                     	Banner Menu	                         #
#          This file contains the banner menu script         #
##############################################################

extends HBoxContainer

func fix_banner_index():
	for i in range(get_child_count()):
		var node = get_child(i)
		node.index = i
		i += 1

# Get the next game, circular
func get_game_id_circular(from_id: int, direction: int) -> int:
	return int(fposmod(from_id + direction, GameList.GAME_LIST.size()))

# Move the banner to the first position
func center_banner(banner: Node) -> void:

	# Stop the current animation
	if $"../".get_child(1).is_playing():
		$"../".get_child(1).stop(true)
	
	# Get the positions
	var from = $"../".get_h_scroll_bar().value
	var destination = $"../".get_h_scroll_bar().max_value/GameList.GAME_LIST.size() * banner.index - $"../".size.x/2 + (($"../".get_h_scroll_bar().max_value/GameList.GAME_LIST.size())/2)

	# Set the animation keys
	var animation = $"../".get_child(1).get_animation("scroll")
	animation.bezier_track_set_key_value(0, 0, from)
	animation.bezier_track_set_key_value(0, 1, destination)
	
	# Play the animation
	$"../".get_child(1).play("scroll")

# When a banner is selected
func _on_banner_selection(index: int):

	var banner = get_child(index)
	var direction = index - GameList.GAME_LIST.size() / 2.0
	var direction_int = int(direction)
	if (direction_int == 0):
		direction_int = 1

	# Each banner has an index, which is the position of the banner in the container
	if(direction < 0):
		for i in range(abs(direction_int)):
			move_banner_last_to_first()
			$"../".get_h_scroll_bar().value += + 2 * $"../".get_h_scroll_bar().max_value/GameList.GAME_LIST.size()
	elif(direction > 0):
		for i in range(abs(direction_int)):
			move_banner_first_to_last()
			$"../".get_h_scroll_bar().value += - 5 * $"../".get_h_scroll_bar().max_value/GameList.GAME_LIST.size()

	# Emit game selected
	BusEvent.emit_signal("BANNER_MENU_FOCUSED")
	BusEvent.emit_signal("GAME_SELECTED", banner.game_id)
	BusEvent.emit_signal("CENTER_MENU_BANNER", banner)


# Add a banner to the container, last position
func add_banner(game: GameList.Game) -> void:
	var banner_scene = load("res://scenes/game_banner.tscn")
	var banner = banner_scene.instantiate()
	
	# Set the banner node properties
	banner.set_banner_texture(game.banner)
	banner.set_banner_bottom_label(game.name)
	banner.set_game_id(game.id)
	banner.index = -1
	
	banner.size_flags_horizontal = 3 # Set the size to develop

	# Add the banner to the container
	add_child(banner)


func move_banner_last_to_first() -> void:
	var last_banner = get_child(get_child_count() - 1)
	move_child(last_banner, 0)
	fix_banner_index()

func move_banner_first_to_last() -> void:
	var first_banner = get_child(0)
	move_child(first_banner, get_child_count() - 1)
	fix_banner_index()

func reload_banners() -> void:

	# Remove all children
	for child in get_children():
		remove_child(child)
		child.propagate_call("queue_free", [])
	
	for game in GameList.GAME_LIST:
		add_banner(game)
	fix_banner_index()

	BusEvent.emit_signal("BANNER_MENU_RELOADED")

# When the game list is loaded
func _on_main_game_list_loaded() -> void:
	reload_banners()

func _ready() -> void:
	BusEvent.connect("GAME_LIST_LOADED", _on_main_game_list_loaded)
	BusEvent.connect("BANNER_SELECTED", _on_banner_selection)
	BusEvent.connect("CENTER_MENU_BANNER", center_banner)


func _on_auto_scroll_timeout() -> void:
	## press right
	#var a = InputEventKey.new()
	#a.keycode = KEY_RIGHT
	#a.pressed = true
	#Input.parse_input_event(a)
	pass
