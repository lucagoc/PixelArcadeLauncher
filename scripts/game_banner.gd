extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_texture_rect_focus_entered() -> void:
	$AnimationPlayer.play("focus_entered")


func _on_texture_rect_focus_exited() -> void:
	$AnimationPlayer.play("focus_exit")
