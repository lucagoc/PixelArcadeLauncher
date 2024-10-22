extends VBoxContainer

var _is_drawer_focused = false

func _on_banner_menu_focused() -> void:
	if _is_drawer_focused:
		var drawer_size = $Drawer.custom_minimum_size.y
		var animation = $AnimationPlayer.get_animation("close_drawer")
		animation.bezier_track_set_key_value(0, 0, drawer_size)
		$AnimationPlayer.play("close_drawer")
		_is_drawer_focused = false

func _on_drawer_focused() -> void:
	if not _is_drawer_focused:
		# Set the drawer size to 70% of the screen height
		var drawer_size = get_viewport_rect().size.y * 0.7
		var animation = $AnimationPlayer.get_animation("open_drawer")
		animation.bezier_track_set_key_value(0, 1, drawer_size)
		
		# Play the animation
		$AnimationPlayer.play("open_drawer")
		_is_drawer_focused = true

func _ready() -> void:
	BusEvent.connect("BANNER_MENU_FOCUSED", _on_banner_menu_focused)
	BusEvent.connect("DRAWER_FOCUSED", _on_drawer_focused)
