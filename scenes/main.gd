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

func _on_scaling_changed(scale: float) -> void:
	get_tree().root.content_scale_factor = scale

func _on_secret_shake() -> void:
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("shake")

func _ready():
	start_loading()
	
	add_console_commands()
	BusEvent.connect("SCALING_CHANGED", _on_scaling_changed)
	BusEvent.connect("START_SECRET_SHAKE", _on_secret_shake)
	preload_data()
	GameList.reload()

	end_loading()
	
	if Settings.maintenance.enabled:
		get_tree().change_scene_to_file("res://scenes/special/maintenance_screen.tscn")

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
