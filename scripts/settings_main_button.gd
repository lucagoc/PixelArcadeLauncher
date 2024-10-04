extends Button


func _on_focus_entered() -> void:
	$AnimationPlayer.play("focus_entered")


func _on_focus_exited() -> void:
	$AnimationPlayer.play("focus_exit")
