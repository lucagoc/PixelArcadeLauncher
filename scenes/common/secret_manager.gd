##############################################################
#                     Secret Manager	                     #
#   Manage different easter eggs and secret combinaition     #
##############################################################

extends Node

# File dedicated to Secret Settings and Easter Eggs. Activated using key combinaison.

var konami_code = ["P1_3", "P1_4", "P1_6", "P1_1", "P1_2", "P1_5", "P1_6", "P1_6", "P1_6"]
var progress_code = 0

var game_selection_count = 0

func _on_game_selected(_id: int):
	if game_selection_count < 13:
		game_selection_count += 1

func _on_timer_timeout():
	if game_selection_count > 0:
		game_selection_count -= 1

func _on_main_inited():
	# :)
	var date = Time.get_date_dict_from_system()
	if date.month == 12:
		BusEvent.emit_signal("CHRISTMAS_MODE")
	elif date.month == 4 and date.day == 1:
		BusEvent.emit_signal("APRIL_FOOLS_MODE")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BusEvent.connect("GAME_SELECTED", _on_game_selected)
	BusEvent.connect("MAIN_INITED", _on_main_inited)
	
	# Create a timer to decrease the game selection count
	var timer = Timer.new()
	timer.set_wait_time(0.05)
	timer.connect("timeout", _on_timer_timeout)
	add_child(timer)
	timer.start()

	# :)
	var date = Time.get_date_dict_from_system()
	if date.month == 4 and date.day == 1:
		TranslationServer.set_locale("ru")
	if (Input.is_action_just_pressed("P1_3") or Input.is_action_just_pressed("P2_3")):
		TranslationServer.set_locale("jp")


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
