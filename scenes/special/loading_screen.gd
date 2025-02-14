extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$ProgressBar.value = ($MinDelay.wait_time - ($MinDelay.time_left/$MinDelay.wait_time))*100


func _on_min_delay_timeout() -> void:
	BusEvent.emit_signal("LOADING_SCREEN_ENDED")
