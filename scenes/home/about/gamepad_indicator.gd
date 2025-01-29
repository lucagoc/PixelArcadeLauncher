extends HBoxContainer

@export var textures_P1_stick : Array[Texture] = []
@export var textures_P1_buttons : Array[Texture] = []
@export var textures_P2_stick : Array[Texture] = []
@export var textures_P2_buttons : Array[Texture] = []

func check_p1_buttons():
	if Input.is_action_just_pressed("P1_1"):
		$"White/1".texture = textures_P1_buttons[1]
	if Input.is_action_just_pressed("P1_2"):
		$"White/2".texture = textures_P1_buttons[1]
	if Input.is_action_just_pressed("P1_3"):
		$"White/3".texture = textures_P1_buttons[1]
	if Input.is_action_just_pressed("P1_4"):
		$"White/4".texture = textures_P1_buttons[1]
	if Input.is_action_just_pressed("P1_5"):
		$"White/5".texture = textures_P1_buttons[1]
	if Input.is_action_just_pressed("P1_6"):
		$"White/6".texture = textures_P1_buttons[1]
	
	if Input.is_action_just_released("P1_1"):
		$"White/1".texture = textures_P1_buttons[0]
	if Input.is_action_just_released("P1_2"):
		$"White/2".texture = textures_P1_buttons[0]
	if Input.is_action_just_released("P1_3"):
		$"White/3".texture = textures_P1_buttons[0]
	if Input.is_action_just_released("P1_4"):	
		$"White/4".texture = textures_P1_buttons[0]
	if Input.is_action_just_released("P1_5"):
		$"White/5".texture = textures_P1_buttons[0]
	if Input.is_action_just_released("P1_6"):
		$"White/6".texture = textures_P1_buttons[0]

func check_p2_buttons():
	if Input.is_action_just_pressed("P2_1"):
		$"Black/1".texture = textures_P2_buttons[1]
	if Input.is_action_just_pressed("P2_2"):
		$"Black/2".texture = textures_P2_buttons[1]
	if Input.is_action_just_pressed("P2_3"):
		$"Black/3".texture = textures_P2_buttons[1]
	if Input.is_action_just_pressed("P2_4"):
		$"Black/4".texture = textures_P2_buttons[1]
	if Input.is_action_just_pressed("P2_5"):
		$"Black/5".texture = textures_P2_buttons[1]
	if Input.is_action_just_pressed("P2_6"):
		$"Black/6".texture = textures_P2_buttons[1]
	
	if Input.is_action_just_released("P2_1"):
		$"Black/1".texture = textures_P2_buttons[0]
	if Input.is_action_just_released("P2_2"):
		$"Black/2".texture = textures_P2_buttons[0]
	if Input.is_action_just_released("P2_3"):
		$"Black/3".texture = textures_P2_buttons[0]
	if Input.is_action_just_released("P2_4"):
		$"Black/4".texture = textures_P2_buttons[0]
	if Input.is_action_just_released("P2_5"):
		$"Black/5".texture = textures_P2_buttons[0]
	if Input.is_action_just_released("P2_6"):
		$"Black/6".texture = textures_P2_buttons[0]

func check_p1_stick():
	if Input.is_action_pressed("P1_up"):
		$StickP1.texture = textures_P1_stick[1]
	elif Input.is_action_pressed("P1_down"):
		$StickP1.texture = textures_P1_stick[2]
	elif Input.is_action_pressed("P1_left"):
		$StickP1.texture = textures_P1_stick[3]
	elif Input.is_action_pressed("P1_right"):
		$StickP1.texture = textures_P1_stick[4]
	else:
		$StickP1.texture = textures_P1_stick[0]

func check_p2_stick():
	if Input.is_action_pressed("P2_up"):
		$StickP2.texture = textures_P2_stick[1]
	elif Input.is_action_pressed("P2_down"):
		$StickP2.texture = textures_P2_stick[2]
	elif Input.is_action_pressed("P2_left"):
		$StickP2.texture = textures_P2_stick[3]
	elif Input.is_action_pressed("P2_right"):
		$StickP2.texture = textures_P2_stick[4]
	else:
		$StickP2.texture = textures_P2_stick[0]

func _process(delta: float) -> void:
	check_p1_buttons()
	check_p2_buttons()
	check_p1_stick()
	check_p2_stick()
