extends Node

var idling = false
var screensaver = false

var IDLE_TIME = 30				# 30 seconds 	Time to wait before idle mode
var AUTO_SCROLL_TIME = 5		# 5 seconds		Delay between auto scrolling
var SCREENSAVER_TIME = 120		# 2 minutes		Time to wait before screensaver (Logo)
var SCREENSAVER_2_TIME = 240 	# 4 minutes		Time to wait before screensaver (Hero images)

func _on_idle_timeout() -> void:
	if not idling:
		print("[INFO] Idling...")
		idling = true

# Automatically scroll through banners on idle.
func _on_auto_scroll_timeout() -> void:
	if idling and not screensaver:
		BusEvent.emit_signal("AUTO_SCROLL")

func _on_screensaver_timeout() -> void:
	if idling:
		BusEvent.emit_signal("START_SCREENSAVER")
		screensaver = true

func _on_screensaver_2_timeout() -> void:
	if idling:
		BusEvent.emit_signal("START_SCREENSAVER_2")
		screensaver = true

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

	# Set up the screensaver timer
	var screensaver_timer = Timer.new()
	screensaver_timer.set_wait_time(SCREENSAVER_TIME)
	screensaver_timer.set_one_shot(true)
	screensaver_timer.connect("timeout", _on_screensaver_timeout)
	screensaver_timer.name = "screensaver_timer"
	add_child(screensaver_timer)
	screensaver_timer.start()

	# Set up the screensaver 2 timer
	var screensaver_2_timer = Timer.new()
	screensaver_2_timer.set_wait_time(SCREENSAVER_2_TIME)
	screensaver_2_timer.set_one_shot(true)
	screensaver_2_timer.connect("timeout", _on_screensaver_2_timeout)
	screensaver_2_timer.name = "screensaver_2_timer"
	add_child(screensaver_2_timer)
	screensaver_2_timer.start()

func _process(delta: float) -> void:
	# Reset the idle timer a key is pressed
	if Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
		idling = false

		$idle_timer.stop()
		$idle_timer.start()
		
		$screensaver_timer.stop()
		$screensaver_timer.start()
		
		$screensaver_2_timer.stop()
		$screensaver_2_timer.start()
		
		if screensaver:
			BusEvent.emit_signal("STOP_SCREENSAVER")
			screensaver = false
