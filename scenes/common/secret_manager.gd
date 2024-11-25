extends Node

# File dedicated to Secret Settings and Easter Eggs. Activated using key combinaison.

var konami_code = []

var game_selection_count = 0

func _on_game_selected(id: int):
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
func _process(delta: float) -> void:
	pass

	if game_selection_count > 10:
		BusEvent.emit_signal("START_SECRET_SHAKE")
