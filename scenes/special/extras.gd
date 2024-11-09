extends Control

func _on_game_launched(id: int):
	$BlackOutDelay.start()

func _on_black_out_delay_timeout() -> void:
	$AnimationPlayer.play("black_out")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	#ProcessManager.launch_game()
	pass

func _ready() -> void:
	BusEvent.connect("GAME_LAUNCHED", _on_game_launched)
