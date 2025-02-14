extends VBoxContainer

var _is_drawer_focused := false
var _is_about_opened := false
const DRAWER_SIZE := 0.70
const ABOUT_SIZE := 0.75

func _on_banner_menu_focused() -> void:
	if _is_about_opened:
		$AboutAnimationPlayer.play_backwards("about_open")
		_is_about_opened = false
	if _is_drawer_focused:
		$DrawerSound.play()
		var drawer_size = $Drawer.custom_minimum_size.y
		var animation = $AnimationPlayer.get_animation("close_drawer")
		animation.bezier_track_set_key_value(0, 0, drawer_size)
		$AnimationPlayer.queue("close_drawer")
		_is_drawer_focused = false
	
	$Credits.hide()

func _on_drawer_focused() -> void:
	$AboutAnimationPlayer.play("RESET")
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
	$GameLaunchSound.play()
	$Drawer.hide()

func _on_game_exited(id: int):
	$AnimationPlayer.play("RESET")
	$BannerScrollList.grab_focus_on_banner(id)
	$Drawer.show()

func _on_screensaver_start():
	$AnimationPlayer.play_backwards("fade_in")

func _on_screensaver_stop():
	$AnimationPlayer.play("fade_in")

func _on_about_opened():
	var about_size = get_viewport_rect().size.y * ABOUT_SIZE
	var animation = $AboutAnimationPlayer.get_animation("about_open")
	$CreditsAnimationPlayer.play("RESET")
	animation.bezier_track_set_key_value(0, 1, about_size)
	$AboutAnimationPlayer.play("about_open")
	_is_about_opened = true
	$Credits.show()

func _on_credits_opened():
	var credits_size = get_viewport_rect().size.y * ABOUT_SIZE
	var animation = $CreditsAnimationPlayer.get_animation("credits_open")
	animation.bezier_track_set_key_value(0, 1, credits_size)
	$AboutAnimationPlayer.play_backwards("about_open")
	$CreditsAnimationPlayer.play("credits_open")

func _ready() -> void:
	BusEvent.connect("BANNER_MENU_FOCUSED", _on_banner_menu_focused)
	BusEvent.connect("DRAWER_FOCUSED", _on_drawer_focused)
	BusEvent.connect("GAME_LAUNCHED", _on_game_launched)
	BusEvent.connect("GAME_EXITED", _on_game_exited)
	BusEvent.connect("START_SCREENSAVER", _on_screensaver_start)
	BusEvent.connect("STOP_SCREENSAVER", _on_screensaver_stop)
	BusEvent.connect("ABOUT_OPENED", _on_about_opened)
	BusEvent.connect("CREDITS_OPENED", _on_credits_opened)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "close_drawer":
		BusEvent.emit_signal("CENTER_SELECTED_BANNER")
