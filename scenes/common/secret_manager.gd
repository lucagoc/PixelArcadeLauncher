##############################################################
#                     Secret Manager	                     #
#   Manage different easter eggs and secret combinaition     #
##############################################################

extends Node

# File dedicated to Secret Settings and Easter Eggs. Activated using key combinaison.

var konami_code = ["ui_up_joystick", "ui_up_joystick", "ui_down_joystick", "ui_down_joystick", "ui_left_joystick", "ui_right_joystick", "ui_left_joystick", "ui_right_joystick", "ui_a", "ui_b"]
var progress_code = 0

var game_selection_count = 0

func _on_game_selected(_id: int):
	if game_selection_count < 13:
		game_selection_count += 1

func _on_timer_timeout():
	if game_selection_count > 0:
		game_selection_count -= 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BusEvent.connect("GAME_SELECTED", _on_game_selected)

	# Create a timer to decrease the game selection count
	var timer = Timer.new()
	timer.set_wait_time(0.05)
	timer.connect("timeout", _on_timer_timeout)
	add_child(timer)
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:

	# Shake the screen when the secret is activated
	if game_selection_count > 10:
		BusEvent.emit_signal("START_SECRET_SHAKE")
	
	
	# Check if the Konami code is activated
	if Input.is_action_just_pressed(konami_code[progress_code]):
		progress_code += 1
		if progress_code == konami_code.size():
			BusEvent.emit_signal("KONAMI_ACTIVATED")
			progress_code = 0
	elif Input.is_action_just_pressed("stop_idle"):
		progress_code = 0
