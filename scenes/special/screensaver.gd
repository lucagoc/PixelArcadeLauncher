extends Control

func _on_screensaver_start():
	$SelfAnimation.play("screensaver_in")

func _on_screensaver_stop():
	$SelfAnimation.play("screensaver_out")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BusEvent.connect("START_SCREENSAVER", _on_screensaver_start)
	BusEvent.connect("STOP_SCREENSAVER", _on_screensaver_stop)
	
	$BackgroundAnimation.play("breath")
