##############################################################
#                     Process Manager                        #
#          Manage the game process currently running         #
##############################################################

extends Node

# Common node to manage the process currently running
var _running_process = null # Process currently running
var _running_game = -1 # -1 no game running, others = game running


# Launch game on a new thread
func _launch_game_linux(game) -> void:
	var _path = game.path + "files/" + game.exec
	_running_process = OS.create_process(_path, [])
	print("[INFO] Game running with PID: " + str(_running_process))

# Launch game in a blocking way
func _launch_game_mame(game) -> void:
	var args = [game.exec, "-homepath", Settings.get_setting("General", "mame_plugins_home")]
	print("[LAUNCH_GAME] Executing : " + game.exec + " " + args[0] + " " + args[1] + " " + args[2])
	_running_process = OS.execute("mame", args)
	BusEvent.emit_signal("GAME_EXITED", _running_game)

# Launch game in a blocking way [EXP]
func _launch_game_flycast(game) -> void:
	var args = [game.path + "roms/" + game.exec + ".zip"]
	_running_process = OS.execute("$HOME/PixelArcadeLauncher/" + "emulators/flycast-x86_64.AppImage", args)

# Called when the game is exited
func _on_game_exited(_id: int) -> void:
	print("[DEBUG] Game exited: " + str(_id))
	_running_game = -1

@warning_ignore("unused_parameter")
func _process(delta):
	if _running_game != -1 and Input.is_action_just_pressed("exit_game"):
		OS.kill(_running_process)
		BusEvent.emit_signal("GAME_EXITED", _running_game)

func _on_timeout():
	if _running_game != -1 and not OS.is_process_running(_running_process):
		BusEvent.emit_signal("GAME_EXITED", _running_game)

func _ready():
	BusEvent.connect("GAME_EXITED", _on_game_exited)

	# Create a timer that will check if the game is still running
	var timer = Timer.new()
	timer.set_wait_time(1)
	timer.set_one_shot(false)
	timer.connect("timeout", _on_timeout)
	add_child(timer)

func is_game_running() -> bool:
	return _running_game != -1

# Take the game_id and launch the game
func launch_game(game_id) -> void:
	if game_id < 0:
		printerr("[LAUNCH_GAME] Invalid game_id: " + str(game_id))
	else:
		var game = GameList.GAME_LIST[game_id]
		_running_game = game_id

		if game.platform == "mame":
			_launch_game_mame(game)
		
		elif game.platform == "linux":
			_launch_game_linux(game)
		
		elif game.platform == "windows":
			printerr("[LAUNCH_GAME] Windows is currently not supported, please wait until next update for wine support.")
			BusEvent.emit_signal("GAME_EXITED", _running_game)

		elif game.platform == "flycast":
			_launch_game_flycast(game)
			BusEvent.emit_signal("GAME_EXITED", _running_game)

		else:
			printerr("[LAUNCH_GAME] Platform not supported: " + game.platform)
			BusEvent.emit_signal("GAME_EXITED", _running_game)
