extends ColorRect

func _on_option_button_pressed() -> void:
	# Open debug_menu
	get_tree().change_scene_to_file("res://scenes/settings_menu.tscn")
