extends VBoxContainer

var _is_drawer_focused := false
const DRAWER_SIZE := 0.70

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
		var drawer_size = get_viewport_rect().size.y * DRAWER_SIZE
		var animation = $AnimationPlayer.get_animation("open_drawer")
		animation.bezier_track_set_key_value(0, 1, drawer_size)
		
		# Play the animation
		$AnimationPlayer.play("open_drawer")
		_is_drawer_focused = true

func _on_game_launched(id: int):
	$AnimationPlayer.play("hide_bars")
	$AudioStreamPlayer.play()
	$Drawer.hide()

func _on_game_exited(id: int):
	$BannerScrollList.grab_focus_on_banner(id)
	$AnimationPlayer.play("RESET")
	$Drawer.show()

func _ready() -> void:
	BusEvent.connect("BANNER_MENU_FOCUSED", _on_banner_menu_focused)
	BusEvent.connect("DRAWER_FOCUSED", _on_drawer_focused)
	BusEvent.connect("GAME_LAUNCHED", _on_game_launched)
	BusEvent.connect("GAME_EXITED", _on_game_exited)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "close_drawer":
		BusEvent.emit_signal("CENTER_SELECTED_BANNER")
