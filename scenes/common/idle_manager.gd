extends Node

var idling = false

var IDLE_TIME = 30
var AUTO_SCROLL_TIME = 5

func _on_idle_timeout() -> void:
	if not idling:
		print("[INFO] Idling...")
		idling = true

# Automatically scroll through banners on idle.
func _on_auto_scroll_timeout() -> void:
	if idling:
		BusEvent.emit_signal("AUTO_SCROLL")

func _ready() -> void:

	# Set up the idle timer
	var idle_timer = Timer.new()
	idle_timer.set_wait_time(IDLE_TIME)
	idle_timer.set_one_shot(true)
	idle_timer.connect("timeout", _on_idle_timeout)
	idle_timer.name = "idle_timer"
	add_child(idle_timer)
	idle_timer.start()

	# Set up the auto scroll timer
	var auto_scroll_timer = Timer.new()
	auto_scroll_timer.set_wait_time(AUTO_SCROLL_TIME)
	auto_scroll_timer.set_one_shot(false)
	auto_scroll_timer.connect("timeout", _on_auto_scroll_timeout)
	auto_scroll_timer.name = "auto_scroll_timer"
	add_child(auto_scroll_timer)
	auto_scroll_timer.start()

func _process(delta: float) -> void:
	# Reset the idle timer a key is pressed
	if Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
		$idle_timer.stop()
		$idle_timer.start()
		idling = false
