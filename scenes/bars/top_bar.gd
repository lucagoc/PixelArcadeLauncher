extends ColorRect

func _on_option_button_pressed() -> void:
	# Open debug_menu
	get_tree().change_scene_to_file("res://scenes/settings/settings_menu.tscn")


func _on_timer_timeout() -> void:
	$TopHbox/TimeLabel.text = Time.get_time_string_from_system()

func _on_game_launched(_id: int):
	$AnimationPlayer.play("fade_out")

func _on_game_exited(_id: int):
	$AnimationPlayer.play_backwards("fade_out")

func _on_christmas():
	color = "a81e1e"

func _on_april_fools():
	color = "ff00d9"

func _ready() -> void:
	BusEvent.connect("GAME_LAUNCHED", _on_game_launched)
	BusEvent.connect("GAME_EXITED", _on_game_exited)
	BusEvent.connect("CHRISTMAS_MODE", _on_christmas)
	BusEvent.connect("APRIL_FOOLS_MODE", _on_april_fools)
	
	$TopHbox/VersionLabel.text = ProjectSettings.get_setting("application/config/version")
