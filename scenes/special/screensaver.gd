extends Control

func _on_screensaver_start():
	$SelfAnimation.play("screensaver_in")
	$BackgroundAnimation.play("breath")

func _on_screensaver_stop():
	$SelfAnimation.play("screensaver_out")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BusEvent.connect("START_SCREENSAVER", _on_screensaver_start)
	BusEvent.connect("STOP_SCREENSAVER", _on_screensaver_stop)
	
	$LabelAnimation.play("blink")


func _on_background_animation_animation_finished(_anim_name: StringName) -> void:
	BusEvent.emit_signal("AUTO_SCROLL")
	$BackgroundAnimation.play("breath")


func _on_timer_timeout() -> void:
	$MainVbox/CenterBox/Time.text = Time.get_time_string_from_system()


func _on_self_animation_animation_finished(anim_name: StringName) -> void:
	if(anim_name == "screensaver_out"):
		$BackgroundAnimation.stop()
		IdleManager.screensaver = false
