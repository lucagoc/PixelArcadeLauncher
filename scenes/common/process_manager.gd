extends Node

# Common node to manage the process currently running
var running_process = null
var game_id = -1
var game_running = false

func set_game(id: int) -> void:
	game_id = id
	
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
