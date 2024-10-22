extends VBoxContainer

var isDrawerOpened = false

func _on_banner_menu_focus_entered() -> void:
	if isDrawerOpened:
		var drawer_size = $DrawerMenu.custom_minimum_size.y
		var animation = $AnimationPlayer.get_animation("close_drawer")
		animation.bezier_track_set_key_value(0, 0, drawer_size)
		$AnimationPlayer.play("close_drawer")
		isDrawerOpened = false
	
	# Emit signal to show all tags in the banners
	BusEvent.emit_signal("BANNER_MENU_FOCUSED")


func _on_drawer_menu_focus_entered() -> void:
	if not isDrawerOpened:
		# Set the drawer size to 70% of the screen height
		var drawer_size = get_viewport_rect().size.y * 0.7
		var animation = $AnimationPlayer.get_animation("open_drawer")
		animation.bezier_track_set_key_value(0, 1, drawer_size)
		
		# Play the animation
		$AnimationPlayer.play("open_drawer")
		isDrawerOpened = true
	
	# Emit signal to hide all tags in the banners
	emit_signal("DRAWER_MENU_FOCUSED")

func _ready() -> void:
	LimboConsole.register_command(_on_banner_menu_focus_entered, "close_drawer", "Close the drawer")
	LimboConsole.register_command(_on_drawer_menu_focus_entered, "open_drawer", "Open the drawer")

func _on_category_list_focus_entered() -> void:
	_on_drawer_menu_focus_entered()
