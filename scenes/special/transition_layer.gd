# Transition Layer
# This script is attached to the scene "TransitionLayer" and makes the transition between the game and the main menu.
# It creates a delay before the game is launched.

extends Control

var _selected_game: int = -1
var _about_to_launch: bool = false
var _interrupted = false

## PRIVATE METHODS
func _on_game_launched(_id: int):
	_about_to_launch = true
	$BlackOutDelay.start()
	_selected_game = _id

func _on_black_out_delay_timeout() -> void:
	$AnimationPlayer.play("black_out")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "black_out" and not _interrupted:
		_about_to_launch = false
		ProcessManager.launch_game(_selected_game)
	elif anim_name == "black_in":
		BusEvent.emit_signal("CENTER_SELECTED_BANNER")
		_interrupted = false

func _on_game_exited(_id: int):
	if not _interrupted:
		$AnimationPlayer.play("black_in")
		_interrupted = false

func _ready() -> void:
	BusEvent.connect("GAME_LAUNCHED", _on_game_launched)
	BusEvent.connect("GAME_EXITED", _on_game_exited)

func _process(delta: float) -> void:
	if _about_to_launch and (Input.is_action_just_pressed("ui_cancel")):
		_about_to_launch = false
		_interrupted = true
		$BlackOutDelay.stop()
		$AnimationPlayer.play("black_in")
		BusEvent.emit_signal("GAME_EXITED", _selected_game)
