extends VBoxContainer

var index
var game_id: int			# Unique ID of the game
var BottomLabel: String		# Bottom label of the banner
var TopLabel: String		# Top label of the banner

var tags_hidden = false
var audio_playback = true

func set_game_id(in_id: int) -> void:
	game_id = in_id

func set_focus():
	$TextureRect.grab_focus()

func set_banner_texture(texture: Texture) -> void:
	$TextureRect.texture = texture

func set_banner_top_label(label: String) -> void:
	$TopLabel.text = label

func set_banner_bottom_label(label: String) -> void:
	BottomLabel = label

func set_banner_theme(theme: AudioStreamOggVorbis) -> void:
	$AudioStreamPlayer.stream = theme

func show_tags() -> void:
	if tags_hidden:
		$AnimationPlayer.play("show_tags")
		tags_hidden = false

func hide_tags() -> void:
	if not tags_hidden:
		$TextureRect/ColorRect.hide()
		$AnimationPlayer.play("hide_tags")
		tags_hidden = true

func set_focus_neighbor_left(banner: VBoxContainer) -> void:
	$TextureRect.set_focus_neighbor(SIDE_LEFT, banner.get_node("TextureRect").get_path())

func set_focus_neighbor_right(banner: VBoxContainer) -> void:
	$TextureRect.set_focus_neighbor(SIDE_RIGHT, banner.get_node("TextureRect").get_path())

func _on_texture_rect_focus_entered() -> void:
	$TextureRect/SelectionRect.show()
	if BottomLabel != null:
		#$BottomLabel.text = BottomLabel
		pass

	show_tags()

	if audio_playback:
		$AudioStreamPlayer.play()
		$AudioStreamAnimation.play("fade_in")
		$MaxThemeLength.start()
	$AnimationPlayer.queue("focus_entered")
	BusEvent.emit_signal("BANNER_SELECTED", index)

func _on_texture_rect_focus_exited() -> void:
	$TextureRect/SelectionRect.hide()
	$BottomLabel.text = ""

	# Play animation backward from the last frame
	var animation = $AudioStreamAnimation.get_animation("fast_fade_out")
	animation.bezier_track_set_key_value(0, 0, $AudioStreamPlayer.volume_db)
	$AudioStreamAnimation.play("fast_fade_out")
	var last_position = $AnimationPlayer.current_animation_position
	$AnimationPlayer.play_backwards("focus_entered")
	$AnimationPlayer.seek(last_position)

func _on_select_game(id: int) -> void:
	if id == game_id:
		$TextureRect.grab_focus()

func _on_game_launched(id: int) -> void:
	if id == game_id:
		$TextureRect/SelectionRect.hide()
		var animation = $AudioStreamAnimation.get_animation("fast_fade_out")
		animation.bezier_track_set_key_value(0, 0, $AudioStreamPlayer.volume_db)
		$AudioStreamAnimation.play("fast_fade_out")
	else:
		self.hide()

func _on_game_exited(id: int) -> void:
	if id == game_id:
		$TextureRect/SelectionRect.show()
	else:
		self.show()

func _on_disable_banner_focus():
	$TextureRect.focus_mode = FOCUS_NONE

func _on_enable_banner_focus():
	$TextureRect.focus_mode = FOCUS_ALL

func _on_screensaver_start():
	audio_playback = false

func _on_screensaver_stop():
	audio_playback = true

func grab_banner_focus():
	$TextureRect.grab_focus()

func _ready() -> void:
	BusEvent.connect("DRAWER_FOCUSED", hide_tags)
	BusEvent.connect("BANNER_MENU_FOCUSED", show_tags)
	BusEvent.connect("SELECT_GAME", _on_select_game)
	BusEvent.connect("GAME_LAUNCHED", _on_game_launched)
	BusEvent.connect("GAME_EXITED", _on_game_exited)
	BusEvent.connect("START_SCREENSAVER", _on_screensaver_start)
	BusEvent.connect("STOP_SCREENSAVER", _on_screensaver_stop)
	BusEvent.connect("ENABLE_BANNER_FOCUS", _on_enable_banner_focus)
	BusEvent.connect("DISABLE_BANNER_FOCUS", _on_disable_banner_focus)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and $TextureRect/SelectionRect.visible and not IdleManager.screensaver and not ProcessManager.game_running:
		BusEvent.emit_signal("GAME_LAUNCHED", game_id)


func _on_max_theme_length_timeout() -> void:
	$AudioStreamAnimation.play("fade_out")

func _on_audio_stream_player_finished() -> void:
	pass

func _on_audio_stream_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out" || anim_name == "fast_fade_out":
		$AudioStreamPlayer.stop()
		$MaxThemeLength.stop()
		$AudioStreamAnimation.play("RESET")
