extends Node

func _on_game_selected(_id: int) -> void:
    # Load the GIF into the Matrix LED
    return

func _ready():
    BusEvent.connect("GAME_SELECTED", _on_game_selected)