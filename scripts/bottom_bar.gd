extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_refresh_timer_timeout() -> void:
	$BottomHbox/RamLabel.text = "RAM: " + str(OS.get_static_memory_usage() / 1024 / 1024) + " MB"
	$BottomHbox/TimeLabel.text = Time.get_time_string_from_system()
	$BottomHbox/VersionLabel.text = "Version: 0.1 TESTING"
