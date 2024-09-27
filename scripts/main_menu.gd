extends Control


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _on_option_button_pressed() -> void:
	# Open debug_menu
	get_tree().change_scene_to_file("res://scenes/debug_menu.tscn")


func _on_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	# Open the game
	# var game = game_list[index]
	# launch_game(game)
	return


func _on_main_game_list_loaded() -> void:
	$MainVbox/ListHbox/ItemList.clear()
	for game in $"../".game_list:
		$MainVbox/ListHbox/ItemList.add_item(game.name, game.icon)
	$MainVbox/ListHbox/ItemList.grab_focus()
	$MainVbox/ListHbox/ItemList.select(0)

func _on_item_list_item_selected(index: int) -> void:
	# Load hero on background
	var game = $"../".game_list[index]
	print("[INFO] Loading banner for " + game.name)
	if game.hero != null:
		$Background/BackgroundHero.texture = game.hero


func _on_timer_timeout() -> void:
	# Refresh bottom bar
	$MainVbox/BottomBar/BottomHbox/RamLabel.text = "RAM: " + str(OS.get_static_memory_usage() / 1024 / 1024) + " MB"
	$MainVbox/BottomBar/BottomHbox/TimeLabel.text = Time.get_time_string_from_system()
	$MainVbox/BottomBar/BottomHbox/VersionLabel.text = "Version: 0.1 TESTING"
