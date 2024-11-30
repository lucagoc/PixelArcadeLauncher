extends Panel

func _on_category_list_focus_entered() -> void:
	$MainHbox/AnimationPlayer.play("open_category")

func _on_category_list_focus_exited() -> void:
	$MainHbox/AnimationPlayer.play("close_category")

func _on_settings_loaded() -> void:
	$MainHbox/CategoryBar/CategoryList.select(0) # Select the first category

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	pass
