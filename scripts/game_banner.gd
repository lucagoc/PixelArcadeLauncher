extends VBoxContainer

var BottomLabel
var TopLabel
var id
var index

signal banner_focused(id: String)

func set_id(in_id: String) -> void:
	id = in_id

func set_index(in_index: int) -> void:
	index = in_index

func set_focus():
	$TextureRect.grab_focus()

func set_banner_texture(texture: Texture) -> void:
	$TextureRect.texture = texture

func set_banner_top_label(label: String) -> void:
	$TopLabel.text = label

func set_banner_bottom_label(label: String) -> void:
	BottomLabel = label

func set_focus_neighbor_left(banner: VBoxContainer) -> void:
	$TextureRect.set_focus_neighbor(SIDE_LEFT, banner.get_node("TextureRect").get_path())

func set_focus_neighbor_right(banner: VBoxContainer) -> void:
	$TextureRect.set_focus_neighbor(SIDE_RIGHT, banner.get_node("TextureRect").get_path())

func _on_texture_rect_focus_entered() -> void:
	if BottomLabel != null:
		$BottomLabel.text = BottomLabel
	$AnimationPlayer.play("focus_entered")
	emit_signal("banner_focused", id)

func _on_texture_rect_focus_exited() -> void:
	$BottomLabel.text = ""
	$AnimationPlayer.play("RESET")
