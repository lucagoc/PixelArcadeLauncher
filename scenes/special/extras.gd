extends Control

func _on_game_launched(id: int):
	$BlackOutDelay.start()
	ProcessManager.set_game(id)

func _on_black_out_delay_timeout() -> void:
	$AnimationPlayer.play("black_out")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "black_out":
		ProcessManager.launch_game()
	elif anim_name == "black_in":
		BusEvent.emit_signal("CENTER_SELECTED_BANNER")

func _on_game_exited(id: int):
	$AnimationPlayer.play("black_in")

func _ready() -> void:
	BusEvent.connect("GAME_LAUNCHED", _on_game_launched)
	BusEvent.connect("GAME_EXITED", _on_game_exited)
