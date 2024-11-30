extends ColorRect

var button_up = load("res://assets/img/icons/buttons/yellow_up.png")
var button_down = load("res://assets/img/icons/buttons/yellow_down.png")
var button_frame = 0

var joystick_up = load("res://assets/img/icons/joysticks/p1_up.png")
var joystick_idle = load("res://assets/img/icons/joysticks/p1_idle.png")
var joystick_down = load("res://assets/img/icons/joysticks/p1_down.png")
var joystick_frame = 0

func _on_game_selected(index: int) -> void:
	$BottomHbox/GameTitle.text = GameList.GAME_LIST[index].name

func _on_drawer_focused():
	$BottomHbox/GameTitle.hide()

func _on_banner_focused():
	$BottomHbox/GameTitle.show()

func _on_game_launched(id: int):
	$BottomHbox/HelperLeft.hide()
	$BottomHbox/GameTitle.hide()
	$BottomHbox/HelperRight.hide()

func _on_game_exited(id: int):
	$BottomHbox/HelperLeft.show()
	$BottomHbox/GameTitle.show()
	$BottomHbox/HelperRight.show()

func _ready() -> void:
	BusEvent.connect("GAME_SELECTED", _on_game_selected)
	BusEvent.connect("DRAWER_FOCUSED", _on_drawer_focused)
	BusEvent.connect("BANNER_MENU_FOCUSED", _on_banner_focused)
	BusEvent.connect("GAME_LAUNCHED", _on_game_launched)
	BusEvent.connect("GAME_EXITED", _on_game_exited)


func _on_refresh_timer_timeout() -> void:
	if button_frame:
		$BottomHbox/HelperRight/Button/TextureRect.texture = button_up
	else:
		$BottomHbox/HelperRight/Button/TextureRect.texture = button_down
	button_frame = (button_frame + 1)%2


func _on_stick_animation_timeout() -> void:
	if joystick_frame == 0:
		$BottomHbox/HelperLeft/Arrow/TextureRect.texture = joystick_up
	elif joystick_frame == 1:
		$BottomHbox/HelperLeft/Arrow/TextureRect.texture = joystick_idle
	elif joystick_frame == 2:
		$BottomHbox/HelperLeft/Arrow/TextureRect.texture = joystick_down
	else:
		$BottomHbox/HelperLeft/Arrow/TextureRect.texture = joystick_idle
	
	joystick_frame = (joystick_frame + 1)%4
