extends Node

#Simple script that listens for joystick movements from device 0 and interprets them as UI movements

#use some variables to keep track of if a certain joystick direction has been pressed this tick already
#this allows us to use _input(event) to check for new joystick inputs, rather than doing constant polling in _process
var joystickLeftThisTick : bool = false
var joystickRightThisTick : bool = false
var joystickUpThisTick : bool = false
var joystickDownThisTick : bool = false

const THRESHOLD = 0.5
const TICK = 0.15

var threshold_timer : Timer
var tick_timer : Timer

func _process(delta):
	#Check any joystick directions that were held, and if they are no longer
	#held, reset them (including the input events)
	if joystickLeftThisTick && !Input.is_action_pressed("ui_left_joystick"):
		joystickLeftThisTick = false
		var uiEvent = InputEventAction.new()
		uiEvent.action = "ui_left"
		uiEvent.pressed = false
		Input.parse_input_event(uiEvent)
		
	if joystickRightThisTick && !Input.is_action_pressed("ui_right_joystick"):
		joystickRightThisTick = false
		var uiEvent = InputEventAction.new()
		uiEvent.action = "ui_right"
		uiEvent.pressed = false
		Input.parse_input_event(uiEvent)
		
	if joystickUpThisTick && !Input.is_action_pressed("ui_up_joystick"):
		joystickUpThisTick = false
		var uiEvent = InputEventAction.new()
		uiEvent.action = "ui_up"
		uiEvent.pressed = false
		Input.parse_input_event(uiEvent)
		
	if joystickDownThisTick && !Input.is_action_pressed("ui_down_joystick"):
		joystickDownThisTick = false
		var uiEvent = InputEventAction.new()
		uiEvent.action = "ui_down"
		uiEvent.pressed = false
		Input.parse_input_event(uiEvent)

	if threshold_timer.is_stopped() && tick_timer.is_stopped() && (joystickLeftThisTick || joystickRightThisTick || joystickUpThisTick || joystickDownThisTick):
		threshold_timer.start()
	
	if not (joystickLeftThisTick || joystickRightThisTick || joystickUpThisTick || joystickDownThisTick):
		threshold_timer.stop()

#Use the Input's action_just_pressed to avoid duplicate calls
func _input(event):
	if !joystickLeftThisTick && Input.is_action_just_pressed("ui_left_joystick"):
		joystickLeftThisTick = true
		var uiEvent = InputEventAction.new()
		uiEvent.action = "ui_left"
		uiEvent.pressed = true
		Input.parse_input_event(uiEvent)
		
	if !joystickRightThisTick && Input.is_action_just_pressed("ui_right_joystick"):
		joystickRightThisTick = true
		var uiEvent = InputEventAction.new()
		uiEvent.action = "ui_right"
		uiEvent.pressed = true
		Input.parse_input_event(uiEvent)
		
	if !joystickUpThisTick && Input.is_action_just_pressed("ui_up_joystick"):
		joystickUpThisTick = true
		var uiEvent = InputEventAction.new()
		uiEvent.action = "ui_up"
		uiEvent.pressed = true
		Input.parse_input_event(uiEvent)
		
	if !joystickDownThisTick && Input.is_action_just_pressed("ui_down_joystick"):
		joystickDownThisTick = true
		var uiEvent = InputEventAction.new()
		uiEvent.action = "ui_down"
		uiEvent.pressed = true
		Input.parse_input_event(uiEvent)

func _on_action_timeout() -> void:
	if joystickLeftThisTick:
		var uiEvent = InputEventAction.new()
		uiEvent.action = "ui_left"
		uiEvent.pressed = true
		Input.parse_input_event(uiEvent)
	elif joystickRightThisTick:
		var uiEvent = InputEventAction.new()
		uiEvent.action = "ui_right"
		uiEvent.pressed = true
		Input.parse_input_event(uiEvent)
	elif joystickUpThisTick:
		var uiEvent = InputEventAction.new()
		uiEvent.action = "ui_up"
		uiEvent.pressed = true
		Input.parse_input_event(uiEvent)
	elif joystickDownThisTick:
		var uiEvent = InputEventAction.new()
		uiEvent.action = "ui_down"
		uiEvent.pressed = true
		Input.parse_input_event(uiEvent)
	else:
		tick_timer.stop()

func _on_threshold_timeout() -> void:
	tick_timer.start()

func _ready() -> void:
	# Creating a timer to wait for the joystick to be held down
	threshold_timer = Timer.new()
	threshold_timer.set_wait_time(THRESHOLD)
	threshold_timer.set_one_shot(true)
	threshold_timer.connect("timeout", _on_threshold_timeout)
	add_child(threshold_timer)

	# Creating a timer to repeat the action when the joystick is held down
	tick_timer = Timer.new()
	tick_timer.set_wait_time(TICK)
	tick_timer.set_one_shot(false)
	tick_timer.connect("timeout", _on_action_timeout)
	add_child(tick_timer)
