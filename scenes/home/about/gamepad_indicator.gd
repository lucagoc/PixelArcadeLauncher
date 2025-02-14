extends VBoxContainer

@export var textures_P1_stick : Array[Texture] = []
@export var textures_P1_buttons : Array[Texture] = []
@export var textures_P2_stick : Array[Texture] = []
@export var textures_P2_buttons : Array[Texture] = []

@export var pressed_color = "ffe042"
@export var base_color = "ffffff"

func get_string(id: int, controller_number: int):
	if GameList.GAME_LIST[id].controls.size() > controller_number:
		return GameList.GAME_LIST[id].controls[controller_number]
	else:
		return ""

func check_p1_buttons():
	if Input.is_action_just_pressed("P1_1"):
		$ControlsText/ControlP1/Controls/Left/B1.set("theme_override_colors/font_color", pressed_color)
		$"GamepadBox/GamepadIndicator/White/1".texture = textures_P1_buttons[1]
	if Input.is_action_just_pressed("P1_2"):
		$ControlsText/ControlP1/Controls/Center/B2.set("theme_override_colors/font_color", pressed_color)
		$"GamepadBox/GamepadIndicator/White/2".texture = textures_P1_buttons[1]
	if Input.is_action_just_pressed("P1_3"):
		$ControlsText/ControlP1/Controls/Right/B3.set("theme_override_colors/font_color", pressed_color)
		$"GamepadBox/GamepadIndicator/White/3".texture = textures_P1_buttons[1]
	if Input.is_action_just_pressed("P1_4"):
		$ControlsText/ControlP1/Controls/Left/B4.set("theme_override_colors/font_color", pressed_color)
		$"GamepadBox/GamepadIndicator/White/4".texture = textures_P1_buttons[1]
	if Input.is_action_just_pressed("P1_5"):
		$"GamepadBox/GamepadIndicator/White/5".texture = textures_P1_buttons[1]
		$ControlsText/ControlP1/Controls/Center/B5.set("theme_override_colors/font_color", pressed_color)
	if Input.is_action_just_pressed("P1_6"):
		$ControlsText/ControlP1/Controls/Right/B6.set("theme_override_colors/font_color", pressed_color)
		$"GamepadBox/GamepadIndicator/White/6".texture = textures_P1_buttons[1]
	
	if Input.is_action_just_released("P1_1"):
		$ControlsText/ControlP1/Controls/Left/B1.set("theme_override_colors/font_color", base_color)
		$"GamepadBox/GamepadIndicator/White/1".texture = textures_P1_buttons[0]
	if Input.is_action_just_released("P1_2"):
		$ControlsText/ControlP1/Controls/Center/B2.set("theme_override_colors/font_color", base_color)
		$"GamepadBox/GamepadIndicator/White/2".texture = textures_P1_buttons[0]
	if Input.is_action_just_released("P1_3"):
		$ControlsText/ControlP1/Controls/Right/B3.set("theme_override_colors/font_color", base_color)
		$"GamepadBox/GamepadIndicator/White/3".texture = textures_P1_buttons[0]
	if Input.is_action_just_released("P1_4"):	
		$ControlsText/ControlP1/Controls/Left/B4.set("theme_override_colors/font_color", base_color)
		$"GamepadBox/GamepadIndicator/White/4".texture = textures_P1_buttons[0]
	if Input.is_action_just_released("P1_5"):
		$ControlsText/ControlP1/Controls/Center/B5.set("theme_override_colors/font_color", base_color)
		$"GamepadBox/GamepadIndicator/White/5".texture = textures_P1_buttons[0]
	if Input.is_action_just_released("P1_6"):
		$ControlsText/ControlP1/Controls/Right/B6.set("theme_override_colors/font_color", base_color)
		$"GamepadBox/GamepadIndicator/White/6".texture = textures_P1_buttons[0]

func check_p2_buttons():
	if Input.is_action_just_pressed("P2_1"):
		$ControlsText/ControlP2/Controls/Left/B1.set("theme_override_colors/font_color", pressed_color)
		$"GamepadBox/GamepadIndicator/Black/1".texture = textures_P2_buttons[1]
	if Input.is_action_just_pressed("P2_2"):
		$ControlsText/ControlP2/Controls/Center/B2.set("theme_override_colors/font_color", pressed_color)
		$"GamepadBox/GamepadIndicator/Black/2".texture = textures_P2_buttons[1]
	if Input.is_action_just_pressed("P2_3"):
		$ControlsText/ControlP2/Controls/Right/B3.set("theme_override_colors/font_color", pressed_color)
		$"GamepadBox/GamepadIndicator/Black/3".texture = textures_P2_buttons[1]
	if Input.is_action_just_pressed("P2_4"):
		$ControlsText/ControlP2/Controls/Left/B4.set("theme_override_colors/font_color", pressed_color)
		$"GamepadBox/GamepadIndicator/Black/4".texture = textures_P2_buttons[1]
	if Input.is_action_just_pressed("P2_5"):
		$ControlsText/ControlP2/Controls/Center/B5.set("theme_override_colors/font_color", pressed_color)
		$"GamepadBox/GamepadIndicator/Black/5".texture = textures_P2_buttons[1]
	if Input.is_action_just_pressed("P2_6"):
		$ControlsText/ControlP2/Controls/Right/B6.set("theme_override_colors/font_color", pressed_color)
		$"GamepadBox/GamepadIndicator/Black/6".texture = textures_P2_buttons[1]
	
	if Input.is_action_just_released("P2_1"):
		$ControlsText/ControlP2/Controls/Left/B1.set("theme_override_colors/font_color", base_color)
		$"GamepadBox/GamepadIndicator/Black/1".texture = textures_P2_buttons[0]
	if Input.is_action_just_released("P2_2"):
		$ControlsText/ControlP2/Controls/Center/B2.set("theme_override_colors/font_color", base_color)
		$"GamepadBox/GamepadIndicator/Black/2".texture = textures_P2_buttons[0]
	if Input.is_action_just_released("P2_3"):
		$ControlsText/ControlP2/Controls/Right/B3.set("theme_override_colors/font_color", base_color)
		$"GamepadBox/GamepadIndicator/Black/3".texture = textures_P2_buttons[0]
	if Input.is_action_just_released("P2_4"):
		$ControlsText/ControlP2/Controls/Left/B4.set("theme_override_colors/font_color", base_color)
		$"GamepadBox/GamepadIndicator/Black/4".texture = textures_P2_buttons[0]
	if Input.is_action_just_released("P2_5"):
		$ControlsText/ControlP2/Controls/Center/B5.set("theme_override_colors/font_color", base_color)
		$"GamepadBox/GamepadIndicator/Black/5".texture = textures_P2_buttons[0]
	if Input.is_action_just_released("P2_6"):
		$ControlsText/ControlP2/Controls/Right/B6.set("theme_override_colors/font_color", base_color)
		$"GamepadBox/GamepadIndicator/Black/6".texture = textures_P2_buttons[0]

func check_p1_stick():
	if Input.is_action_pressed("P1_up"):
		$"GamepadBox/GamepadIndicator/StickP1".texture = textures_P1_stick[1]
		$ControlsText/ControlP1/Controls/Stick.set("theme_override_colors/font_color", pressed_color)
	elif Input.is_action_pressed("P1_down"):
		$"GamepadBox/GamepadIndicator/StickP1".texture = textures_P1_stick[2]
		$ControlsText/ControlP1/Controls/Stick.set("theme_override_colors/font_color", pressed_color)
	elif Input.is_action_pressed("P1_left"):
		$"GamepadBox/GamepadIndicator/StickP1".texture = textures_P1_stick[3]
		$ControlsText/ControlP1/Controls/Stick.set("theme_override_colors/font_color", pressed_color)
	elif Input.is_action_pressed("P1_right"):
		$"GamepadBox/GamepadIndicator/StickP1".texture = textures_P1_stick[4]
		$ControlsText/ControlP1/Controls/Stick.set("theme_override_colors/font_color", pressed_color)
	else:
		$"GamepadBox/GamepadIndicator/StickP1".texture = textures_P1_stick[0]
		$ControlsText/ControlP1/Controls/Stick.set("theme_override_colors/font_color", base_color)

func check_p2_stick():
	if Input.is_action_pressed("P2_up"):
		$"GamepadBox/GamepadIndicator/StickP2".texture = textures_P2_stick[1]
		$ControlsText/ControlP2/Controls/Stick.set("theme_override_colors/font_color", pressed_color)
	elif Input.is_action_pressed("P2_down"):
		$"GamepadBox/GamepadIndicator/StickP2".texture = textures_P2_stick[2]
		$ControlsText/ControlP2/Controls/Stick.set("theme_override_colors/font_color", pressed_color)
	elif Input.is_action_pressed("P2_left"):
		$"GamepadBox/GamepadIndicator/StickP2".texture = textures_P2_stick[3]
		$ControlsText/ControlP2/Controls/Stick.set("theme_override_colors/font_color", pressed_color)
	elif Input.is_action_pressed("P2_right"):
		$"GamepadBox/GamepadIndicator/StickP2".texture = textures_P2_stick[4]
		$ControlsText/ControlP2/Controls/Stick.set("theme_override_colors/font_color", pressed_color)
	else:
		$"GamepadBox/GamepadIndicator/StickP2".texture = textures_P2_stick[0]
		$ControlsText/ControlP2/Controls/Stick.set("theme_override_colors/font_color", base_color)

func _process(delta: float) -> void:
	check_p1_buttons()
	check_p2_buttons()
	check_p1_stick()
	check_p2_stick()

func _on_game_selected(id: int) -> void:
	$"ControlsText/ControlP1/Controls/Stick".text = get_string(id, 0)
	$ControlsText/ControlP1/Controls/Left/B1.text = get_string(id, 1)
	$ControlsText/ControlP1/Controls/Center/B2.text = get_string(id, 2)
	$ControlsText/ControlP1/Controls/Right/B3.text = get_string(id, 3)
	$ControlsText/ControlP1/Controls/Left/B4.text = get_string(id, 4)
	$ControlsText/ControlP1/Controls/Center/B5.text = get_string(id, 5)
	$ControlsText/ControlP1/Controls/Right/B6.text = get_string(id, 6)

	$ControlsText/ControlP2/Controls/Stick.text = get_string(id, 7)
	$ControlsText/ControlP2/Controls/Left/B1.text = get_string(id, 8)
	$ControlsText/ControlP2/Controls/Center/B2.text = get_string(id, 9)
	$ControlsText/ControlP2/Controls/Right/B3.text = get_string(id, 10)
	$ControlsText/ControlP2/Controls/Left/B4.text = get_string(id, 11)
	$ControlsText/ControlP2/Controls/Center/B5.text = get_string(id, 12)
	$ControlsText/ControlP2/Controls/Right/B6.text = get_string(id, 13)

func _ready() -> void:
	BusEvent.connect("GAME_SELECTED", _on_game_selected)
