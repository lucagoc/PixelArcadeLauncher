extends VBoxContainer

var _is_drawer_focused := false
const DRAWER_SIZE := 0.70

func _on_banner_menu_focused() -> void:
	if _is_drawer_focused:
		$DrawerSound.play()
		var drawer_size = $Drawer.custom_minimum_size.y
		var animation = $AnimationPlayer.get_animation("close_drawer")
		animation.bezier_track_set_key_value(0, 0, drawer_size)
		$AnimationPlayer.queue("close_drawer")
		_is_drawer_focused = false

func _on_drawer_focused() -> void:
	if not _is_drawer_focused:
		$DrawerSound.play()
		# Set the drawer size to 70% of the screen height
		var drawer_size = get_viewport_rect().size.y * DRAWER_SIZE
		var animation = $AnimationPlayer.get_animation("open_drawer")
		animation.bezier_track_set_key_value(0, 1, drawer_size)
		
		# Play the animation
		$AnimationPlayer.play("open_drawer")
		_is_drawer_focused = true

func _on_game_launched(_id: int):
	$AnimationPlayer.play("hide_bars")
	$AudioStreamPlayer.play()
	$Drawer.hide()

func _on_game_exited(id: int):
	$AnimationPlayer.play("RESET")
	$BannerScrollList.grab_focus_on_banner(id)
	$Drawer.show()

func _on_screensaver_start():
	$AnimationPlayer.play_backwards("fade_in")

func _on_screensaver_stop():
	$AnimationPlayer.play("fade_in")

func _ready() -> void:
	BusEvent.connect("BANNER_MENU_FOCUSED", _on_banner_menu_focused)
	BusEvent.connect("DRAWER_FOCUSED", _on_drawer_focused)
	BusEvent.connect("GAME_LAUNCHED", _on_game_launched)
	BusEvent.connect("GAME_EXITED", _on_game_exited)
	BusEvent.connect("START_SCREENSAVER", _on_screensaver_start)
	BusEvent.connect("STOP_SCREENSAVER", _on_screensaver_stop)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "close_drawer":
		BusEvent.emit_signal("CENTER_SELECTED_BANNER")
