# Transition Layer
# This script is attached to the scene "TransitionLayer" and makes the transition between the game and the main menu.
# It creates a delay before the game is launched.

extends Control

var _selected_game: int = -1

## PRIVATE METHODS
func _on_game_launched(_id: int):
	$BlackOutDelay.start()
	_selected_game = _id

func _on_black_out_delay_timeout() -> void:
	$AnimationPlayer.play("black_out")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "black_out":
		ProcessManager.launch_game(_selected_game)
	elif anim_name == "black_in":
		BusEvent.emit_signal("CENTER_SELECTED_BANNER")

func _on_game_exited(_id: int):
	$AnimationPlayer.play("black_in")

func _ready() -> void:
	BusEvent.connect("GAME_LAUNCHED", _on_game_launched)
	BusEvent.connect("GAME_EXITED", _on_game_exited)
