extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_option_button_pressed() -> void:
	# Open debug_menu
	get_tree().change_scene_to_file("res://scenes/debug_menu.tscn")


func _on_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	# Open the game
	# var game = game_list[index]
	#launch_game(game)
	return
