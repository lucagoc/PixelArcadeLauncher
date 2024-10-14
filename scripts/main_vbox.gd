extends VBoxContainer

var isDrawerOpened = true

func _on_banner_menu_focus_entered() -> void:
	if isDrawerOpened:
		$AnimationPlayer.play("close_drawer")
		isDrawerOpened = false

func _on_drawer_menu_focus_entered() -> void:
	if not isDrawerOpened:
		$AnimationPlayer.play("open_drawer")
		isDrawerOpened = true
