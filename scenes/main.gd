extends Control

# Load the settings from the settings.conf file
func preload_data():
	# Check if the launcher folder exists
	var dir = DirAccess.open(Path.data)
	if dir == null:
		print("[WARNING] Folder " + Path.data + " not found, creating a new one...")
		DirAccess.make_dir_absolute(Path.data)
		DirAccess.make_dir_absolute(Path.data + Path.games_folder)
		Settings.save_settings()	
	else:
		print("Folder " + Path.data + " found")

	# Check if the settings file exists and load it
	var setting_file = FileAccess.open(Path.data + Path.settings_file, FileAccess.READ)
	if setting_file == null:
		print("[WARNING] settings.conf not found, creating a new one...")
		Settings.save_settings()
	else:
		print("settings.conf found, loading...")
		Settings.load_settings()
		Settings.apply_settings()
	if setting_file != null:
		setting_file.close()

# Start the loading screen
func start_loading():
	print("PixelArcadeLauncher is starting...")
	$LoadingScreen.show()
	$LoadingScreen/Mouse/AnimatedSprite2D.play("mouseRun")
	$Home.hide()
	$AnimationPlayer.play("loading_start")

# End the loading screen
func end_loading():
	$AnimationPlayer.play("loading_end")
	BusEvent.emit_signal("SELECT_GAME", 0)
	print("[SUCCESS] PixelArcadeLauncher has been loaded successfully !")

# Console commands for debugging
func add_console_commands():
	pass

func _on_scaling_changed(scaling: float) -> void:
	get_tree().root.content_scale_factor = scaling

func _on_secret_shake() -> void:
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("shake")

func _on_loading_screen_ended():
	end_loading()

func _ready():
	start_loading()
	
	add_console_commands()
	BusEvent.connect("SCALING_CHANGED", _on_scaling_changed)
	BusEvent.connect("START_SECRET_SHAKE", _on_secret_shake)
	BusEvent.connect("LOADING_SCREEN_ENDED", _on_loading_screen_ended)
	preload_data()
	GameList.reload()

	if Settings.get_setting("Maintenance", "enabled"):
		get_tree().change_scene_to_file("res://scenes/special/maintenance_screen.tscn")

var quitting = false

func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		if not quitting:
			var state = $AnimationPlayer.get_current_animation_position()
			$AnimationPlayer.play("black_out")
			$AnimationPlayer.speed_scale = 1
			$AnimationPlayer.seek(state)
			quitting = true
	else:
		if quitting:
			var state = $AnimationPlayer.get_current_animation_position()
			$AnimationPlayer.play_backwards("black_out")
			$AnimationPlayer.speed_scale = 2
			$AnimationPlayer.seek(state)
			quitting = false

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if quitting:
		get_tree().quit()
