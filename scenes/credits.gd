extends HBoxContainer


func _on_focus_entered() -> void:
	BusEvent.emit_signal("CREDITS_OPENED")
	$Music.play()


func _on_focus_exited() -> void:
	$Music.stop()
