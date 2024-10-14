extends VBoxContainer

var BottomLabel
var TopLabel
var id

signal banner_focused(id: String)

func set_id(in_id: String) -> void:
	id = in_id

func set_focus():
	$TextureRect.grab_focus()

func set_banner_texture(texture: Texture) -> void:
	$TextureRect.texture = texture

func set_banner_top_label(label: String) -> void:
	$TopLabel.text = label

func set_banner_bottom_label(label: String) -> void:
	BottomLabel = label

func _on_texture_rect_focus_entered() -> void:
	if BottomLabel != null:
		$BottomLabel.text = BottomLabel
	$AnimationPlayer.play("focus_entered")
	emit_signal("banner_focused", id)

func _on_texture_rect_focus_exited() -> void:
	$BottomLabel.text = ""
	$AnimationPlayer.play_backwards("focus_entered")
