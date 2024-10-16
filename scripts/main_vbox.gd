extends VBoxContainer

var isDrawerOpened = false

signal hide_banner_tags
signal show_banner_tags

func _on_banner_menu_focus_entered(id: String) -> void:
	if isDrawerOpened:
		$AnimationPlayer.play("close_drawer")
		isDrawerOpened = false
	
	# Emit signal to show all tags in the banners
	emit_signal("show_banner_tags")


func _on_drawer_menu_focus_entered() -> void:
	if not isDrawerOpened:
		$AnimationPlayer.play("open_drawer")
		isDrawerOpened = true
	
	# Emit signal to hide all tags in the banners
	emit_signal("hide_banner_tags")

func _ready() -> void:
	LimboConsole.register_command(_on_banner_menu_focus_entered, "close_drawer", "Close the drawer")
	LimboConsole.register_command(_on_drawer_menu_focus_entered, "open_drawer", "Open the drawer")
