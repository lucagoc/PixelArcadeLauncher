extends Control

var selected_game_index = 0

# Return the next game index
func next_game_index(game_index):
	if game_index < ($"../".game_list.size() - 1):
		return game_index + 1
	else:
		return 0

# Return the previous game index
func previous_game_index(game_index):
	if game_index > 0:
		return game_index - 1
	else:
		return $"../".game_list.size() - 1


func _on_main_game_list_loaded() -> void:
	
	# Create a banner card of the game (game.banner) centered on the screen
	# var banner_card = BannerCard.new()
	# banner_card.set_game($"../".game_list[selected_game_index])
	pass

func _process(delta: float) -> void:
	pass


func _ready() -> void:
	return
