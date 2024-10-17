extends ColorRect

func _on_refresh_timer_timeout() -> void:
	$BottomHbox/RamLabel.text = "RAM: " + str(int(OS.get_static_memory_usage() / 1024.0 / 1024.0)) + " MB"
	$BottomHbox/TimeLabel.text = Time.get_time_string_from_system()
	$BottomHbox/VersionLabel.text = "0.2 WorldMachine" # 0.1 HelloWorld
