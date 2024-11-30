extends Node

# Common node to manage the process currently running
var running_process = null
var game_id = -1
var game_running = false

func set_game(id: int) -> void:
	game_id = id

func launch_game_linux(game) -> void:
	running_process = OS.execute(game.exec, [])


func launch_game() -> void:
	if game_id == -1:
		print("[ERROR] No game selected")
	else:
		var game = GameList.GAME_LIST[game_id]
		var args = []

		if game.platform == "mame":
			args = ["-homepath", Settings.general.mame_plugins_home]
			print("[INFO] MAME homepath: " + Settings.general.mame_plugins_home)
			# Launch the game
			print("[INFO] Launching game: " + game.name)
			running_process = OS.execute(game.exec, args)
			# Emit the signal when exited
			BusEvent.emit_signal("GAME_EXITED", game_id)
		
		elif game.platform == "linux":
			# Create a new thread to launch the game
			game_running = true
			running_process = OS.create_process(game.exec, [])
			print("[INFO] Game running with PID: " + str(running_process))

func _process(delta):
	if Input.is_action_just_pressed("exit_game"):
		print("[INFO] Exit game")
		if game_running:
			# Kill the game process
			OS.kill(running_process)
			game_running = false
			BusEvent.emit_signal("GAME_EXITED", game_id)