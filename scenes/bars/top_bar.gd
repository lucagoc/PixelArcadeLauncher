extends ColorRect

func _on_option_button_pressed() -> void:
	# Open debug_menu
	get_tree().change_scene_to_file("res://scenes/settings/settings_menu.tscn")


func _on_timer_timeout() -> void:
	$TopHbox/TimeLabel.text = Time.get_time_string_from_system()

func _on_game_launched(id: int):
	$AnimationPlayer.play("fade_out")

func _ready() -> void:
	BusEvent.connect("GAME_LAUNCHED", _on_game_launched)
