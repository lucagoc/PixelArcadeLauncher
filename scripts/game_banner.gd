extends VBoxContainer

var BottomLabel
var TopLabel

func set_banner_texture(texture: Texture) -> void:
	$TextureRect.texture = texture

func set_banner_top_label(label: String) -> void:
	$TopLabel.text = label

func set_banner_bottom_label(label: String) -> void:
	BottomLabel = label

func _on_texture_rect_focus_entered() -> void:
	$BottomLabel.text = BottomLabel
	$AnimationPlayer.play("focus_entered")


func _on_texture_rect_focus_exited() -> void:
	$BottomLabel.text = ""
	$AnimationPlayer.play("focus_exit")
