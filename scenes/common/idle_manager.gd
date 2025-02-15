extends Node

var idling = true				# Default to idling
var screensaver = false

var IDLE_TIME = 30				# 30 seconds 	Time to wait before idle mode
var AUTO_SCROLL_TIME = 5		# 5 seconds		Delay between auto scrolling
var SCREENSAVER_TIME = 120		# 2 minutes		Time to wait before screensaver (Logo)
var ECOMODE_TIME = 600			# 10 minutes		Time to activate ECO mode.
var ecomode_enabled = true

func _on_idle_timeout() -> void:
	if not idling:
		if !ProcessManager.is_game_running():
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

func _on_ecomode_timeout() -> void:
	if idling and ecomode_enabled:
		BusEvent.emit_signal("ECOMODE_ACTIVATED")
		await get_tree().create_timer(1.0).timeout
		OS.execute("wlr-randr", ["--output", "HDMI-A-1", "--off"])

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
	
		# Set up the screensaver timer
	var ecomode_timer = Timer.new()
	ecomode_timer.set_wait_time(ECOMODE_TIME)
	ecomode_timer.set_one_shot(true)
	ecomode_timer.connect("timeout", _on_ecomode_timeout)
	ecomode_timer.name = "ecomode_timer"
	add_child(ecomode_timer)
	ecomode_timer.start()

func _process(_delta: float) -> void:
	# Reset the idle timer a key is pressed
	if Input.is_action_pressed("stop_idle") || Input.is_action_pressed("ui_up_joystick") || Input.is_action_pressed("ui_down_joystick") || Input.is_action_pressed("ui_left_joystick") || Input.is_action_pressed("ui_right_joystick"):
		idling = false

		$idle_timer.stop()
		$idle_timer.start()
		
		$screensaver_timer.stop()
		$screensaver_timer.start()
		
		$ecomode_timer.stop()
		$ecomode_timer.start()
		
		if screensaver:
			BusEvent.emit_signal("STOP_SCREENSAVER")
			if ecomode_enabled:
				OS.execute("wlr-randr", ["--output", "HDMI-A-1", "--on"])
