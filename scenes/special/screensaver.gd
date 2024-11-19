extends Control

func _on_screensaver_start():
	$SelfAnimation.play("screensaver_in")

func _on_screensaver_stop():
	$SelfAnimation.play("screensaver_out")

func _on_game_selection(id: int):
	var r = randi()%5
	if r == 0:
		$Logo.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	elif r == 1:
		$Logo.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	elif r == 2:
		$Logo.set_anchors_preset(Control.PRESET_CENTER)
	elif r == 3:
		$Logo.set_anchors_preset(Control.PRESET_TOP_LEFT)
	else:
		$Logo.set_anchors_preset(Control.PRESET_TOP_RIGHT)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BusEvent.connect("START_SCREENSAVER", _on_screensaver_start)
	BusEvent.connect("STOP_SCREENSAVER", _on_screensaver_stop)
	BusEvent.connect("GAME_SELECTED", _on_game_selection)
	
	$BackgroundAnimation.play("breath")
