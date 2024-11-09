##############################################################
#                     	Banner Menu	                         #
#          This file contains the banner menu script         #
##############################################################

extends ScrollContainer

var selected_banner = null

func fix_banner_index():
	for i in range($BannerList.get_child_count()):
		var node = $BannerList.get_child(i)
		node.index = i
		i += 1

# Get the next game, circular
func get_game_id_circular(from_id: int, direction: int) -> int:
	return int(fposmod(from_id + direction, GameList.GAME_LIST.size()))

# Move the banner to the first position
func center_selected_banner() -> void:

	# Stop the current animation
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.stop(true)
	
	# Get the positions
	var from = get_h_scroll_bar().value
	var destination = int(get_h_scroll_bar().max_value/GameList.GAME_LIST.size() * selected_banner.index - size.x/2 + (get_h_scroll_bar().max_value/GameList.GAME_LIST.size()/2))
	
	if from != destination:
		# Set the animation keys
		var animation = $AnimationPlayer.get_animation("scroll")
		animation.bezier_track_set_key_value(0, 0, from)
		animation.bezier_track_set_key_value(0, 1, destination)
	
		# Play the animation
		$AnimationPlayer.play("scroll")

# When a banner is selected
func _on_banner_selection(index: int):

	var banner = $BannerList.get_child(index)
	selected_banner = banner
	var direction = index - GameList.GAME_LIST.size() / 2.0
	var direction_int = int(direction)
	if (direction_int == 0):
		direction_int = 1

	# Each banner has an index, which is the position of the banner in the container
	if(direction < 0):
		for i in range(abs(direction_int)):
			move_banner_last_to_first()
			get_h_scroll_bar().value += + 2 * get_h_scroll_bar().max_value/GameList.GAME_LIST.size()
	elif(direction > 0):
		for i in range(abs(direction_int)):
			move_banner_first_to_last()
			get_h_scroll_bar().value += - 5 * get_h_scroll_bar().max_value/GameList.GAME_LIST.size()

	# Emit game selected
	BusEvent.emit_signal("BANNER_MENU_FOCUSED")
	BusEvent.emit_signal("GAME_SELECTED", banner.game_id)
	BusEvent.emit_signal("CENTER_SELECTED_BANNER")


# Add a banner to the container, last position
func add_banner(game: GameList.Game) -> void:
	var banner_scene = load("res://scenes/home/banner_list/game_banner.tscn")
	var banner = banner_scene.instantiate()
	
	# Set the banner node properties
	banner.set_banner_texture(game.banner)
	banner.set_banner_bottom_label(game.name)
	banner.set_game_id(game.id)
	banner.index = -1
	
	banner.size_flags_horizontal = 3 # Set the size to develop

	# Add the banner to the container
	$BannerList.add_child(banner)


func move_banner_last_to_first() -> void:
	var last_banner = $BannerList.get_child($BannerList.get_child_count() - 1)
	$BannerList.move_child(last_banner, 0)
	fix_banner_index()

func move_banner_first_to_last() -> void:
	var first_banner = $BannerList.get_child(0)
	$BannerList.move_child(first_banner, $BannerList.get_child_count() - 1)
	fix_banner_index()

func reload_banners() -> void:

	# Remove all children
	for child in $BannerList.get_children():
		$BannerList.remove_child(child)
		child.propagate_call("queue_free", [])
	
	for game in GameList.GAME_LIST:
		add_banner(game)
	fix_banner_index()

	BusEvent.emit_signal("BANNER_MENU_RELOADED")

# When the game list is loaded
func _on_main_game_list_loaded() -> void:
	reload_banners()

func grab_focus_on_banner(id: int):
	for i in range($BannerList.get_child_count()):
		var banner = $BannerList.get_child(i)
		if banner.game_id == id:
			banner.grab_banner_focus()
			break

func _ready() -> void:
	BusEvent.connect("GAME_LIST_LOADED", _on_main_game_list_loaded)
	BusEvent.connect("BANNER_SELECTED", _on_banner_selection)
	BusEvent.connect("CENTER_SELECTED_BANNER", center_selected_banner)


func _on_auto_scroll_timeout() -> void:
	## press right
	var a = InputEventKey.new()
	a.keycode = KEY_RIGHT
	a.pressed = true
	Input.parse_input_event(a)
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	# Stop the current animation
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.stop(true)
	
	# Get the positions
	var from = get_h_scroll_bar().value
	var destination = int(get_h_scroll_bar().max_value/GameList.GAME_LIST.size() * selected_banner.index - size.x/2 + (get_h_scroll_bar().max_value/GameList.GAME_LIST.size()/2))
	
	if from != destination:
		# Set the animation keys
		var animation = $AnimationPlayer.get_animation("scroll_2")
		animation.bezier_track_set_key_value(0, 0, from)
		animation.bezier_track_set_key_value(0, 1, destination)
	
		# Play the animation
		$AnimationPlayer.play("scroll_2")
