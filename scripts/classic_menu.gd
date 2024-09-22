extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_main_game_list_loaded() -> void:
	# # Create a banner card of the game (game.banner) centered on the screen
	# var banner_card = TextureRect.new()
	# banner_card.texture = main.game_list[0].banner
	# banner_card.rect_min_size = Vector2(100, 150)
	# banner_card.rect_position = Vector2(0, 0)
	# add_child(banner_card)
	pass
