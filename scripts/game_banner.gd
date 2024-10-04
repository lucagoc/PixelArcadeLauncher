extends VBoxContainer


func set_banner_texture(texture: Texture) -> void:
	$TextureRect.texture = texture


func _on_texture_rect_focus_entered() -> void:
	$AnimationPlayer.play("focus_entered")


func _on_texture_rect_focus_exited() -> void:
	$AnimationPlayer.play("focus_exit")
