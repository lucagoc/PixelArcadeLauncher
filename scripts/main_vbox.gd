extends VBoxContainer

var isDrawerOpened = false

func _on_banner_menu_focus_entered(id: String) -> void:
	if isDrawerOpened:
		$AnimationPlayer.play("close_drawer")
		isDrawerOpened = false

func _on_drawer_menu_focus_entered() -> void:
	if not isDrawerOpened:
		$AnimationPlayer.play("open_drawer")
		isDrawerOpened = true

func _ready() -> void:
	LimboConsole.register_command(_on_banner_menu_focus_entered, "close_drawer", "Close the drawer")
	LimboConsole.register_command(_on_drawer_menu_focus_entered, "open_drawer", "Open the drawer")